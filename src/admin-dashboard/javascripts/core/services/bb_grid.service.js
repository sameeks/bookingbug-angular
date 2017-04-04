angular
    .module('BBAdminDashboard')
    .factory('bbGridService', bbGridService);

function bbGridService() {
    return {
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
