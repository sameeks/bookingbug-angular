// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/**
 * @ngdoc directive
 * @name BBAdminDashboard.directive:contentHeight
 * @scope
 * @restrict A
 *
 * @description
 * Fix the contentContainer height (dependant on whether to include the header or the footer in the calculations)
 * Emits & boradcasts 'content.changed' event
 *
 * @param {boolean}  includeHeader  (optional) include the header in the calculation of the content height
 * @param {boolean}  includeFooter  (optional) include the footer in the calculation of the content height
 */
angular.module('BBAdminDashboard').directive('contentHeight', ($window, $timeout) => {
        return {
            restrict: 'A',
            link(scope, element, attributes) {

                let includeFooter = true;
                let includeHeader = true;

                if (attributes.includeHeader != null) {
                    ({includeHeader} = attributes);
                }
                if (attributes.includeFooter != null) {
                    ({includeFooter} = attributes);
                }

                $timeout((function () {
                    _contentHeightSetup();
                }), 10);
                angular.element($window).bind('resize', function () {
                    _contentHeightSetup();
                });

                var _contentHeightSetup = function () {
                    let height = $window.innerHeight;
                    //subtrackt the header height
                    if (includeHeader === true) {
                        height = height - angular.element(document).find('header')[0].offsetHeight;
                    }
                    //subtrackt the footer height
                    if (includeFooter === true) {
                        height = height - angular.element(document).find('footer')[0].offsetHeight;
                    }

                    element.css({
                        height: height + 'px'
                    });
                    //inform parents and children (custom-scrollbars, full-height iframes etc) that height has changed
                    scope.$emit('content.changed', {height});
                    scope.$broadcast('content.changed', {height});
                };
            }
        };
    }
);
