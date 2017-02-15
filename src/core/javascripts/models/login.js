angular.module('BB.Models').factory("LoginModel", ($q, LoginService, BBModel, BaseModel) =>

    class Login extends BaseModel {

        constructor(data) {
            super(data);
        }

        static $companyLogin(company, params, form) {
            return LoginService.companyLogin(company, params, form);
        }

        static $login(form, options) {
            return LoginService.login(form, options);
        }

        static $FBLogin(company, params) {
            return LoginService.FBLogin(company, params);
        }

        static $companyQuery(id) {
            return LoginService.companyQuery(id);
        }

        static $memberQuery(params) {
            return LoginService.memberQuery(params);
        }

        static $ssoLogin(options, data) {
            return LoginService.ssoLogin(options, data);
        }

        static $isLoggedIn() {
            return LoginService.isLoggedIn();
        }

        static $setLogin(member, persist) {
            return LoginService.setLogin(member, persist);
        }

        static $member() {
            return LoginService.member();
        }

        static $checkLogin() {
            return LoginService.checkLogin();
        }

        static $logout() {
            return LoginService.logout();
        }

        static $FBLogout(options) {
            return LoginService.FBLogout(options);
        }

        static $sendPasswordReset(company, params) {
            return LoginService.sendPasswordReset(company, params);
        }

        static $updatePassword(member, params) {
            return LoginService.updatePassword(member, params);
        }
    }
);

