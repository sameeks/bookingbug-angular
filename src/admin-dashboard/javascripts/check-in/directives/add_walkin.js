angular.module('BBAdminDashboard.check-in.directives').directive('bbAddWalkin', () => {
        return {
            restrict: 'AE',
            replace: true,
            scope: true,
            link(scope, element, attrs) {

            },
            controller($scope, WidgetModalService, $timeout) {

                return $scope.walkIn = () =>

                    WidgetModalService.open({
                        item_defaults: {
                            pick_first_time: true,
                            merge_people: true,
                            merge_resources: true,
                            date: moment().format('YYYY-MM-DD')
                        },
                        on_conflict: "cancel()",
                        company_id: $scope.bb.company.id
                    })
                    ;
            }
        };
    }
);

