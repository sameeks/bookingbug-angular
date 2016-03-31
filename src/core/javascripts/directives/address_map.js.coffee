# bbAddressMap
# Adds behaviour to select first invalid input
angular.module('BB.Directives').directive 'bbAddressMap', ($document) ->
  restrict: 'A'
  replace: true
  controller: ($scope, $element, $attrs) ->
    $element.addClass('map-canvas')
    map = new google.maps.Map $element[0],
      zoom: 15
      #scrollwheel: false,
      #draggable: $scope.isDraggable
    $scope.$watch $attrs.bbAddressMap, (value) ->
      return unless value
      center = {lat: value.lat, lng: value.long}
      map.setCenter(center)
      marker = new google.maps.Marker
        position: center,
        map: map
