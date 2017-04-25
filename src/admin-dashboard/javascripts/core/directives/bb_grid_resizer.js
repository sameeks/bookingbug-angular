(function() {
    /***
     * @ngdoc directive
     * @name BBAdminDashboard:bbGridResizer
     * @restrict AE
     * @scope false
     * @require 'uiGrid'
     *
     * @description
     *
     * Get's the dimensions of a grid and fires an event when the width/height values have changed
     *
     */


    angular
        .module('BBAdminDashboard').
        directive('bbGridResizer', bbGridResizer);

        function bbGridResizer($timeout, gridUtil, PageLayout) {
            return {
                require: 'uiGrid',
                scope: false,

                link: function (scope, elem, attrs, uiGridCtrl) {
                    const options = scope.$eval(attrs.bbGridResizer) || {};
                    let prevGridHeight, prevGridWidth;

                    scope.page = PageLayout;

                    scope.$watch('page.sideMenuOn', () => {
                        startGridResize();
                    })

                    function getDimensions() {
                      prevGridHeight = gridUtil.elementHeight(elem);
                      prevGridWidth = gridUtil.elementWidth(elem);
                    }

                    // Initialize the dimensions
                    getDimensions();

                    let startGridResize = () => {

                        $timeout(() => {
                            let newGridHeight = gridUtil.elementHeight(elem);
                            let newGridWidth = gridUtil.elementWidth(elem);

                            if (newGridHeight !== prevGridHeight || newGridWidth !== prevGridWidth) {
                                uiGridCtrl.grid.gridHeight = newGridHeight;
                                uiGridCtrl.grid.gridWidth = newGridWidth;
                                uiGridCtrl.grid.api.core.raise.gridDimensionChanged();
                            }

                        }, 250);

                    }

                    if(options.resizeOnLoad) {
                       startGridResize();
                    }
                }
            };
        };
})();
