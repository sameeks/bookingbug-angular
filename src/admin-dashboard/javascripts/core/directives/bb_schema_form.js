angular.module('BBAdminDashboard').directive('bbSchemaForm', function ($log, FormTransform) {
    'ngInject';

    return {
        template: `\
<div uib-alert ng-class="'alert-' + alert.type" ng-if="alert">{{alert.msg}}</div>
  <form name="formCtrl" sf-schema="schema" sf-form="form" sf-model="form_model"
  ng-submit="submit(formCtrl)" ng-hide="loading" ng-if="schema && form && form_model" sf-options="options"></form>\
`,
        scope: {
            base: '=',
            formRel: '@',
            saveRel: '@',
            onSuccessSave: '=',
            onFailSave: '=',
            options: '=',
            formModel: '=?'
        },
        controller($scope) {
            $scope.loading = true;
            if ($scope.base.$has($scope.formRel)) {
                $scope.base.$get($scope.formRel).then(function (schema) {
                    $scope.form = schema.form;
                    $scope.schema = schema.schema;
                    if ($scope.formModel) {
                        $scope.form_model = $scope.formModel;
                    } else {
                        $scope.form_model = {};
                    }
                    return $scope.loading = false;
                });
            } else {
                $log.warn(`model does not have '${formRel}' rel`);
            }

            return $scope.submit = function (form) {
                $scope.alert = false;
                $scope.$broadcast('schemaFormValidate');
                if (form.$valid) {
                    $scope.loading = true;
                    return $scope.base.$post($scope.saveRel, {}, $scope.form_model).then(function (response) {
                            $scope.loading = false;
                            if ($scope.onSuccessSave) {
                                return $scope.onSuccessSave(response);
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
                                $scope.alert = {
                                    type: 'danger',
                                    msg: 'Something went wrong'
                                };
                            }
                            if ($scope.onFailSave) {
                                return $scope.onFailSave();
                            }
                        });
                }
            };
        }
    };
});

