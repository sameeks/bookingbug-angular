// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
* @ngdoc directive
* @name BB.Directives:bbBulkPurchases
* @restrict AE
* @scope true
*
* @description
*
* Loads a list of bulk purchases for the currently in scroe company
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @param {hash}  bbBulkPurchases   A hash of options
* @property {array} bulk_purchases An array of all services
* @property {array} bookable_items An array of all BookableItems - used if the current_item has already selected a resource or person
* @property {bulk_purchase} bulk_purchase The currectly selected bulk_purchase
* @example
*  <example module="BB">
*    <file name="index.html">
*   <div bb-api-url='https://uk.bookingbug.com'>
*   <div  bb-widget='{company_id:21}'>
*     <div bb-bulk-purchases>
*        <ul>
*          <li ng-repeat='bulk in bulk_purchases'> {{bulk.name}}</li>
*        </ul>
*     </div>
*     </div>
*     </div>
*   </file>
*  </example>
*
*///

angular.module('BB.Directives').directive('bbBulkPurchases', () =>
  ({
    restrict: 'AE',
    replace: true,
    scope : true,
    controller : 'BulkPurchase'
  })
);
