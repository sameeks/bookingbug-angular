/***
 * @ngdoc directive
 * @name BB.Directives:bbPackageItems
 * @restrict AE
 * @scope true
 *
 * @description
 *
 * Loads a list of packages for the currently in scroe company
 *
 * <pre>
 * restrict: 'AE'
 * replace: true
 * scope: true
 * </pre>
 *
 * @param {hash}  bbPackgeItems   A hash of options
 * @property {array} packages An array of all services
 * @property {array} bookable_items An array of all BookableItems - used if the current_item has already selected a resource or person
 * @property {array} bookable_services An array of Services - used if the current_item has already selected a resource or person
 * @property {package} package The currectly selected package
 * @property {hash} filters A hash of filters
 * @example
 *  <example module="BB">
 *    <file name="index.html">
 *   <div bb-api-url='https://uk.bookingbug.com'>
 *   <div  bb-widget='{company_id:21}'>
 *     <div bb-package-items>
 *        <ul>
 *          <li ng-repeat='package in packages'> {{package.name}}</li>
 *        </ul>
 *     </div>
 *     </div>
 *     </div>
 *   </file>
 *  </example>
 *
 *///

angular.module('BB.Directives').directive('bbPackageItems', () => {
        return {
            restrict: 'AE',
            replace: true,
            scope: true,
            controller: 'PackageItem'
        };
    }
);
