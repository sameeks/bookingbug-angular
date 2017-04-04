angular
    .module('BBAdminDashboard.clients.directives')
    .directive('bbClientsTable', BBClientsTable);

function BBClientsTable() {
    let directive = {
        link,
        restrict: 'AE',
        replace: true,
        scope: true,
        controller: 'TabletClients'
    }

    return directive;

    function link(scope, element, attrs) {
        let formattedFields = '';
        let searchFields = [];
        let actionButton = `<a class="btn btn-xs btn-default" ui-sref="clients.edit({id: row.entity.id})"><i class="fa fa-pencil"></i>
          <span translate="ADMIN_DASHBOARD.CLIENTS_PAGE.EDIT"></span></a>`;


        let customTemplates = {filterHeaderTemplate: 'ui_grid_filter_template.html', headerCellTemplate: 'ui_grid_header_template.html'}

        let prepareColumnDefs = () => {
            return [
                { field: 'name', displayName: 'ADMIN_DASHBOARD.CLIENTS_PAGE.NAME' },
                { field: 'email', displayName: 'ADMIN_DASHBOARD.CLIENTS_PAGE.EMAIL' },
                { field: 'mobile', displayName: 'ADMIN_DASHBOARD.CLIENTS_PAGE.MOBILE' },
                {  // ACTION BUTTON COLUMN
                    field: 'action',
                    displayName: 'ADMIN_DASHBOARD.CLIENTS_PAGE.ACTIONS',
                    enableFiltering: false,
                    enableHiding: false,
                    enableSorting: false,
                    enableColumnMenus: false,
                    cellTemplate: actionButton
                }
            ]
        }


        let prepareCustomGridOptions = () => {
            let columnDefs = prepareColumnDefs();
             // make header cells translatable
             // push custom templates
            for(let col of columnDefs) {
                col.headerCellFilter = 'translate';
                if(col.field !== 'action') {
                    Object.assign(col, customTemplates);
                }
            }

            return columnDefs;
        }



        scope.gridOptions = {
            enableSorting: true,
            enableFiltering: true,
            paginationPageSizes: [15],
            paginationPageSize: 15,
            useExternalPagination: true,
            columnDefs: prepareCustomGridOptions(),
            onRegisterApi: function(gridApi) {
                scope.gridApi = gridApi;
                scope.gridData = scope.getClients();
                gridApi.pagination.on.paginationChanged(scope, (newPage, pageSize) => {
                    scope.paginationOptions.pageNumber = newPage;
                    scope.paginationOptions.pageSize = pageSize;
                    scope.getClients(scope.paginationOptions.pageNumber + 1, null);
                })
            }
        }

        scope.paginationOptions = {
            pageNumber: 1,
            pageSize: 15,
            sort: null
        }

        let createFilterString = (field, term) => {
            searchFields.push(term);
            let allFields = '';

            for(let field of searchFields) {
                let formatted = field.field + ',' + field.term;
                if(allFields === '') {
                    allFields = allFields + formatted;
                } else {
                    allFields = allFields + ',' + formatted;
                }
            }

            scope.getClients(scope.paginationOptions.pageNumber, allFields);
        }


        scope.$on('bbGridFilter:changed', (event, fieldName, term) => {
            let formattedFields = fieldName + ',' + term.term;
            if(_.contains(searchFields, term)) {
                if(term.term === '') {
                    return;
                }
                else {
                    scope.getClients(scope.paginationOptions.pageNumber, formattedFields);
                }
            } else {
                createFilterString(fieldName, term)
            }
        });
    }
};


