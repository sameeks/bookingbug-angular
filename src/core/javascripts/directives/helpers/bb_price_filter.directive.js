'use strict'

angular.module('BB.Directives').directive 'bbPriceFilter', (PathSvc) ->
  restrict: 'AE'
  replace: true
  scope: false
  require: '^?bbServices'
  templateUrl : (element, attrs) ->
    PathSvc.directivePartial "_price_filter"
  controller : ($scope, $attrs) ->
    $scope.$watch 'items', (new_val, old_val) ->
      setPricefilter new_val if new_val

    setPricefilter = (items) ->
      $scope.price_array = _.uniq _.map items, (item) ->
        return item.price / 100 or 0
      $scope.price_array.sort (a, b) ->
        return a - b
      suitable_max()

    suitable_max = () ->
      top_number = _.last($scope.price_array)
      max_number = switch
        when top_number < 1 then 0
        when top_number < 11 then 10
        when top_number < 51 then 50
        when top_number < 101 then 100
        when top_number < 1000 then ( Math.ceil( top_number / 100 ) ) * 100
      min_number = 0
      $scope.price_options = {
        min: min_number
        max: max_number
      }
      $scope.filters.price = {min: min_number, max: max_number}

    $scope.$watch 'filters.price.min', (new_val, old_val) ->
      $scope.filterChanged() if new_val != old_val

    $scope.$watch 'filters.price.max', (new_val, old_val) ->
      $scope.filterChanged() if new_val != old_val
