(function (angular) {

    angular.module('BBAdminDashboard').run(run);

    function run(RuntimeStates, AdminCoreOptions, RuntimeRoutes) {
        'ngInject';

        init();

        function init() {
            setRoutes();
        }

        function setRoutes() {
            RuntimeRoutes.otherwise('/');

            RuntimeStates
                .state('root', {
                    url: '/',
                    templateUrl: "core/layout.html",
                    resolve: {
                        user,
                        company
                    },
                    controller: 'CorePageController',
                    deepStateRedirect: {
                        default: {
                            state: AdminCoreOptions.default_state
                        }
                    }
                });

        }

        function user($q, BBModel, AdminSsoLogin) {
            'ngInject';

            let defer = $q.defer();
            BBModel.Admin.Login.$user().then(
                function (user) {
                    if (user) {
                        defer.resolve(user);
                        return;
                    }

                    AdminSsoLogin.ssoLoginPromise().then(
                        (admin) => {
                            BBModel.Admin.Login.$setLogin(admin);
                            BBModel.Admin.Login.$user().then(
                                (user) => defer.resolve(user),
                                (err) => defer.reject({reason: 'GET_USER_ERROR', error: err})
                            );
                        },
                        (err) => defer.reject({reason: 'NOT_LOGGABLE_ERROR'})
                    );
                },
                (err) => defer.reject({reason: 'LOGIN_SERVICE_ERROR', error: err})
            );
            return defer.promise;
        }

        function company(user, $q, BBModel) {
            'ngInject';

            let defer = $q.defer();
            user.$getCompany().then(
                (company) => {
                    if (company.companies && (company.companies.length > 0)) {
                        defer.reject({reason: 'COMPANY_IS_PARENT'});
                    } else {
                        defer.resolve(company);
                    }
                },
                (err) => {
                    BBModel.Admin.Login.$logout().then(
                        () => defer.reject({reason: 'GET_COMPANY_ERROR'}),
                        (err) => defer.reject({reason: 'LOGOUT_ERROR'})
                    );
                }
            );
            return defer.promise;
        }
    }


})(angular);
