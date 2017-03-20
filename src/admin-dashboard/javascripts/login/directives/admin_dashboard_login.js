(function (angular) {

    /*
     * @ngdoc directive
     * @name BBAdminDashboard.login.directives.directive:adminDashboardLogin
     * @scope
     * @restrict A
     *
     * @description
     * Admin login journey directive
     *
     * @param {object}  field   A field object
     */
    angular.module('BBAdminDashboard.login.directives').directive('adminDashboardLogin', AdminDashboardLoginDirective);

    function AdminDashboardLoginDirective() {
        'ngInject';

        return {
            restrict: 'AE',
            replace: true,
            scope: {
                onSuccess: '=',
                onCancel: '=',
                onError: '=',
                bb: '=',
                user: '=?'
            },
            templateUrl: 'login/admin-dashboard-login.html',
            controller: AdminDashboardLoginCtrl
        };

        function AdminDashboardLoginCtrl($scope, $rootScope, BBModel, $localStorage, $state, AdminLoginOptions) {
            'ngInject';

            $scope.template_vars = {
                show_api_field: AdminLoginOptions.show_api_field,
                show_login: true,
                show_pick_company: false,
                show_pick_department: false,
                show_loading: false
            };

            $scope.login_data = {
                email: null,
                password: null,
                selected_admin: null,
                selected_company: null,
                site: $localStorage.getItem("api_url")
            };

            $scope.formErrors = [];

            let formErrorExists = function (message) {
                for (let obj of Array.from($scope.formErrors)) {
                    if (obj.message.match(message))  return true;
                }
                return false;
            };

            let companySelection = function (user) {
                if (user.$has('administrators')) {
                    return user.$getAdministrators().then(function (administrators) {
                        $scope.administrators = administrators;

                        // if user is admin in more than one company show select company
                        if (administrators.length > 1) {
                            $scope.template_vars.show_loading = false;
                            $scope.template_vars.show_login = false;
                            return $scope.template_vars.show_pick_company = true;
                        } else if (administrators.length === 1) {
                            // else automatically select the first admin
                            let params = {
                                email: $scope.login_data.email,
                                password: $scope.login_data.password
                            };

                            $scope.login_data.selected_admin = _.first(administrators);
                            return $scope.login_data.selected_admin.$post('login', {}, params).then(login =>
                                $scope.login_data.selected_admin.$getCompany().then(function (company) {
                                    $scope.template_vars.show_loading = false;
                                    // if there are departments show department selector
                                    if (company.companies && (company.companies.length > 0)) {
                                        $scope.template_vars.show_pick_department = true;
                                        return $scope.departments = company.companies;
                                    } else {
                                        // else select that company directly and move on
                                        $scope.login_data.selected_company = company;
                                        BBModel.Admin.Login.$setLogin($scope.login_data.selected_admin);
                                        return BBModel.Admin.Login.$setCompany($scope.login_data.selected_company.id).then(user => $scope.onSuccess($scope.login_data.selected_company));
                                    }
                                })
                            );
                        } else {
                            $scope.template_vars.show_loading = false;
                            let message = "ADMIN_DASHBOARD.LOGIN_PAGE.ERROR_INCORRECT_CREDS";
                            if (!formErrorExists(message)) {
                                return $scope.formErrors.push({message});
                            }
                        }
                    });

                    // else if there is an associated company
                } else if (user.$has('company')) {
                    $scope.login_data.selected_admin = user;

                    return user.$getCompany().then(function (company) {
                            // if departments are available show departments selector
                            if (company.companies && (company.companies.length > 0)) {
                                $scope.template_vars.show_loading = false;
                                $scope.template_vars.show_pick_department = true;
                                $scope.template_vars.show_login = false;
                                return $scope.departments = company.companies;
                            } else {
                                // else select that company directly and move on
                                $scope.login_data.selected_company = company;
                                BBModel.Admin.Login.$setLogin($scope.login_data.selected_admin);
                                return BBModel.Admin.Login.$setCompany($scope.login_data.selected_company.id).then(user => $scope.onSuccess($scope.login_data.selected_company));
                            }
                        }
                        , function (err) {
                            $scope.template_vars.show_loading = false;
                            let message = "ADMIN_DASHBOARD.LOGIN_PAGE.ERROR_ISSUE_WITH_COMPANY";
                            if (!formErrorExists(message)) {
                                return $scope.formErrors.push({message});
                            }
                        });

                } else {
                    $scope.template_vars.show_loading = false;
                    let message = "ADMIN_DASHBOARD.LOGIN_PAGE.ERROR_ACCOUNT_ISSUES";
                    if (!formErrorExists(message)) {
                        return $scope.formErrors.push({message});
                    }
                }
            };

            // If a User is available at this stages SSO login is implied
            if ($scope.user) {
                $scope.template_vars.show_pick_department = true;
                $scope.template_vars.show_login = false;
                companySelection($scope.user);
            }

            $scope.login = function (isValid) {
                if (isValid) {
                    $scope.template_vars.show_loading = true;

                    //if the site field is used set the api url to the submmited url
                    if (AdminLoginOptions.show_api_field) {
                        // strip trailing spaces from the url to avoid calling an invalid endpoint
                        // since all service calls to api end-points begin with '/', e.g '/api/v1/...'
                        $scope.login_data.site = $scope.login_data.site.replace(/\/+$/, '');
                        if ($scope.login_data.site.indexOf("http") === -1) {
                            $scope.login_data.site = `https://${$scope.login_data.site}`;
                        }
                        $scope.bb.api_url = $scope.login_data.site;
                        $rootScope.bb.api_url = $scope.login_data.site;
                        $localStorage.setItem("api_url", $scope.login_data.site);
                    }

                    let params = {
                        email: $scope.login_data.email,
                        password: $scope.login_data.password
                    };
                    return BBModel.Admin.Login.$login(params).then(user => companySelection(user)

                        , function (err) {
                            $scope.template_vars.show_loading = false;
                            let message = "ADMIN_DASHBOARD.LOGIN_PAGE.ERROR_INCORRECT_CREDS";
                            if (!formErrorExists(message)) {
                                return $scope.formErrors.push({message});
                            }
                        });
                }
            };

            $scope.goToResetPassword = () => $state.go('reset-password');

            $scope.pickCompany = function () {
                $scope.template_vars.show_loading = true;
                $scope.template_vars.show_pick_department = false;

                let params = {
                    email: $scope.login_data.email,
                    password: $scope.login_data.password
                };

                return $scope.login_data.selected_admin.$post('login', {}, params).then(login =>
                    $scope.login_data.selected_admin.$getCompany().then(function (company) {
                        $scope.template_vars.show_loading = false;

                        if (company.companies && (company.companies.length > 0)) {
                            $scope.template_vars.show_pick_department = true;
                            return $scope.departments = company.companies;
                        } else {
                            return $scope.login_data.selected_company = company;
                        }
                    })
                );
            };

            $scope.selectCompanyDepartment = function (isValid) {
                $scope.template_vars.show_loading = true;
                if (isValid) {
                    $scope.bb.company = $scope.login_data.selected_company;
                    BBModel.Admin.Login.$setLogin($scope.login_data.selected_admin);
                    return BBModel.Admin.Login.$setCompany($scope.login_data.selected_company.id).then(user => $scope.onSuccess($scope.login_data.selected_company));
                }
            };
        }
    }

})(angular);
