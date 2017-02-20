/***
 * @ngdoc directive
 * @name BB.Directives:bbItemDetails
 * @restrict AE
 * @scope true
 *
 * @description
 *
 * Loads a list of item details for the currently in scope company
 *
 * <pre>
 * restrict: 'AE'
 * replace: true
 * scope: true
 * </pre>
 *
 * @property {array} item An array of all item details
 * @property {array} product The product
 * @property {array} booking The booking
 * @property {array} upload_progress The item upload progress
 * @property {object} validator The validator service - see {@link BB.Services:Validator Validator Service}
 * @property {object} alert The alert service - see {@link BB.Services:Alert Alert Service}
 */


angular.module('BB.Directives').directive('bbItemDetails', ($q, $templateCache, $compile) => {
        return {
            restrict: 'AE',
            replace: true,
            scope: true,
            transclude: true,
            controller: 'ItemDetails',
            link(scope, element, attrs, controller, transclude) {
                if (attrs.bbItemDetails) {
                    let item = scope.$eval(attrs.bbItemDetails);
                    scope.item_from_param = item;
                    if (scope.item_details) {
                        delete scope.item_details;
                    }
                    if (item) {
                        scope.loadItem(item);
                    }
                }

                return transclude(scope, clone => {
                        // if there's content compile that or grab the week_calendar template
                        let has_content = (clone.length > 1) || ((clone.length === 1) && (!clone[0].wholeText || /\S/.test(clone[0].wholeText)));
                        if (has_content) {
                            return element.html(clone).show();
                        } else {
                            return $q.when($templateCache.get('_item_details.html')).then(function (template) {
                                element.html(template).show();
                                return $compile(element.contents())(scope);
                            });
                        }
                    }
                );
            }
        };
    }
);
