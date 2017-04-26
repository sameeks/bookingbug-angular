angular.module('BBAdminDashboard').directive('bbSchemaFormEdit', function ($log, FormTransform) {
    'ngInject';

    return {
        template: `\
<div uib-alert ng-class="'alert-' + alert.type" ng-if="alert">{{alert.msg}}</div>
  <form name="formCtrl" sf-schema="schema" sf-form="form" sf-model="form_model"
  ng-submit="submit(formCtrl)" ng-hide="loading" ng-if="schema && form && form_model" sf-options="options"></form>\
`,
        link: function (scope, element, attrs) {
            console.log('schema form link');
            scope.$watch('model', function (n) {
                console.log('model change ', n);
            });
        },
        scope: {
            model: '=',
            onSuccessSave: '=',
            onFailSave: '=',
            options: '='
        },
        controller($scope) {
            console.log('schema form');
            $scope.$watch('model', function (n) {
                console.log('model change ', n);
            });
            $scope.loading = true;
            if ($scope.model.$has('edit')) {
                $scope.model.$get('edit').then(function (schema) {
                    $scope.form = schema.form;
                    let model_type = $scope.model.constructor.name;
                    if (FormTransform['edit'][model_type]) {
                        $scope.form = FormTransform['edit'][model_type]($scope.form);
                    }
                    $scope.schema = schema.schema;
                    $scope.form_model = $scope.model;
                    // $scope.form_model = angular.copy($scope.model);
                    return $scope.loading = false;
                });
            } else {
                $log.warn("model does not have 'edit' rel");
            }

            return $scope.submit = function (form) {
                $scope.$broadcast('schemaFormValidate');
                if (form.$valid) {
                    $scope.loading = true;
                    if ($scope.model.$update) {
                        return $scope.model.$update($scope.form_model).then(function () {
                                $scope.loading = false;
                                if ($scope.onSuccessSave) {
                                    return $scope.onSuccessSave($scope.model);
                                }
                            }
                            , function (err) {
                                $scope.loading = false;
                                $log.error('Failed to create');
                                if ($scope.onFailSave) {
                                    return $scope.onFailSave();
                                }
                            });
                    } else {
                        return $scope.model.$put('self', {}, $scope.form_model).then(function (model) {
                                $scope.loading = false;
                                if ($scope.onSuccessSave) {
                                    return $scope.onSuccessSave(model);
                                }
                            }
                            , function (err) {
                                $scope.loading = false;
                                if (err.data && err.data.error) {
                                    $log.error(err.data.error);
                                    $scope.alert = {
                                        type: 'danger',
                                        msg: err.data.error
                                    };
                                } else {
                                    $log.error('Something went wrong');
                                    $scope.alert =
                                        {type: 'danger'};
                                    ({msg: 'Something went wrong'});
                                }
                                if ($scope.onFailSave) {
                                    return $scope.onFailSave();
                                }
                            });
                    }
                }
            };
        }
    };
});

