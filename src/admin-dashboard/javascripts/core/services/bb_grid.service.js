/**
 * @ngdoc service
 * @name BBAdminDashboard.bbGridService
 *
 * @description
 * Responsible for setting grid options shared between grids which are not needed in the option providers
 *
*/

(() => {

    angular
        .module('BBAdminDashboard')
        .factory('bbGridService', bbGridService);

    function bbGridService(uiGridConstants) {
        return {
            /***
             * @ngdoc method
             * @name readyColumns
             * @methodOf BBAdminDashboard.bbGridService
             * @description
             * Overrides grid options
             * @param {array} columns The columns to be changed
             * @param {string} customTemplates The template to use in the the column
             *
             * @returns {array} columns The columns with updated option properties
            */
            setColumns(columns, customTemplates) {
                for(let col of columns) {
                    col.headerCellFilter = 'translate';
                    col.enableHiding = false;
                    col.sortDirectionCycle = [uiGridConstants.ASC, uiGridConstants.DESC];
                    if(customTemplates) {
                        Object.assign(col, customTemplates);
                    }
                }

                return columns;
            },

            /***
             * @ngdoc method
             * @name setScrollBars
             * @methodOf BBAdminDashboard.bbGridService
             * @description
             * Sets grid scrollbars to show based on passed in options provider value
             * @param {object} option The option provider used by the grid
            */
            setScrollBars(option) {
                let value = option.disableScrollBars ? 0 : 1;
                option.basicOptions.enableHorizontalScrollbar = value;
                option.basicOptions.enableVerticalScrollbar = value;
            }
        }
    }

})();
