// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Controllers').controller('MemberLogin', function ($scope, $log, $rootScope, $templateCache, $q, halClient, BBModel, $sessionStorage, $window, AlertService, ValidatorService, LoadingService) {

    $scope.login = {};

    console.warn('Deprecation warning: validator.validateForm() will be removed from bbMemberLogin in an upcoming major release, please update your template to use bbForm and submitForm() instead. See https://github.com/bookingbug/bookingbug-angular/issues/638');
    $scope.validator = ValidatorService;

    let loader = LoadingService.$loader($scope).notLoaded();

    $rootScope.connection_started.then(function () {

        if (BBModel.Login.$checkLogin()) {
            $scope.setClient($rootScope.member);
            if ($scope.bb.destination) {
                return $scope.redirectTo($scope.bb.destination);
            } else {
                loader.setLoaded();
                $scope.skipThisStep();
                return $scope.decideNextPage();
            }
        } else {
            return halClient.$get(`${$scope.bb.api_url}/api/v1`).then(root =>
                    root.$get("new_login").then(function (new_login) {
                            $scope.form = new_login.form;
                            $scope.schema = new_login.schema;
                            return loader.setLoaded();
                        }
                        , err => console.log('err ', err))

                , err => console.log('err ', err));
        }
    });


    $scope.submit = function () {

        $scope.login.role = 'member';

        return $scope.bb.company.$post('login', {}, $scope.login).then(function (login) {
                if (login.$has('members')) {
                    return login.$get('members').then(members => $scope.handleLogin(members[0]));
                } else if (login.$has('member')) {
                    return login.$get('member').then(member => $scope.handleLogin(member));
                }
            }
            , function (err) {
                if (err.data.error === "Account has been disabled") {
                    return AlertService.raise('ACCOUNT_DISABLED');
                } else {
                    return AlertService.raise('LOGIN_FAILED');
                }
            });
    };


    return $scope.handleLogin = function (member) {
        member = BBModel.Login.$setLogin(member, $scope.login.persist_login);
        $scope.setClient(member);
        if ($scope.bb.destination) {
            return $scope.redirectTo($scope.bb.destination);
        } else {
            $scope.skipThisStep();
            return $scope.decideNextPage();
        }
    };
});
