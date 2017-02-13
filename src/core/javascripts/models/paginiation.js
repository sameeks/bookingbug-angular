/***
* @ngdoc service
* @name BB.Models:Service
*
* @description
* Representation of an Pagination Object
*
* @property {integer} current_page The current page
* @property {integer} page_size The number of items to show on each page
* @property {integer} request_page_size The request page size. Defaults to page_size when not provided. This value must be a multiple of the page_size.
* @property {integer} max_size Limit number for pagination size
* @property {integer} num_pages The total number of pages
* @property {integer} num_items The total number of items paginated
* @property {integer} items The items to be paginated
* @property {String} summary Summary of current page, i.e. 1 - 10 of 16
* @example
*  <example module="BB">
*    <file name="index.html">
*   <div bb-api-url='https://uk.bookingbug.com'>
*   <div bb-widget='{company_id:21}'>
*     <div bb-pagination-example>
*        <ul>
*          <li ng-repeat="item in pagination.items | startFrom: (pagination.current_page - 1) * pagination.page_size | limitTo: pagination.page_size | orderBy: sort_by track by $index">
*        </ul>
*     </div>
*     </div>
*     </div>
*   </file>
*   <file name="script.js">
*  angular.module('BB').directive('bbPaginationExample', function() {
*    return {
*      restrict: 'AE',
*      controller: function(BBModel, DataService) {
*       $scope.pagination = new BBModel.Pagination({
*         page_size: 10,
*         max_size: 5,
*         request_page_size: 10
*       });
*       $scope.getData = function(params, options) {
*         if (options == null) {
*           options = {};
*         }
*          $scope.params = {
*            per_page: $scope.pagination.request_page_size,
*           page: params.page || 1
*         };
*         return DataService.query($scope.params).then(function(result) {
*            if (options.add) {
*              return $scope.pagination.add(params.page, result.items);
*           } else {
*             return $scope.pagination.initialise(result.items, result.total_entries);
*           }
*         });
*       };
*        return $scope.pageChanged = function() {
*         var items_present, page_to_load, ref;
*         ref = $scope.pagination.update(), items_present = ref[0], page_to_load = ref[1];
*         if (!items_present) {
*            $scope.params.page = page_to_load;
*            return $scope.getData($scope.params, {
*              add: true
*           });
*         }
*       };
*     }
*   };
* });
*       </file>
*  </example>
*
*/
angular.module('BB.Models').factory("PaginationModel", () =>

  class Pagination {

    /***
    * @ngdoc method
    * @name constructor
    * @methodOf BB.Models:Service
    * @description
    * Constructor method
    *
    * @param {object} Options hash used to set page_size and max_size
    */
    constructor(options) {
      this.current_page = 1;
      this.page_size = options.page_size || 10;
      this.request_page_size = options.request_page_size || this.page_size;
      this.max_size = options.max_size || 5;
      this.num_pages = null;
      this.num_items = null;
      this.items = [];
    }


    /***
    * @ngdoc method
    * @name initialise
    * @methodOf BB.Models:Service
    * @description
    * Initiailises the pagination instance when first page has been retrieved
    *
    * @param {array} The first page of items returned by the API
    * @param {integer} The total number of items
    */
    initialise(items, total_items) {
      this.current_page = 1;
      this.items = items || [];
      this.num_items = total_items || 0;
      return this.update();
    }


    /***
    * @ngdoc method
    * @name update
    * @methodOf BB.Models:Service
    * @description
    * Updates the pagination summary when the page changes
    *
    * @returns {boolean} Flag to indicate if items in current page are present
    * @returns {integer} The page to load based on
    */
    update() {
      let start = ((this.current_page - 1) * this.page_size) + 1;
      let end   = this.current_page * this.page_size;
      end = this.num_items < end ? this.num_items : end;
      let total = end >= 100 ? "100+" : end;
      this.summary = $translate.instant('CORE.PAGINATION.SUMMARY', {start, end, total});

      let page_to_load = Math.ceil((this.current_page * this.page_size) / this.request_page_size);

      return [(this.items[start-1] != null), page_to_load];
    }


    /***
    * @ngdoc method
    * @name add
    * @methodOf BB.Models:Service
    * @description
    * Appends additional items (from subsequent data requests) to items array
    *
    * @param {integer} The page number of the data request
    * @param {array} The new items
    *
    */
    add(request_page, new_items) {
      let start = (request_page - 1) * this.request_page_size;
      return Array.from(new_items).map((item, index) =>
        this.items[start + index] = item);
    }
  }
);

