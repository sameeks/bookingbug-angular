(function (angular) {
    /**
     * @ngdoc directive
     * @name BBAdminDashboard.directive:adminSideNav
     * @scope
     * @restrict A
     *
     * @description
     * Ensures iframe size is based on iframe content and that the iframe src is whitelisted
     *
     * @param {string}  path         A string that contains the iframe url
     * @param {string}  apiUrl       A string that contains the ApiUrl
     * @param {object}  extraParams  An object that contains extra params for the url (optional)
     */
    angular.module('BBAdminDashboard').directive('adminSideNav', AdminSideNavDirective);

    function AdminSideNavDirective() {
        return {
            controller: AdminSideNavCtrl,
            restrict: 'A',
            scope: false,
            templateUrl: 'core/admin-side-nav.html'
        };
    }

    function AdminSideNavCtrl($scope, SideNavigationPartials) {
        'ngInject';

        $scope.navigation = SideNavigationPartials.getOrderedPartialTemplates();
    }

})(angular);
