// bbAddressMap
// Adds behaviour to select first invalid input
angular.module('BB.Directives').directive('bbAddressMap', $document => {
        return {
            restrict: 'A',
            scope: true,
            replace: true,
            controller($scope, $element, $attrs, uiGmapGoogleMapApi) {

                $scope.isDraggable = $document.width() > 480;

                return uiGmapGoogleMapApi.then(function (maps) {
                    maps.visualRefresh = true;
                    return $scope.$watch($attrs.bbAddressMap, function (new_val, old_val) {

                        if (!new_val) {
                            return;
                        }

                        let map_item = new_val;

                        $scope.map = {
                            center: {
                                latitude: map_item.lat,
                                longitude: map_item.long
                            },
                            zoom: 15
                        };

                        $scope.options = {
                            scrollwheel: false,
                            draggable: $scope.isDraggable
                        };

                        return $scope.marker = {
                            id: 0,
                            coords: {
                                latitude: map_item.lat,
                                longitude: map_item.long
                            }
                        };
                    });
                });
            }
        };
    }
);

