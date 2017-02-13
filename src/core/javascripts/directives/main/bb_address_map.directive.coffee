'use strict'


# bbAddressMap
# Adds behaviour to select first invalid input
angular.module('BB.Directives').directive 'bbAddressMap', ($document) ->
  restrict: 'A'
  scope: true
  replace: true
  controller: ($scope, $element, $attrs, uiGmapGoogleMapApi) ->

    $scope.isDraggable = $document.width() > 480

    uiGmapGoogleMapApi.then (maps)->
      maps.visualRefresh = true
      $scope.$watch $attrs.bbAddressMap, (new_val, old_val) ->

        return if !new_val

        map_item = new_val

        $scope.map = {
          center: {
            latitude: map_item.lat,
            longitude: map_item.long
          },
          zoom: 15
        }

        $scope.options = {
          scrollwheel: false,
          draggable: $scope.isDraggable
        }

        $scope.marker = {
          id: 0,
          coords: {
            latitude: map_item.lat,
            longitude: map_item.long
          }
        }
