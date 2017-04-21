angular.module('BB.Controllers').controller('Login', function ($scope, $rootScope, $q, $location, LoginService, ValidatorService, AlertService, LoadingService, BBModel) {

    console.warn('Deprecation warning: validator.validateForm() will be removed from bbLogin in an upcoming major release, please update your template to use bbForm and submitForm() instead. See https://github.com/bookingbug/bookingbug-angular/issues/638');
    $scope.validator = ValidatorService;

    $scope.login_form = {};

    let loader = LoadingService.$loader($scope);

    /***
     * @ngdoc method
     * @name login_sso
     * @methodOf BB.Directives:bbLogin
     * @description
     * Login to application
     *
     * @param {object} token The token to use for login
     * @param {string=} route A specific route to load
     */
    $scope.login_sso = (token, route) =>
        $rootScope.connection_started.then(() => {
                return LoginService.ssoLogin({
                    company_id: $scope.bb.company.id,
                    root: $scope.bb.api_url
                }, {token}).then(member => {
                        if (route) {
                            return $scope.showPage(route);
                        }
                    }
                    , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));
            }
            , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'))
    ;

    /***
     * @ngdoc method
     * @name login_with_password
     * @methodOf BB.Directives:bbLogin
     * @description
     * Login with password
     *
     * @param {string} email The email address that use for the login
     * @param {string} password The password use for the login
     */
    $scope.login_with_password = (email, password) =>
        LoginService.companyLogin($scope.bb.company, {}, {email, password}).then(member => {
                return $scope.member = new BBModel.Member.Member(member);
            }
            , err => {
                return AlertService.raise('LOGIN_FAILED');
            }
        )
    ;

    /***
     * @ngdoc method
     * @name showEmailPasswordReset
     * @methodOf BB.Directives:bbLogin
     * @description
     * Display email reset password page
     */
    $scope.showEmailPasswordReset = () => {
        return $scope.showPage('email_reset_password');
    };

    /***
     * @ngdoc method
     * @name isLoggedIn
     * @methodOf BB.Directives:bbLogin
     * @description
     * Verify if user are logged in
     */
    $scope.isLoggedIn = () => LoginService.isLoggedIn();

    /***
     * @ngdoc method
     * @name sendPasswordReset
     * @methodOf BB.Directives:bbLogin
     * @description
     * Send password reset via email
     *
     * @param {string} email The email address use for the send new password
     */
    $scope.sendPasswordReset = email =>
        LoginService.sendPasswordReset($scope.bb.company, {
            email,
            custom: true
        }).then(() => AlertService.raise('PASSWORD_RESET_REQ_SUCCESS')
            , err => {
                return AlertService.raise('PASSWORD_RESET_REQ_FAILED');
            }
        )
    ;

    /***
     * @ngdoc method
     * @name updatePassword
     * @methodOf BB.Directives:bbLogin
     * @description
     * Update password
     *
     * @param {string} new_password The new password has been set
     * @param {string} confirm_new_password The new password has been confirmed
     */
    return $scope.updatePassword = function (new_password, confirm_new_password) {
        AlertService.clear();
        if ($rootScope.member && new_password && confirm_new_password && (new_password === confirm_new_password)) {
            return LoginService.updatePassword($rootScope.member, {
                new_password,
                confirm_new_password,
                persist_login: $scope.login_form.persist_login
            }).then(member => {
                    if (member) {
                        $scope.setClient(member);
                        $scope.password_updated = true;
                        return AlertService.raise('PASSWORD_RESET_SUCESS');
                    }
                }
                , err => {
                    $scope.error = err;
                    return AlertService.raise('PASSWORD_RESET_FAILED');
                }
            );
        } else {
            return AlertService.raise('PASSWORD_MISMATCH');
        }
    };
});
