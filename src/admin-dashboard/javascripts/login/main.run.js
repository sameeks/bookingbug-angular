(function (angular) {

    angular.module('BBAdminDashboard.login').run(run);

    function run(RuntimeStates, AdminLoginOptions) {
        'ngInject';

        init();

        function init() {
            if (AdminLoginOptions.use_default_states) setDefaultRoutes();
        }

        function setDefaultRoutes() {

            RuntimeStates
                .state('login', {
                    url: "/login",
                    resolve: {
                        user
                    },
                    controller: "LoginPageCtrl",
                    templateUrl: "login/index.html"
                });
        }

        function user($q, BBModel, AdminSsoLogin) {
            'ngInject';

            let defer = $q.defer();

            BBModel.Admin.Login.$user().then(
                (user) => {
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
                        (err) => defer.resolve()
                    );

                },
                (err) => defer.reject({reason: 'LOGIN_SERVICE_ERROR', error: err})
            );

            return defer.promise;
        }
    }


})(angular);
