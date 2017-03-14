angular.module('BBAdminDashboard.calendar.directives').directive('bbNewBooking', () => {
        return {
            restrict: 'AE',
            replace: true,
            scope: true,
            controller($scope, $uibModal, $timeout, $rootScope, AdminBookingOptions, WidgetModalService) {

                return $scope.newBooking = () =>
                    WidgetModalService.open({
                        item_defaults: {
                            day_view: AdminBookingOptions.day_view,
                            merge_people: true,
                            merge_resources: true,
                            date: moment($scope.$parent.currentDate).isValid() ? moment($scope.$parent.currentDate).format('YYYY-MM-DD') : moment().format('YYYY-MM-DD')
                        },
                        company_id: $rootScope.bb.company.id,
                        on_conflict: "cancel()",
                        template: 'main'
                    })
                    ;
            }
        };
    }
);
