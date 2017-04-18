(() => {

    angular
        .module('BBAdminDashboard')
        .factory('bbGridService', bbGridService);

    function bbGridService() {
        return {
            // column settings used across all grids should be set here to reduce duplicate code between directives
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
