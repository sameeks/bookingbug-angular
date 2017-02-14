// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBAdmin.Directives').directive('adminLogin', function ($uibModal,
                                                                       $log, $rootScope, $q, $document, BBModel) {

    let loginAdminController = function ($scope, $uibModalInstance, company_id) {
        $scope.title = 'Login';
        $scope.schema = {
            type: 'object',
            properties: {
                email: {type: 'string', title: 'Email'},
                password: {type: 'string', title: 'Password'}
            }
        };
        $scope.form = [{
            key: 'email',
            type: 'email',
            feedback: false,
            autofocus: true
        }, {
            key: 'password',
            type: 'password',
            feedback: false
        }];
        $scope.login_form = {};

        $scope.submit = function (form) {
            let options =
                {company_id};
            return BBModel.Admin.Login.$login(form, options).then(function (admin) {
                    admin.email = form.email;
                    admin.password = form.password;
                    return $uibModalInstance.close(admin);
                }
                , err => $uibModalInstance.dismiss(err));
        };

        return $scope.cancel = () => $uibModalInstance.dismiss('cancel');
    };


    let pickCompanyController = function ($scope, $uibModalInstance, companies) {
        let c;
        $scope.title = 'Pick Company';
        $scope.schema = {
            type: 'object',
            properties: {
                company_id: {type: 'integer', title: 'Company'}
            }
        };
        $scope.schema.properties.company_id.enum = ((() => {
            let result = [];
            for (c of Array.from(companies)) {
                result.push(c.id);
            }
            return result;
        })());
        $scope.form = [{
            key: 'company_id',
            type: 'select',
            titleMap: ((() => {
                let result1 = [];
                for (c of Array.from(companies)) {
                    result1.push({value: c.id, name: c.name});
                }
                return result1;
            })()),
            autofocus: true
        }];
        $scope.pick_company_form = {};

        $scope.submit = form => $uibModalInstance.close(form.company_id);

        return $scope.cancel = () => $uibModalInstance.dismiss('cancel');
    };


    let link = function (scope, element, attrs) {
        if (!$rootScope.bb) {
            $rootScope.bb = {};
        }
        if (!$rootScope.bb.api_url) {
            $rootScope.bb.api_url = scope.apiUrl;
        }
        if (!$rootScope.bb.api_url) {
            $rootScope.bb.api_url = "http://www.bookingbug.com";
        }

        var loginModal = function () {
            let modalInstance = $uibModal.open({
                templateUrl: 'login_modal_form.html',
                controller: loginAdminController,
                resolve: {
                    company_id() {
                        return scope.companyId;
                    }
                }
            });
            return modalInstance.result.then(function (result) {
                    scope.adminEmail = result.email;
                    scope.adminPassword = result.password;
                    if (result.$has('admins')) {
                        return result.$get('admins').then(function (admins) {
                            scope.admins = admins;
                            return $q.all(Array.from(admins).map((m) => m.$get('company'))).then(companies => pickCompanyModal(companies));
                        });
                    } else {
                        return scope.admin = result;
                    }
                }
                , () => loginModal());
        };

        var pickCompanyModal = function (companies) {
            let modalInstance = $uibModal.open({
                templateUrl: 'pick_company_modal_form.html',
                controller: pickCompanyController,
                resolve: {
                    companies() {
                        return companies;
                    }
                }
            });
            return modalInstance.result.then(function (company_id) {
                    scope.companyId = company_id;
                    return tryLogin();
                }
                , () => pickCompanyModal());
        };

        var tryLogin = function () {
            let login_form = {
                email: scope.adminEmail,
                password: scope.adminPassword
            };
            let options =
                {company_id: scope.companyId};
            return BBModel.Admin.Login.$login(login_form, options).then(function (result) {
                    if (result.$has('admins')) {
                        return result.$get('admins').then(function (admins) {
                            scope.admins = admins;
                            return $q.all(Array.from(admins).map((a) => a.$get('company'))).then(companies => pickCompanyModal(companies));
                        });
                    } else {
                        return scope.admin = result;
                    }
                }
                , err => loginModal());
        };


        if (scope.adminEmail && scope.adminPassword) {
            return tryLogin();
        } else {
            return loginModal();
        }
    };

    return {
        link,
        scope: {
            adminEmail: '@',
            adminPassword: '@',
            companyId: '@',
            apiUrl: '@',
            admin: '='
        },
        transclude: true,
        template: `\
<div ng-hide='admin'><img src='/BB_wait.gif' class="loader"></div>
<div ng-show='admin' ng-transclude></div>\
`
    };
});

