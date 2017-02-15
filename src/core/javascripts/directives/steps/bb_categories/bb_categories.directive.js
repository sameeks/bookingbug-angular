// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
 * @ngdoc directive
 * @name BB.Directives:bbCategories
 * @restrict AE
 * @scope true
 *
 * @description
 * Loads a list of categories for the currently in scope company
 *
 * <pre>
 * restrict: 'AE'
 * replace: true
 * scope: true
 * </pre>
 *
 * @property {string} name The category name
 * @property {integer} id The category id
 * @example
 *  <example module="BB">
 *    <file name="index.html">
 *   <div bb-api-url='https://uk.bookingbug.com'>
 *   <div  bb-widget='{company_id:21}'>
 *     <div bb-categories>
 *        <ul>
 *          <li ng-repeat='category in items'>name: {{category.name}}</li>
 *        </ul>
 *     </div>
 *     </div>
 *     </div>
 *   </file>
 *  </example>
 *
 *///


angular.module('BB.Directives').directive('bbCategories', () => {
        return {
            restrict: 'AE',
            replace: true,
            scope: true,
            controller: 'CategoryList'
        };
    }
);
