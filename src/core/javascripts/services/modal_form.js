(function () {


    let newForm = function ($scope, $uibModalInstance, company, title, new_rel, post_rel, successFn, failFn, $document, $log) {
        $scope.loading = true;
        $scope.title = title;
        $scope.company = company;
        if ($scope.company.$has(new_rel)) {
            $scope.company.$get(new_rel).then(function (schema) {
                $scope.form = _.reject(schema.form, x => x.type === 'submit');
                $scope.schema = checkSchema(schema.schema);
                $scope.form_model = {};
                return $scope.loading = false;
            });
        } else {
            $log.warn(`company does not have '${new_rel}' rel`);
        }

        $scope.submit = function (form) {
            $scope.$broadcast('schemaFormValidate');
            $scope.loading = true;
            return $scope.company.$post(post_rel, {}, $scope.form_model).then(function (model) {
                    $scope.loading = false;
                    $uibModalInstance.close(model);
                    if (successFn) {
                        return successFn(model);
                    }
                }
                , function (err) {
                    $scope.loading = false;
                    $uibModalInstance.close(err);
                    $log.error('Failed to create');
                    if (failFn) {
                        return failFn(err);
                    }
                });
        };

        return $scope.cancel = function (event) {
            event.preventDefault();
            event.stopPropagation();
            return $uibModalInstance.dismiss('cancel');
        };
    };


    // THIS IS CRUFTY AND SHOULD BE REMOVE WITH AN API UPDATE THAT TIDIES UP THE SCEMA RESPONE
    // fix the issues we have with the the sub client and question blocks being in doted notation, and not in child objects
    let checkSchema = function (schema) {
        for (let k in schema.properties) {
            let v = schema.properties[k];
            let vals = k.split(".");
            if ((vals[0] === "questions") && (vals.length > 1)) {
                if (!schema.properties.questions) {
                    schema.properties.questions = {type: "object", properties: {}};
                }
                if (!schema.properties.questions.properties[vals[1]]) {
                    schema.properties.questions.properties[vals[1]] = {type: "object", properties: {answer: v}};
                }
            }
            if ((vals[0] === "client") && (vals.length > 2)) {
                if (!schema.properties.client) {
                    schema.properties.client = {type: "object", properties: {q: {type: "object", properties: {}}}};
                }
                if (schema.properties.client.properties) {
                    if (!schema.properties.client.properties.q.properties[vals[2]]) {
                        schema.properties.client.properties.q.properties[vals[2]] = {
                            type: "object",
                            properties: {answer: v}
                        };
                    }
                }
            }
        }
        return schema;
    };


    let editForm = function ($scope, $uibModal, $uibModalInstance, model, title, successFn, failFn, params, $document, $log, Dialog, FormTransform, $translate) {
        $scope.loading = true;
        $scope.title = title;
        $scope.model = model;
        if (!params) {
            params = {};
        }
        if ($scope.model.$has('edit')) {
            $scope.model.$get('edit', params).then(schema => {
                    $scope.form = _.reject(schema.form, x => x.type === 'submit');
                    let model_type = functionName(model.constructor);
                    if (model_type === 'Object' && model.type) {
                        model_type = model.type;
                    }
                    if (FormTransform['edit'][model_type]) {
                        $scope.form = FormTransform['edit'][model_type]($scope.form, schema.schema, $scope.model);
                    }
                    $scope.schema = checkSchema(schema.schema);
                    $scope.form_model = $scope.model;
                    return $scope.loading = false;
                }
            );
        } else {
            $log.warn("model does not have 'edit' rel");
        }


        var functionName = function (func) {
            let result = /^function\s+([\w\$]+)\s*\(/.exec(func.toString());
            if (result) {
                return result[1];
            } else {
                return '';
            }
        };

        $scope.submit = function (form) {
            $scope.$broadcast('schemaFormValidate');
            $scope.loading = true;
            if ($scope.model.$update) {
                return $scope.model.$update($scope.form_model).then(function () {
                        $scope.loading = false;
                        $uibModalInstance.close($scope.model);
                        if (successFn) {
                            return successFn($scope.model);
                        }
                    }
                    , function (err) {
                        $scope.loading = false;
                        $uibModalInstance.close(err);
                        $log.error('Failed to create');
                        if (failFn) {
                            return failFn();
                        }
                    });
            } else {
                return $scope.model.$put('self', {}, $scope.form_model).then(function (model) {
                        $scope.loading = false;
                        $uibModalInstance.close(model);
                        if (successFn) {
                            return successFn(model);
                        }
                    }
                    , function (err) {
                        $scope.loading = false;
                        $uibModalInstance.close(err);
                        $log.error('Failed to create');
                        if (failFn) {
                            return failFn();
                        }
                    });
            }
        };

        $scope.cancel = function (event) {
            event.preventDefault();
            event.stopPropagation();
            return $uibModalInstance.dismiss('cancel');
        };

        $scope.success = function (response) {
            event.preventDefault();
            event.stopPropagation();
            $uibModalInstance.close();
            if (successFn) {
                return successFn(response);
            }
        };


        return $scope.cancelEvent = function (event, type) {
            if (type == null) {
                type = 'booking';
            }
            event.preventDefault();
            event.stopPropagation();
            $uibModalInstance.close();
            if (type === 'booking') {
                let modal_instance = $uibModal.open({

                    templateUrl: 'cancel_booking_modal_form.html',
                    controller($scope, booking) {
                        $scope.booking = booking;
                        return $scope.model = {
                            notify: false,
                            cancel_reason: null
                        };
                    },
                    resolve: {
                        booking() {
                            return model;
                        }
                    }
                });
                return modal_instance.result.then(params =>
                    model.$post('cancel', params).then(function (booking) {
                        if (successFn) {
                            return successFn(booking);
                        }
                    })
                );
            } else {
                let question = null;
                question = $translate.instant('CORE.MODAL.CANCEL_BOOKING.QUESTION', {type});

                return Dialog.confirm({
                    model,
                    title: $translate.instant('CORE.MODAL.CANCEL_BOOKING.HEADER'),
                    body: question,
                    success(model) {
                        return model.$del('self').then(function (response) {
                            if (successFn) {
                                return successFn(response);
                            }
                        });
                    }
                });
            }
        };
    };

    let bookForm = function ($scope, $uibModalInstance, model, company, title, successFn, $document, $log) {
        $scope.loading = true;
        $scope.title = title;
        $scope.model = model;
        $scope.company = company;
        if ($scope.model.$has('new_booking')) {
            $scope.model.$get('new_booking').then(function (schema) {
                $scope.form = _.reject(schema.form, x => x.type === 'submit');
                $scope.schema = checkSchema(schema.schema);
                $scope.form_model = {};
                return $scope.loading = false;
            });
        } else {
            $log.warn("model does not have 'new_booking' rel");
        }

        $scope.submit = function (form) {
            $scope.$broadcast('schemaFormValidate');
            if (form.$valid) {
                $scope.loading = true;
                return $scope.company.$post('bookings', {}, $scope.form_model).then(function (booking) {
                        $scope.loading = false;
                        $uibModalInstance.close(booking);
                        if (successFn) {
                            return successFn(booking);
                        }
                    }
                    , function (err) {
                        $scope.loading = false;
                        $uibModalInstance.close(err);
                        $log.error('Failed to create');
                        if (fail) {
                            return fail();
                        }
                    });
            } else {
                return $log.warn('Invalid form');
            }
        };

        return $scope.cancel = function (event) {
            event.preventDefault();
            event.stopPropagation();
            return $uibModalInstance.dismiss('cancel');
        };
    };

    angular.module('BB.Services').factory('ModalForm', function ($uibModal) {

        return {
            new(config) {
                let templateUrl;
                if (config.templateUrl) {
                    ({templateUrl} = config);
                }
                if (!templateUrl) {
                    templateUrl = 'modal_form.html';
                }
                return $uibModal.open({
                    templateUrl,
                    controller: newForm,
                    size: config.size,
                    resolve: {
                        company() {
                            return config.company;
                        },
                        title() {
                            return config.title;
                        },
                        new_rel() {
                            return config.new_rel;
                        },
                        post_rel() {
                            return config.post_rel;
                        },
                        successFn() {
                            return config.success;
                        },
                        failFn() {
                            return config.fail;
                        }
                    }
                });
            },

            edit(config) {
                let templateUrl;
                if (config.templateUrl) {
                    ({templateUrl} = config);
                }
                if (!templateUrl) {
                    templateUrl = 'modal_form.html';
                }
                return $uibModal.open({
                    templateUrl,
                    controller: editForm,
                    size: config.size,
                    resolve: {
                        model() {
                            return config.model;
                        },
                        title() {
                            return config.title;
                        },
                        successFn() {
                            return config.success;
                        },
                        failFn() {
                            return config.fail;
                        },
                        params() {
                            return config.params || {};
                        }
                    }
                });
            },

            book(config) {
                let templateUrl;
                if (config.templateUrl) {
                    ({templateUrl} = config);
                }
                if (!templateUrl) {
                    templateUrl = 'modal_form.html';
                }
                return $uibModal.open({
                    templateUrl,
                    controller: bookForm,
                    size: config.size,
                    resolve: {
                        model() {
                            return config.model;
                        },
                        company() {
                            return config.company;
                        },
                        title() {
                            return config.title;
                        },
                        successFn() {
                            return config.success;
                        },
                        failFn() {
                            return config.fail;
                        }
                    }
                });
            }
        };
    });

})();

