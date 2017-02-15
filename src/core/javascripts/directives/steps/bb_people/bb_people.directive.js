/**
 * @ngdoc directive
 * @name BB.Directives:bbPeople
 * @restrict AE
 * @scope true
 *
 * @description
 *
 * Loads a list of peoples for the currently in scope company
 *
 * <pre>
 * restrict: 'AE'
 * replace: true
 * scope: true
 * </pre>
 *
 * @param {BasketItem} bbItem The BasketItem that will be updated with the selected person. If no item is provided, bb.current_item is used as the default
 * @param {array} bbItems An array of BasketItem's that will be updated with the selected person.
 * @property {array} items A list of people
 * @property {array} bookable_people The bookable people from the person list
 * @property {array} bookable_items The bookable items from the person list
 * @property {array} booking_item The BasketItem used by the person list. If bbItems provided, this will be the first item
 * @example
 *  <example module="BB">
 *    <file name="index.html">
 *   <div bb-api-url='https://dev01.bookingbug.com'>
 *   <div  bb-widget='{company_id:37167}'>
 *     <div bb-people>
 *        <ul>
 *          <li ng-repeat='person in all_people'> {{person.name}}</li>
 *        </ul>
 *     </div>
 *     </div>
 *     </div>
 *   </file>
 *  </example>
 */
angular.module('BB.Directives').directive('bbPeople', () => {
        return {
            restrict: 'AE',
            replace: true,
            scope: true,
            controller: 'BBPeopleCtrl',
            controllerAs: '$bbPeopleCtrl',
            link(scope, element, attrs) {
                if (attrs.bbItems) {
                    scope.booking_items = scope.$eval(attrs.bbItems) || [];
                    return scope.booking_item = scope.booking_items[0];
                } else {
                    scope.booking_item = scope.$eval(attrs.bbItem) || scope.bb.current_item;
                    return scope.booking_items = [scope.booking_item];
                }
            }
        };
    }
);
