// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBAdminDashboard').directive('bbIfLogin', function ($uibModal, $log, $q,
                                                                    $rootScope, AdminCompanyService, $compile, $templateCache,
                                                                    ModalForm, BBModel) {

    let compile = () =>
            ({
                pre(scope, element, attributes) {
                    scope.notLoaded = sc => null;
                    scope.setLoaded = sc => null;
                    scope.setPageLoaded = () => null;

                    $rootScope.start_deferred = $q.defer();
                    $rootScope.connection_started = $rootScope.start_deferred.promise;
                    this.whenready = $q.defer();
                    scope.loggedin = this.whenready.promise;
                    return AdminCompanyService.query(attributes).then(function (company) {
                        scope.company = company;
                        if (!scope.bb) {
                            scope.bb = {};
                        }
                        scope.bb.company = company;
                        this.whenready.resolve();
                        return $rootScope.start_deferred.resolve();
                    });
                }
                ,
                post(scope, element, attributes) {
                }
            })
        ;

    let link = function (scope, element, attrs) {
    };
    return {
        compile
//    controller: 'bbQueuers'
        // templateUrl: 'queuer_table.html'
    };
});
