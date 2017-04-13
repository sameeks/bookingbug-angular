// bbScrollTo
// Allows you to scroll to a specific element
angular.module('BB.Directives').directive('bbScrollTo', ($rootScope, AppConfig, BreadcrumbService, $bbug, $window, GeneralOptions, viewportSize, scrollIntercepter) => {
    return {
        transclude: false,
        restrict: 'A',
        link(scope, element, attrs) {

            let scrollToCallback;
            let evnts = attrs.bbScrollTo.split(',');
            let always_scroll = (attrs.bbAlwaysScroll != null) || false;
            let bb_transition_time = (attrs.bbTransitionTime != null) ? parseInt(attrs.bbTransitionTime, 10) : 500;

            if (angular.isArray(evnts)) {
                angular.forEach(evnts, evnt =>
                    scope.$on(evnt, e => scrollToCallback(evnt))
                );
            } else {
                scope.$on(evnts, e => scrollToCallback(evnts));
            }

            let isElementInView = el => (el.offset().top > $bbug('body').scrollTop()) && (el.offset().top < ($bbug('body').scrollTop() + $bbug(window).height()));

            return scrollToCallback = function (evnt) {
                let scroll_to_element;
                if ((evnt === "page:loaded") && viewportSize.isXS() && $bbug(`[data-scroll-id="${AppConfig.uid}"]`).length) {
                    scroll_to_element = $bbug(`[data-scroll-id="${AppConfig.uid}"]`);
                } else {
                    scroll_to_element = $bbug(element);
                }

                let current_step = BreadcrumbService.getCurrentStep();

                // if the event is page:loaded or the element is not in view, scroll to it
                if (scroll_to_element) {
                    if (((evnt === "page:loaded") && (current_step > 1)) || always_scroll || (evnt === "widget:restart") ||
                        (!isElementInView(scroll_to_element) && (scroll_to_element.offset().top !== 0))) {
                        scrollIntercepter.scrollToElement(scroll_to_element, bb_transition_time, evnt);
                    }
                }
            };
        }
    };
});
