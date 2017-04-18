/**
 * @ngdoc service
 * @name BBAdminDashboard.bbGridService
 *
 * @description
 * Responsible for setting grip settings
 *
*/

(() => {

    angular
        .module('BBAdminDashboard')
        .factory('bbGridService', bbGridService);

    function bbGridService() {
        return {
            /***
             * @ngdoc method
             * @name readyColumns
             * @methodOf BBAdminDashboard.bbGridService
             * @description
             * Checks if basket_item has default person
             * @param {array} columns The columns to be changed
             * @param {string} customTemplates The template to use in the the column
             *
             * @returns {boolean}
            */
            readyColumns(columns, customTemplates) {
                for(let col of columns) {
                    col.headerCellFilter = 'translate';
                    if(customTemplates) {
                        Object.assign(col, customTemplates);
                    }
                }

                return columns;
            }
        }
    }

})();
