'use strict'

###*
* @ngdoc directive
* @name BB.Directives:bbResources
* @restrict AE
* @scope true
*
* @description
* Loads a list of resources for the currently in scope company
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @param {hash}  bbResources   A hash of options
* @param {BasketItem} bbItem The BasketItem that will be updated with the selected resource. If no item is provided, bb.current_item is used as the default
* @param {boolean}  waitForService   Wait for a the service to be loaded before loading Resources
* @param {boolean}  hideDisabled   In an admin widget, disabled resources are shown by default, you can choose to hide disabled resources
* @property {array} booking_item The current basket item being referred to
* @property {array} all_resources An array of all resources
* @property {array} bookable_items An array of all BookableItems - used if the current_item has already selected a services or person
* @property {array} bookable_resources An array of Resources - used if the current_item has already selected a services or person
* @property {resource} resource The currectly selected resource
* @example
*  <example module="BB">
*    <file name="index.html">
*   <div bb-api-url='https://dev01.bookingbug.com'>
*   <div  bb-widget='{company_id:37167}'>
*     <div bb-resources>
*        <ul>
*          <li ng-repeat='resource in all_resources'> {{resource.name}}</li>
*        </ul>
*     </div>
*     </div>
*     </div>
*   </file>
*  </example>
*
###

angular.module('BB.Directives').directive 'bbResources', () ->
  restrict: 'AE'
  replace: true
  scope: true
  controller: 'BBResourcesCtrl'
  controllerAs: '$bbResourcesCtrl'
  link: (scope, element, attrs) ->
    scope.options = scope.$eval(attrs.bbResources) or {}
    if attrs.bbItems
      scope.booking_items = scope.$eval(attrs.bbItems) or []
      scope.booking_item = scope.booking_items[0]
    else
      scope.booking_item = scope.$eval(attrs.bbItem) or scope.bb.current_item
      scope.booking_items = [scope.booking_item]
