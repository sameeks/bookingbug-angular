/***
 * @ngdoc directive
 * @name BBAdminDashboard.check-in.directives:bbCheckIn
 * @restrict AE
 * @replace false
 * @scope true
 *
 * @description
 *
 * Intitialises and handles a table for appointment check-ins
 *
 * <pre>
 * restrict: 'AE'
 * replace: false
 * scope: true
 * </pre>
 */

(function () {

    angular
        .module('BBAdminDashboard')
        .component('bbCheckIn', {
            templateUrl: 'check-in/checkin-table.html',
            controller: bbCheckInCtrl,
            controllerAs: '$bbCheckInCtrl',
            bindings: {
                options: '=',
                bb: '='
            }
        });


    function bbCheckInCtrl($scope, $q, ModalForm, AlertService, BBModel, bbGridService, uiGridConstants, ClientCheckInOptions, CheckInService) {
        const initGrid = () => {
            setPaginationOptions();
            setGridApiOptions();
            setDisplayOptions();

            $scope.gridOptions = Object.assign(
                {},
                ClientCheckInOptions.basicOptions,
                this.gridApiOptions,
                this.gridDisplayOptions
            );
        };

        $scope.$on('checkIn:dataRecieved', (event, data) => {
           $scope.gridOptions.data = data;
        });


        this.setStatus = (booking, status) => {
            let clone = _.clone(booking);
            clone.current_multi_status = status;
            return booking.$update(clone).then(res => $scope.booking_collection.checkItem(res)
                , err => AlertService.danger({msg: 'Something went wrong'}));
        };

        this.edit = booking => {
            booking.$getAnswers().then((answers) => {
                for (let answer of Array.from(answers.answers)) {
                    booking[`question${answer.question_id}`] = answer.value;
                }
                return ModalForm.edit({
                    model: booking,
                    title: 'Booking Details',
                    templateUrl: 'edit_booking_modal_form.html',
                    success(b) {
                        b = new BBModel.Admin.Booking(b);
                        return $scope.bmap[b.id] = b;
                    }
                });
            });
        };

        const setPaginationOptions = () => {
            this.paginationOptions = {
                pageNumber: 1,
                pageSize: ClientCheckInOptions.paginationPageSize,
                sort: null
            };
        };

        const setGridApiOptions = () => {
            this.gridApiOptions = {
                onRegisterApi: (gridApi) => {
                    $scope.gridApi = gridApi;
                    $scope.gridData = CheckInService.getAppointments();
                    gridApi.pagination.on.paginationChanged($scope, (newPage, pageSize) => {
                        $scope.paginationOptions.pageNumber = newPage;
                        $scope.paginationOptions.pageSize = pageSize;
                        $scope.getAppointments($scope.paginationOptions.pageNumber + 1, null, null, null, null, true);
                    });

                    initWatchGridResize();
                }
            };
        };

        const setDisplayOptions = () => {
            this.gridDisplayOptions = {columnDefs: bbGridService.setColumns(ClientCheckInOptions.displayOptions)};
            bbGridService.setScrollBars(ClientCheckInOptions);

        };


        const initWatchGridResize = () => {
            $scope.gridApi.core.on.gridDimensionChanged($scope, () => {
                $scope.gridApi.core.handleWindowResize();
            });
        };

        initGrid();
    }

})();


