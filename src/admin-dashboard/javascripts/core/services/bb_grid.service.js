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
        },

        formatFilterString(filters) {
             // we need to build a string in format "field,value,field,value,field,value"
            let filterString = '';
            for(let filter of filters) {
                filter.string = filter.fieldName + ',' + filter.value;
            }

            for(let filter of filters) {
                if(filters.length === 1) {
                    filterString = filter.string;
                } else {
                    filterString = filterString + ',' + filter.string;
                }
            }

            if(filterString.charAt(0) === ',')  {
                filterString = filterString.substr(1);
            }

            return filterString;
        }
    }
}
