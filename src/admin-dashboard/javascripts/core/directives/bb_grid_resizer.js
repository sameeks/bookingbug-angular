(() => {
  
    angular
        .module('BBAdminDashboard') 
        .directive('bbGridResizer', bbGridResizer);

    function bbGridResizer($rootScope, PageLayout) {
        let directive = {
            link
        }

        return directive;

        function link(scope, element, attrs) {
            let grid = element.find('bb-grid')
            scope.page = PageLayout; 

            scope.$watch('page', (newPage, oldPage) => {
                $rootScope.$broadcast('grid:containerResized', newPage.sideMenuOn);
            }, true);
        }
    }
})(); 

 