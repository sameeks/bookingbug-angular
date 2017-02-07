'use strict'


###**
* @ngdoc directive
* @name BB.Directives:bbProductList
* @restrict AE
* @scope true
*
* @description
*
* Loads a list of product for the currently in scope company
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @property {array} products The products from the list
* @property {array} item The item of the product list
* @property {array} booking_item The booking item
* @property {product} product The currectly selected product
####


angular.module('BB.Directives').directive 'bbProductList', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'ProductList'
  link : (scope, element, attrs) ->
    if attrs.bbItem
      scope.booking_item = scope.$eval( attrs.bbItem )
    if attrs.bbShowAll
      scope.show_all = true
    return
