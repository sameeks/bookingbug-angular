/*
 * @ngdoc service
 * @name BB.Services:scrollIntercepter
 *
 * @description
 * Accepts requests to scroll the viewport, depending on the type the request is either fullfilled or rejected.
 *
 */

angular.module('BB.Services').factory('scrollIntercepter', ($bbug, $window, GeneralOptions, AppService, $timeout) => {

    var currentlyScrolling = false;

    var scrollToElement = function(element, transitionTime, type) {

        if (type === "alert:raised") {
            //Alerts have precedence over other scroll events and can intercept
            currentlyScrolling = false;
        }

        if (!currentlyScrolling) {
            currentlyScrolling = true;

            // if theres a modal open, scrolling to it takes the higest precedence
            if (AppService.isModalOpen()) {
                $bbug('[uib-modal-window]').animate({
                    scrollTop: element.offset().top - GeneralOptions.scroll_offset
                }, transitionTime);
            } else if ('parentIFrame' in $window) {
                parentIFrame.scrollToOffset(0, element.offset().top - GeneralOptions.scroll_offset);
            } else {
                $bbug("html, body").animate({
                    scrollTop: element.offset().top - GeneralOptions.scroll_offset
                }, transitionTime);
            }
            $timeout(() =>
                //make sure the scroll is not interupted, unless it is an alert
                currentlyScrolling = false, transitionTime);
        } else {
            return;
        }
    }
    return {
        scrollToElement
    };

});
