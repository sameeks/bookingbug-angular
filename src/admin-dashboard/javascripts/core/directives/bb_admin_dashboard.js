angular.module('BBAdminDashboard').directive('bbAdminDashboard', PageLayout => {
        return {
            restrict: 'AE',
            scope: {
                bb: '=',
                companyId: '@',
                ssoToken: '@'
            },
            template: '<div ui-view></div>',
            controller: ['$scope', '$rootScope', '$element', '$compile', '$localStorage', '$state', 'PageLayout', 'BBModel', 'AdminSsoLogin', 'AdminLoginOptions',
                function ($scope, $rootScope, $element, $compile, $localStorage, $state, PageLayout, BBModel, AdminSsoLogin, AdminLoginOptions) {

                    $rootScope.bb = $scope.bb;

                    let api_url = $localStorage.getItem("api_url");
                    if (!$scope.bb.api_url && api_url) {
                        $scope.bb.api_url = api_url;
                    }

                    // Set this up globally for everyone
                    AdminSsoLogin.apiUrl = $scope.bb.api_url;
                    AdminSsoLogin.ssoToken = ($scope.ssoToken != null) ? $scope.ssoToken : AdminLoginOptions.sso_token;
                    AdminSsoLogin.companyId = ($scope.companyId != null) ? $scope.companyId : AdminLoginOptions.company_id;

                    $scope.$on('$stateChangeError', function (evt, to, toParams, from, fromParams, error) {
                        switch (error.reason) {
                            case 'NOT_LOGGABLE_ERROR':
                                evt.preventDefault();
                                return $state.go('login');
                            case 'COMPANY_IS_PARENT':
                                evt.preventDefault();
                                return $state.go('login');
                        }
                    });

                    $scope.openSideMenu = () => PageLayout.sideMenuOn = true;

                    $scope.closeSideMenu = () => PageLayout.sideMenuOn = false;

                    $scope.toggleSideMenu = () => PageLayout.sideMenuOn = !PageLayout.sideMenuOn;

                }

            ],
            link(scope, element, attrs){

                scope.page = PageLayout;

                return scope.$watch('page', function (newPage, oldPage) {
                        if (newPage.sideMenuOn) {
                            element.addClass('sidebar-open');
                            element.removeClass('sidebar-collapse');
                        } else {
                            element.addClass('sidebar-collapse');
                            element.removeClass('sidebar-open');
                        }

                        if (newPage.boxed) {
                            return element.addClass('layout-boxed');
                        } else {
                            return element.removeClass('layout-boxed');
                        }
                    }

                    , true);
            }
        };
    }
);
