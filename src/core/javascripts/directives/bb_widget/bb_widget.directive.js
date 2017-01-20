/***
 * @ngdoc directive
 * @name BB.Directives:bbWidget
 * @restrict A
 * @scope
 *   client: '=?'
 *   apiUrl: '@?'
 *   useParent:'='
 * @description
 *
 * Loads a list of widgets for the currently in scope company
 *
 * <pre>
 * restrict: 'A'
 * scope:
 *   client: '=?'
 *   apiUrl: '@?'
 *   useParent:'='
 * transclude: true
 * </pre>
 *
 * @param {hash} bbWidget A hash of options
 * @property {string} pusher The pusher
 * @property {string} pusher_channel The pusher channel
 * @property {string} init_params Initialization of basic parameters
 */
angular.module('BB.Directives').directive('bbWidget', function (PathSvc, $http, $log, $templateCache, $compile, $q, AppConfig, $timeout, $bbug, $rootScope, AppService) {

    /**
     * @ngdoc method
     * @name getTemplate
     * @methodOf BB.Directives:bbWidget
     * @description
     * Get template
     *
     * @param {object} template The template
     */
    var getTemplate = function (template) {
        var partial = template ? template : 'main';
        return $templateCache.get(partial + '.html');
    };

    /**
     * @ngdoc method
     * @name updatePartials
     * @methodOf BB.Directives:bbWidget
     * @description
     * Update partials
     *
     * @param {object} prms The parameter
     */
    var updatePartials = function (scope, element, prms) {
        var i, j, len, ref;
        ref = element.children();
        for (j = 0, len = ref.length; j < len; j++) {
            i = ref[j];
            if ($bbug(i).hasClass('custom_partial')) {
                $bbug(i).remove();
            }
        }
        return appendCustomPartials(scope, element, prms).then(function () {
            return scope.$broadcast('refreshPage');
        });
    };

    /**
     * @ngdoc method
     * @name setupPusher
     * @methodOf BB.Directives:bbWidget
     * @description
     * Push setup
     *
     * @param {object} prms The parameter
     */
    var setupPusher = function (scope, element, prms) {
        return $timeout(function () {
            scope.pusher = new Pusher('c8d8cea659cc46060608');
            scope.pusher_channel = scope.pusher.subscribe("widget_" + prms.design_id);
            return scope.pusher_channel.bind('update', function (data) {
                return updatePartials(scope, element, prms);
            });
        });
    };

    /**
     * @ngdoc method
     * @name appendCustomPartials
     * @methodOf BB.Directives:bbWidget
     * @description
     * Appent custom partials
     *
     * @param {object} prms The parameter
     */
    var appendCustomPartials = function (scope, element, prms) {
        var defer;
        defer = $q.defer();
        $http.get(prms.custom_partial_url).then(function (custom_templates) {
            return $compile(custom_templates.data)(scope, function (custom, scope) {
                var non_style, style, tag;
                custom.addClass('custom_partial');
                style = (function () {
                    var j, len, results;
                    results = [];
                    for (j = 0, len = custom.length; j < len; j++) {
                        tag = custom[j];
                        if (tag.tagName === "STYLE") {
                            results.push(tag);
                        }
                    }
                    return results;
                })();
                non_style = (function () {
                    var j, len, results;
                    results = [];
                    for (j = 0, len = custom.length; j < len; j++) {
                        tag = custom[j];
                        if (tag.tagName !== "STYLE") {
                            results.push(tag);
                        }
                    }
                    return results;
                })();
                $bbug("#widget_" + prms.design_id).html(non_style);
                element.append(style);
                scope.bb.path_setup = true;
                return defer.resolve(style);
            });
        });
        return defer.promise;
    };

    /**
     * @ngdoc method
     * @name renderTemplate
     * @methodOf BB.Directives:bbWidget
     * @description
     * Render template
     *
     * @param {object} design_mode The design mode
     * @param {object} template The template
     */
    var renderTemplate = function (scope, element, design_mode, template) {
        return $q.when(getTemplate(template)).then(function (template) {
            element.html(template).show();
            if (design_mode) {
                element.append('<style widget_css scoped></style>');
            }
            return $compile(element.contents())(scope);
        });
    };
    var link = function (scope, element, attrs, controller, transclude) {
        var evaluator, init_params, notInModal;
        if (attrs.member != null) {
            scope.client = attrs.member;
        }
        evaluator = scope;
        if (scope.useParent && (scope.$parent != null)) {
            evaluator = scope.$parent;
        }
        init_params = evaluator.$eval(attrs.bbWidget);
        scope.initWidget(init_params);
        $rootScope.widget_started.then((function (_this) {
            return function () {
                var prms;
                prms = scope.bb;
                if (prms.custom_partial_url) {
                    prms.design_id = prms.custom_partial_url.match(/^.*\/(.*?)$/)[1];
                    $bbug("[ng-app='BB']").append("<div id='widget_" + prms.design_id + "'></div>");
                }
                if (scope.bb.partial_url) {
                    if (init_params.partial_url) {
                        AppConfig['partial_url'] = init_params.partial_url;
                    } else {
                        AppConfig['partial_url'] = scope.bb.partial_url;
                    }
                }
                return transclude(scope, function (clone) {
                    scope.has_content = clone.length > 1 || (clone.length === 1 && (!clone[0].wholeText || /\S/.test(clone[0].wholeText)));
                    if (!scope.has_content) {
                        if (prms.custom_partial_url) {
                            appendCustomPartials(scope, element, prms).then(function (style) {
                                return $q.when(getTemplate()).then(function (template) {
                                    element.html(template).show();
                                    $compile(element.contents())(scope);
                                    element.append(style);
                                    if (prms.update_design) {
                                        return setupPusher(scope, element, prms);
                                    }
                                });
                            });
                        } else if (prms.template) {
                            renderTemplate(scope, element, prms.design_mode, prms.template);
                        } else {
                            renderTemplate(scope, element, prms.design_mode);
                        }
                        return scope.$on('refreshPage', function () {
                            return renderTemplate(scope, element, prms.design_mode, prms.template);
                        });
                    } else if (prms.custom_partial_url) {
                        appendCustomPartials(scope, element, prms);
                        if (prms.update_design) {
                            setupPusher(scope, element, prms);
                        }
                        return scope.$on('refreshPage', function () {
                            return scope.showPage(scope.bb.current_page);
                        });
                    } else {
                        element.html(clone).show();
                        if (prms.design_mode) {
                            return element.append('<style widget_css scoped></style>');
                        }
                    }
                });
            };
        })(this));
        notInModal = function (p) {
            if (p.length === 0 || p[0].attributes === void 0) {
                return true;
            } else if (p[0].attributes['uib-modal-window'] !== void 0) {
                return false;
            } else {
                if (p.parent().length === 0) {
                    return true;
                } else {
                    return notInModal(p.parent());
                }
            }
        };
        scope.$watch(function () {
            return AppService.isModalOpen();
        }, function (modalOpen) {
            return scope.coveredByModal = modalOpen && notInModal(element.parent());
        });
    };

    return {
        restrict: 'A',
        scope: {
            client: '=?',
            apiUrl: '@?',
            useParent: '='
        },
        transclude: true,
        controller: 'BBCtrl',
        controllerAs: '$bbCtrl',
        link: link
    };
});
