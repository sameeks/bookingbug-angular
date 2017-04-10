/**
 * @ngdoc filter
 * @name BBAdminDashboard.filters.filter:ClientTable
 * @description
 * Converts table fields into client search endpoint format
 */

angular
    .module('BBAdminDashboard')
    .filter('buildClientString', () =>
        (filters) => {
             // we need to build a string in format "field,value,field,value,field,value"
            let filterString = '';
            for(let filter of filters) {
                filter.string = filter.fieldName + ',' + filter.value;
                filterString = filters.length === 1 ? filter.string : filterString + ',' + filter.string;
            }

            if(filterString.charAt(0) === ',')  {
                filterString = filterString.substr(1);
            }

            return filterString;
        }
    );

angular
    .module('BBAdminDashboard')
    .filter('buildClientFieldsArray', () =>
        (filters, filterObject) => {
            // we need to build an array of filtered fields
            // replace current object with updated filter value if that filter is already in array
            _.filter(filters, (fil) => {
                if(fil.id === filterObject.id) {
                    filters = _.without(filters, fil)
                }
            });
            if(filterObject.value !== '') {
                filters.push(filterObject);
            }

            return filters;
        }
    );

