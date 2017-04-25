 (function () {
    /***
     * @ngdoc component
     * @name BBAdminDashboard:bbClientBookingTable
     * @scope true
     *
     * @description
     *
     * Intitialises and handles a table for a specific clients bookings
     *
     * <pre>
     * restrict: 'AE'
     * replace: true
     * scope: true
     * </pre>
     */

    angular
        .module('BBAdminDashboard.clients.directives')
        .component('bbClientBookingTable', {
            templateUrl: 'clients/bookings_table.html',
            controller: bbClientBookingTableCtrl,
            controllerAs: '$bbClientBookingTableCtrl',
            bindings: {
                member: '=',
                startDate: '=?',
                startTime: '=?',
                endDate: '=?',
                endTime: '=?',
                period: '@',
                tabset: '='
            }
        });

    function bbClientBookingTableCtrl($scope) {
        $scope.$watch('tabset.active', () => {
            $timeout(() => {
                // we need to only show a grid if its tab is active
                // otherwise ui-grid will not know what size it should be and would display incorrectly
                // http://ui-grid.info/docs/#/tutorial/108_hidden_grids
                $scope.activeGrid = $scope.tabset.active;
            });
        });

        scope.$on('bookings:loaded', (event, data) => {
            $scope.gridOptions.data = $scope.bookings;
        });

        const initGrid = () => {
            setGridApiOptions();
            setDisplayOptions();

            $scope.gridOptions = Object.assign(
                {},
                ClientBookingsTableOptions.basicOptions,
                this.gridApiOptions,
                this.gridDisplayOptions
            );
        };

        const setGridApiOptions = () => {
            this.gridApiOptions = {
                onRegisterApi: (gridApi) => {
                    $scope.gridApi = gridApi;
                    gridApi.selection.on.rowSelectionChanged($scope, (row) => {
                        $scope.edit(row.entity.id);
                    });

                    initWatchGridResize();
                }
            };
        };

        const setDisplayOptions = () => {
            this.gridDisplayOptions = {columnDefs: bbGridService.setColumns(ClientBookingsTableOptions.displayOptions)};
            bbGridService.setScrollBars(ClientBookingsTableOptions);
        };

        const initWatchGridResize = () => {
            $scope.gridApi.core.on.gridDimensionChanged($scope, () => {
                $scope.gridApi.core.handleWindowResize();
            });
        };

      $scope.$watch('member', (member) => {
            return getBookings($scope, member);
        });


        /***
         * @ngdoc method
         * @name edit
         * @methodOf BBAdminDashboard.clients.directives:bbClientBookingsTable
         * @description
         * Opens modal to edit client's booking details
         *
         * @param {integer} id The id of the booking to be edited
        */
        $scope.edit = (id) => {
            let booking = _.find($scope.booking_models, b => b.id === id);
            booking.$getAnswers().then((answers) => {
                for (let answer of Array.from(answers.answers)) {
                    booking[`question${answer.question_id}`] = answer.value;
                }
                ModalForm.edit({
                    model: booking,
                    title: 'Booking Details',
                    templateUrl: 'edit_booking_modal_form.html',
                        success(response) {
                            handleModal(response, booking);
                        }
                    }
                );
            });
        };


        /***
         * @ngdoc method
         * @name edit
         * @methodOf BBAdminDashboard.clients.directives:bbClientBookingsTable
         * @description
         * Opens modal to cancel client's booking
         *
         * @param {integer} id The id of the booking to be cancelled
         */
        $scope.cancel = (id) => {
            const booking = _.find($scope.booking_models, b => b.id === id);

            const modalInstance = $uibModal.open({
                templateUrl: 'member_bookings_table_cancel_booking.html',
                controller($scope, $uibModalInstance, booking) {
                    $scope.booking = booking;
                    $scope.booking.notify = true;
                    $scope.ok = () => $uibModalInstance.close($scope.booking);
                    return $scope.close = () => $uibModalInstance.dismiss();
                },
                scope: $scope,
                resolve: {
                    booking() {
                        return booking;
                    }
                }
            });

            modalInstance.result.then((booking) => {
                cancelBooking(booking);
            });
        };


        // const init = () => {
        //     if (!$scope.startDate) {
        //         $scope.startDate = moment();
        //     }

        //     if ($scope.member) {
        //         return getBookings($scope, $scope.member);
        //     }
        // };




        initGrid();
    }
})();

