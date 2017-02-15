// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
 * @ngdoc directive
 * @name BB.Directives:bbServices
 * @restrict AE
 * @scope true
 *
 * @description
 *
 * Loads a list of services for the currently in scroe company
 *
 * <pre>
 * restrict: 'AE'
 * replace: true
 * scope: true
 * </pre>
 *
 * @param {hash}  bbServices   A hash of options
 * @param {boolean}  allowSinglePick   By default if there is only one service, it will be selected and routed, however you can force with directive to stop and show even if there is only a single service
 * @param {boolean}  hideDisabled   IN an admin widget, disabled services are shown by default, you can choose to hide disabled services
 * @param {boolean}  bbShowAll   Show all services even if the current basket item pre-selects a service or category
 * @property {array} all_services An array of all services
 * @property {array} filtered_items A filtered list according to a filter setting
 * @property {array} bookable_items An array of all BookableItems - used if the current_item has already selected a resource or person
 * @property {array} bookable_services An array of Services - used if the current_item has already selected a resource or person
 * @property {service} service The currectly selected service
 * @property {hash} filters A hash of filters
 * @example
 *  <example module="BB">
 *    <file name="index.html">
 *   <div bb-api-url='https://dev01.bookingbug.com'>
 *   <div  bb-widget='{company_id:37167}'>
 *     <div bb-services>
 *        <ul>
 *          <li ng-repeat='service in all_services'> {{service.name}}</li>
 *        </ul>
 *     </div>
 *     </div>
 *     </div>
 *   </file>
 *  </example>
 *
 *///


angular.module('BB.Directives').directive('bbServices', ($q, $compile, $templateCache) => {
        return {
            restrict: 'AE',
            replace: true,
            scope: true,
            transclude: true,
            controller: 'BBServicesCtrl',
            controllerAs: '$bbServicesCtrl',
            link(scope, element, attrs, ctrls, transclude) {

                scope.directives = "public.ServiceList";

                return transclude(scope, clone => {

                        // if there's content compile that or grab the _services template
                        let has_content = (clone.length > 1) || ((clone.length === 1) && (!clone[0].wholeText || /\S/.test(clone[0].wholeText)));

                        if (has_content) {
                            return element.html(clone).show();
                        } else {
                            return $q.when($templateCache.get('_services.html')).then(function (template) {
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
