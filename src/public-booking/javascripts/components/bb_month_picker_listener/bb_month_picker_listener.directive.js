angular.module('BB.Directives').directive('bbMonthPickerListener', (PathSvc, $timeout) => {
        return {
            restrict: 'A',
            scope: true,
            link(scope, el, attrs) {
                $(window).resize(() =>
                    $timeout(() => scope.carouselIndex = 0)
                );

                return scope.$on('event_list_filter:changed', () =>
                    $timeout(() => scope.carouselIndex = 0)
                );
            }
        };
    }
);
