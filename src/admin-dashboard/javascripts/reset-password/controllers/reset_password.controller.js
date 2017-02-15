/*
 * @ngdoc controller
 * @name BBAdminDashboard.reset-password.controller:ResetPasswordCtrl
 *
 * @description
 * Controller for the reset password functionality
 */

let ResetPasswordCtrl = function ($scope, $state, AdminLoginOptions, AdminLoginService, QueryStringService, ResetPasswordService, ResetPasswordSchemaFormService) {
    'ngInject';

    let $resetPasswordCtrl = this;

    let init = function () {

        if ($scope.baseUrl == null) {
            $scope.baseUrl = $resetPasswordCtrl.resetPasswordSite;
        }

        $resetPasswordCtrl.showApiField = AdminLoginOptions.show_api_field;
        $resetPasswordCtrl.resetPasswordSuccess = false;
        $resetPasswordCtrl.showLoading = false;

        if ($resetPasswordCtrl.showApiField) {
            $resetPasswordCtrl.resetPasswordSite = angular.copy($scope.bb.api_url);
        }

        $resetPasswordCtrl.formErrors = [];

        // decide which template to show
        if ((QueryStringService('reset_password_token') != null) && (QueryStringService('reset_password_token') !== 'undefined') && (QueryStringService('reset_password_token') !== '')) {
            $resetPasswordCtrl.resetPasswordTemplate = 'reset-password/reset-password-by-token.html';
            fetchSchemaForm();
        } else {
            $resetPasswordCtrl.resetPasswordTemplate = 'reset-password/reset-password.html';
        }

    };

    // formErrors helper method
    let formErrorExists = function (message) {
        // iterate through the formErrors array
        for (let obj of Array.from($resetPasswordCtrl.formErrors)) {
            // check if the message passed in matches any pre-existing ones.
            if (obj.message.match(message)) {
                return true;
            }
        }
        return false;
    };

    // fetch Schema Form helper method
    var fetchSchemaForm = function () {
        ResetPasswordSchemaFormService.getSchemaForm($scope.baseUrl).then(function (response) {

                $resetPasswordCtrl.resetPasswordSchema = angular.copy(response.data.schema);

                ResetPasswordSchemaFormService.setPasswordPattern($resetPasswordCtrl.resetPasswordSchema.properties.password.pattern);
                return $resetPasswordCtrl.reset_password_pattern = ResetPasswordSchemaFormService.getPasswordPattern();
            }
            , function (err) {
                ResetPasswordSchemaFormService.setPasswordPattern('^(?=[^\\s]*[^a-zA-Z])(?=[^\\s]*[a-zA-Z])[^\\s]{7,25}$');
                return $resetPasswordCtrl.reset_password_pattern = ResetPasswordSchemaFormService.getPasswordPattern();
            });

    };

    $resetPasswordCtrl.goBackToLogin = function () {
        $state.go('login');
    };

    $resetPasswordCtrl.sendResetPassword = function (email, resetPasswordSite) {
        $resetPasswordCtrl.showLoading = true;

        //if the site field is used, set the api url to the submmited url
        if ($resetPasswordCtrl.showApiField && (resetPasswordSite !== '')) {
            // strip trailing spaces from the url to avoid calling an invalid endpoint
            // since all service calls to api end-points begin with '/', e.g '/api/v1/...'
            $resetPasswordCtrl.resetPasswordSite = resetPasswordSite.replace(/\/+$/, '');
            if ($resetPasswordCtrl.resetPasswordSite.indexOf("http") === -1) {
                $resetPasswordCtrl.resetPasswordSite = `https://${$resetPasswordCtrl.resetPasswordSite}`;
            }
            $scope.baseUrl = $resetPasswordCtrl.resetPasswordSite;
        }

        ResetPasswordService.postRequest(email, $scope.baseUrl).then(function (response) {
                $resetPasswordCtrl.resetPasswordSuccess = true;
                return $resetPasswordCtrl.showLoading = false;
            }
            , function (err) {
                $resetPasswordCtrl.resetPasswordSuccess = false;
                $resetPasswordCtrl.showLoading = false;
                let message = "ADMIN_DASHBOARD.RESET_PASSWORD_PAGE.FORM_SUBMIT_FAIL_MSG";
                if (!formErrorExists(message)) {
                    return $resetPasswordCtrl.formErrors.push({message});
                }
            });

    };

    $resetPasswordCtrl.submitSchemaForm = function (password) {
        $resetPasswordCtrl.showLoading = true;

        ResetPasswordSchemaFormService.postSchemaForm(password, $scope.baseUrl).then(function (response) {
                $resetPasswordCtrl.resetPasswordSuccess = true;

                // password reset successful, so auto-login
                let loginForm = {"email": response.data.email, "password": password};

                return AdminLoginService.login(loginForm).then(response => $state.go('login')
                    , function (err) {
                        $resetPasswordCtrl.showLoading = false;
                        return $resetPasswordCtrl.formErrors.push({message: "ADMIN_DASHBOARD.LOGIN_PAGE.ERROR_ISSUE_WITH_COMPANY"});
                    });
            }

            , function (err) {
                $resetPasswordCtrl.resetPasswordSuccess = false;
                $resetPasswordCtrl.showLoading = false;
                let message = "ADMIN_DASHBOARD.RESET_PASSWORD_PAGE.FORM_SUBMIT_FAIL_MSG";
                if (!formErrorExists(message)) {
                    return $resetPasswordCtrl.formErrors.push({message});
                }
            });

    };

    init();

};

angular
    .module('BBAdminDashboard.reset-password')
    .controller('ResetPasswordCtrl', ResetPasswordCtrl);
