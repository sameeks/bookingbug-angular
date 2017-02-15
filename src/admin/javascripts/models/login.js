angular.module('BB.Models').factory("AdminLoginModel", ($q, AdminLoginService, BBModel, BaseModel) =>

    class Admin_Login extends BaseModel {

        constructor(data) {
            super(data);
        }

        static $login(form, options) {
            return AdminLoginService.login(form, options);
        }

        static $ssoLogin(options, data) {
            return AdminLoginService.ssoLogin(options, data);
        }

        static $isLoggedIn() {
            return AdminLoginService.isLoggedIn();
        }

        static $setLogin(user) {
            return AdminLoginService.setLogin(user);
        }

        static $user() {
            return AdminLoginService.user();
        }

        static $checkLogin(params) {
            return AdminLoginService.checkLogin(params);
        }

        static $logout() {
            return AdminLoginService.logout();
        }

        static $getLogin(options) {
            return AdminLoginService.getLogin(options);
        }

        static $companyLogin(company, params) {
            return AdminLoginService.companyLogin(company, params);
        }

        static $memberQuery(params) {
            return AdminLoginService.memberQuery(params);
        }

        static $setCompany(company_id) {
            return AdminLoginService.setCompany(company_id);
        }
    }
);

