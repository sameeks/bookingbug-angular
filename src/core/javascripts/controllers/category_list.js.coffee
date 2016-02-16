'use strict';


###**
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
####


angular.module('BB.Directives').directive 'bbCategories', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'CategoryList'


angular.module('BB.Controllers').controller 'CategoryList',
($scope, $rootScope, $q, PageControllerService, BBModel) ->
  $scope.controller = "public.controllers.CategoryList"
  $scope.notLoaded $scope

  angular.extend(this, new PageControllerService($scope, $q))

  $rootScope.connection_started.then =>
    if $scope.bb.company
      $scope.init($scope.bb.company)
  , (err) ->  $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')

  $scope.init = (comp) =>
    BBModel.Category.$query(comp).then (items) =>
      $scope.items = items
      if (items.length == 1)
        $scope.skipThisStep()
        $rootScope.categories = items
        $scope.selectItem(items[0], $scope.nextRoute )
      $scope.setLoaded $scope
    , (err) ->  $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')

  ###**
  * @ngdoc method
  * @name selectItem
  * @methodOf BB.Directives:bbCategories
  * @description
  * Select an item
  *
  * @param {object} item The Service or BookableItem to select
  * @param {string=} route A specific route to load
  ###
  $scope.selectItem = (item, route) =>
    $scope.bb.current_item.setCategory(item)
    $scope.decideNextPage(route)

