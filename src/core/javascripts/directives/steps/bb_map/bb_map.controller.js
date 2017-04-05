angular.module('BB.Controllers').controller('MapCtrl', function ($scope, $element, $attrs, $rootScope, AlertService, FormDataStoreService, LoadingService, $q, $window, $timeout, ErrorService, $log, GeolocationService, GeneralOptions) {

    FormDataStoreService.init('MapCtrl', $scope, [
        'address',
        'selectedStore',
        'search_prms'
    ]);

    // init vars
    $scope.options = $scope.$eval($attrs.bbMap) || {};

    // when set to true, selectItem() does not call decideNextPage() when calling $scope.initWidget()
    $scope.no_route = $scope.options.no_route || false;

    $scope.num_search_results = $scope.options.num_search_results || 6;
    $scope.range_limit = $scope.options.range_limit || Infinity;
    $scope.hide_not_live_stores = $scope.options.hide_not_live_stores || false;
    $scope.can_filter_by_service = $scope.options.filter_by_service || false; // If set to true then the checkbox toggle for showing stores with/without the selected service will be shown in the template
    $scope.filter_by_service = $scope.options.filter_by_service || false; // The aforementioned checkbox is bound to this value which can be true or false depending on checked state, hence why we cannot use filter_by_service to show/hide the checkbox
    $scope.default_zoom = $scope.options.default_zoom || 6;

    // custom map marker icon can be set using GeneralOptions
    let defaultPin = GeneralOptions.map_marker_icon

    // when set to false, geolocate() only fills the input with the returned address and does not load the map
    $scope.loadMapOnGeolocate = true;

    let map_ready_def = $q.defer();
    $scope.mapLoaded = $q.defer();
    $scope.mapReady = map_ready_def.promise;
    $scope.map_init = $scope.mapLoaded.promise;
    $scope.showAllMarkers = false;
    $scope.mapMarkers = [];
    $scope.shownMarkers = $scope.shownMarkers || [];
    if (!$scope.numberedPin) {
        $scope.numberedPin = null;
    }
    if (!$scope.address && $attrs.bbAddress) {
        $scope.address = $scope.$eval($attrs.bbAddress);
    }

    let loader = LoadingService.$loader($scope);

    // setup geolocation shim
    webshim.setOptions({'waitReady': false, 'loadStyles': false});
    webshim.polyfill("geolocation");

    $rootScope.connection_started.then(() =>
        $scope.initialise()
    , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));

    /***
     * @ngdoc method
     * @name initialise
     * @methodOf BB.Directives:bbMap
     * @description
     * Initialise the google map
     *
     */
    $scope.initialise = function () {

        $scope.mapMarkers = [];
        $scope.shownMarkers = $scope.shownMarkers || [];

        if (!$scope.selectedStore) {
                loader.setLoaded();
            }

        if ($scope.bb.company.companies) {
            $rootScope.parent_id = $scope.bb.company.id;
        } else if ($rootScope.parent_id) {
            $scope.initWidget({
                company_id: $rootScope.parent_id,
                first_page: $scope.bb.current_page,
                keep_basket: true,
                item_defaults: $scope.bb.item_defaults ? $scope.bb.item_defaults : {}
            });
            return;
        } else {
            $scope.initWidget({company_id: $scope.bb.company.id, first_page: null});
            return;
        }

        $scope.companies = $scope.bb.company.companies;
        if (!$scope.companies || ($scope.companies.length === 0)) {
            $scope.companies = [$scope.bb.company];
        }

        if ($scope.bb.current_item.service && $scope.options && $scope.options.filter_by_service) {
            $scope.notLoaded($scope);

            filterByService().then(() =>
                $scope.map_init.then(() => mapInit())
            );
        } else {
            $scope.map_init.then(() => mapInit());
        }

        $scope.mapBounds = new google.maps.LatLngBounds();
        for (let comp of Array.from($scope.companies)) {
            if (comp.address && comp.address.lat && comp.address.long) {
                let latlong = new google.maps.LatLng(comp.address.lat, comp.address.long);
                $scope.mapBounds.extend(latlong);
            }
        }

        $scope.mapOptions = {
            center: $scope.mapBounds.getCenter(),
            zoom: $scope.default_zoom,
            mapTypeId: google.maps.MapTypeId.ROADMAP,
            mapTypeControl: true,
            mapTypeControlOptions: {
                style: window.google.maps.MapTypeControlStyle.DROPDOWN_MENU
            }
        };

        if ($scope.options && $scope.options.map_options) {
            for (let key in $scope.options.map_options) {
                let value = $scope.options.map_options[key];
                $scope.mapOptions[key] = value;
            }
        }

        return map_ready_def.resolve(true);
        };


    /***
     * @ngdoc method
     * @name filterByService
     * @methodOf BB.Directives:bbMap
     * @description
     * Set the has_service property and the service object on all companies
     * so companies can be filtered by service
     */
    var filterByService = function () {
        let deferred = $q.defer();
        if ($scope.bb.selected_service.$has('all_children')) {
            $scope.bb.selected_service.$get('all_children').then(resource =>
                resource.$get('services').then(function (services) {
                    let service;
                    let company_ids = _.map(services, service => service.company_id);

                    return Array.from($scope.companies).map((company) =>
                        (company.has_service = _.contains(company_ids, company.id),
                            service = _.find(services, service => service.company_id === company.id),
                            company.service = service,

                            deferred.resolve()));
                })
            );
        } else {
            deferred.resolve();
        }
        return deferred.promise;
    };


    /***
     * @ngdoc method
     * @name $scope.filterByService
     * @methodOf BB.Directives:bbMap
     * @description
     * Set $scope.shownMarkers to include / exclude
     * companies without the selected service
     */
    $scope.filterByService = function () {

        for (let marker of Array.from($scope.shownMarkers)) {
            marker.setMap(null);
        }

        if ($scope.options && $scope.filter_by_service) {
            $scope.shownMarkers = $scope.shown_markers_with_services;
        } else {
            $scope.shownMarkers = $scope.shown_markers;
        }

        return $timeout(() => setMarkers());
    };


    var mapInit = function () {
        for (let comp of Array.from($scope.companies)) {
            if (comp.address && comp.address.lat && comp.address.long) {
                let latlong = new google.maps.LatLng(comp.address.lat, comp.address.long);
                let marker = new google.maps.Marker({
                    map: $scope.myMap,
                    position: latlong,
                    visible: $scope.showAllMarkers,
                    icon: defaultPin
                });
                marker.company = comp;
                if (!$scope.hide_not_live_stores || !!comp.live) {
                    $scope.mapMarkers.push(marker);
                }
            }
        }

        $timeout(function () {
            $scope.myMap.fitBounds($scope.mapBounds);
            if ($scope.options.default_zoom) {
                $scope.myMap.setZoom($scope.default_zoom);
            }
            if ($scope.bb.current_item.service && $scope.options && $scope.filter_by_service) {
                return loader.setLoaded();
            }
        });
        return checkDataStore();
    };


    /***
     * @ngdoc method
     * @name loadMap
     * @methodOf BB.Directives:bbMap
     * @description
     * Set the center, zoom and show the closest markers on the Map
     *
     */
    var loadMap = function () {
        $scope.myMap.setCenter($scope.loc);
        if ($scope.options.default_zoom) {
            $scope.myMap.setZoom($scope.default_zoom);
        }
        $scope.showClosestMarkers($scope.loc);
        return;
    };


    /***
     * @ngdoc method
     * @name checkDataStore
     * @methodOf BB.Directives:bbMap
     * @description
     * If the user has clicked back to the map then display it.
     */
    var checkDataStore = function () {
        if ($scope.selectedStore) {
            loader.notLoaded();
            if ($scope.search_prms) {
                $scope.searchAddress($scope.search_prms);
            } else {
                $scope.geolocate();
            }
            return google.maps.event.addListenerOnce($scope.myMap, 'idle', () =>
                _.each($scope.mapMarkers, function (marker) {
                    if ($scope.selectedStore.id === marker.company.id) {
                        return google.maps.event.trigger(marker, 'click');
                    }
                }));
        }
    };


    /***
     * @ngdoc method
     * @name title
     * @methodOf BB.Directives:bbMap
     * @description
     * Create title for the map selection step
     */
    $scope.title = function () {
        let p1;
        let ci = $scope.bb.current_item;
        if (ci.category && ci.category.description) {
            p1 = ci.category.description;
        } else {
            p1 = $scope.bb.company.extra.department;
        }

        return p1 + ' - ' + $scope.$eval('getCurrentStepTitle()');
    };


    /***
     * @ngdoc method
     * @name searchAddress
     * @methodOf BB.Directives:bbMap
     * @description
     * Search address in according of prms parameter
     *
     * @param {object} prms The parameters of the address
     */
    $scope.searchAddress = function (prms) {

        // if a reverse geocode has been performed and the address
        // is no different to one the entered, abort the search
        if ($scope.loadMapOnGeolocate && $scope.reverse_geocode_address && ($scope.reverse_geocode_address === $scope.address)) {
            return false;
        }

        loader.notLoaded();

        $scope.loadMapOnGeolocate = true;

        delete $scope.geocoder_result;
        if (!prms) {
            prms = {};
        }
        $scope.search_prms = prms;
        $scope.map_init.then(function () {
            let {address} = $scope;
            if (prms.address) {
                ({address} = prms);
            }

            if (address) {
                let req = {address};
                if (prms.region) {
                    req.region = prms.region;
                }
                if (prms.componentRestrictions) {
                    req.componentRestrictions = prms.componentRestrictions;
                }

                if (prms.bounds) {
                    let sw = new google.maps.LatLng(prms.bounds.sw.x, prms.bounds.sw.y);
                    let ne = new google.maps.LatLng(prms.bounds.ne.x, prms.bounds.ne.y);
                    req.bounds = new google.maps.LatLngBounds(sw, ne);
                }

                return new google.maps.Geocoder().geocode(req, function (results, status) {

                    if ((results.length > 0) && (status === 'OK')) {
                        $scope.geocoder_result = results[0];
                    }

                    if (!$scope.geocoder_result || ($scope.geocoder_result && $scope.geocoder_result.partial_match)) {
                        searchPlaces(req);
                    } else if ($scope.geocoder_result) {
                        searchSuccess($scope.geocoder_result);
                    } else {
                        searchFailed();
                    }
                    loader.setLoaded();
                });
            }
        });

        return;
    };


    /***
     * @ngdoc method
     * @name searchPlaces
     * @methodOf BB.Directives:bbMap
     * @description
     * Search places in according of prms parameter
     *
     * @param {object} prms The parameters of the places
     */
    var searchPlaces = function (prms) {

        let req = {
            query: prms.address,
            types: ['shopping_mall', 'store', 'embassy'] // narrow place types to improve results
        };

        if (prms.bounds) {
            req.bounds = prms.bounds;
        }

        let service = new google.maps.places.PlacesService($scope.myMap);
        return service.textSearch(req, function (results, status) {
            if ((results.length > 0) && (status === 'OK')) {
                searchSuccess(results[0]);
            } else if ($scope.geocoder_result) {
                searchSuccess($scope.geocoder_result);
            } else {
                searchFailed();
            }
            return;
        });
    };


    /***
     * @ngdoc method
     * @name searchSuccess
     * @methodOf BB.Directives:bbMap
     * @description
     * Search has been succeeded, and return
     *
     * @param {object} result The result of the search
     */
    var searchSuccess = function (result) {
        AlertService.clear();
        $scope.search_failed = false;
        $scope.loc = result.geometry.location;
        $scope.formatted_address = result.formatted_address;
        if ($scope.loadMapOnGeolocate) {
            loadMap();
        }
        return $rootScope.$broadcast("map:search_success");
    };


    /***
     * @ngdoc method
     * @name searchFailed
     * @methodOf BB.Directives:bbMap
     * @description
     * Search failed and displayed an error
     */
    var searchFailed = function () {
        $scope.search_failed = true;
        AlertService.raise('LOCATION_NOT_FOUND');
        // need to call apply to update bindings as geocode callback is outside angular library
        return $rootScope.$apply();
    };


    /***
     * @ngdoc method
     * @name validateAddress
     * @methodOf BB.Directives:bbMap
     * @description
     * Validate the address using form
     *
     * @param {object} form The form where address has been validate
     */
    $scope.validateAddress = function (form) {
        if (!form) {
            return false;
        }
        if (form.$error.required) {
            AlertService.clear();
            AlertService.raise('MISSING_LOCATION');
            return false;
        } else {
            return true;
        }
    };


    /***
     * @ngdoc method
     * @name showClosestMarkers
     * @methodOf BB.Directives:bbMap
     * @description
     * Display the closest markers
     *
     * @param {Object} centre The map centre
     */
    $scope.showClosestMarkers = function (centre) {

        let distances = [];
        let distances_with_services = [];

        for (let marker of Array.from($scope.mapMarkers)) {

            let map_centre = {
                lat: centre.lat(),
                long: centre.lng()
            };

            let marker_position = {
                lat: marker.position.lat(),
                long: marker.position.lng()
            };

            marker.distance = GeolocationService.haversine(map_centre, marker_position);

            if (!$scope.showAllMarkers) {
                marker.setVisible(false);
            }

            if (marker.distance < $scope.range_limit) {
                distances.push(marker);
                if (marker.company.has_service) {
                    distances_with_services.push(marker);
                }
            }
        }

        distances.sort((a, b) => a.distance - b.distance);

        distances_with_services.sort((a, b) => a.distance - b.distance);

        $scope.setShownMarkers(distances, distances_with_services);

        if ($scope.shownMarkers.length != 0) {
            $timeout(() => setMarkers());
        }
        return;
    };


    /***
     * @ngdoc method
     * @name setShownMarkers
     * @methodOf BB.Directives:bbMap
     * @description
     * Set the shownMarkers on scope
     *
     * @param {array} distances Markers with property distance
     * @param {array} distances_with_services Markers with property distance and support the pre-selected service
     */
    $scope.setShownMarkers = function (distances, distances_with_services) {
        $scope.shown_markers = distances.slice(0, $scope.num_search_results);
        $scope.shown_markers_with_services = distances_with_services.slice(0, $scope.num_search_results);

        if ($scope.options && $scope.filter_by_service && $scope.shown_markers_with_services.length != 0) {
            $scope.shownMarkers = $scope.shown_markers_with_services;
        } else {
            $scope.shownMarkers = $scope.shown_markers;
        }
    };


    var setMarkers = function () {

        let latlong = $scope.loc;

        let localBounds = new google.maps.LatLngBounds();
        localBounds.extend(latlong);
        let index = 1;

        for (let marker of Array.from($scope.shownMarkers)) {
            if ($scope.numberedPin) {
                let iconPath = $window.sprintf($scope.numberedPin, index);
                marker.setIcon(iconPath);
            }

            marker.setVisible(true);
            marker.setMap($scope.myMap);
            localBounds.extend(marker.position);
            index += 1;
        }

        $scope.$emit('map:shown_markers_updated', $scope.shownMarkers);

        google.maps.event.trigger($scope.myMap, 'resize');
        $scope.myMap.fitBounds(localBounds);
        return openDefaultMarker();
    };


    var openDefaultMarker = function () {

        if ($scope.options && $scope.options.no_default_location_details) {
            return;
        }

        let open_marker_index = 0;
        let open_marker = _.find($scope.shownMarkers, function (obj) {
            open_marker_index++;
            return obj.company.id === $scope.bb.current_item.company.id;
        });
        if (open_marker) {
            open_marker_index--;
        } else {
            open_marker_index = 0;
        }
        $scope.shownMarkers[open_marker_index].is_open = true;
        return $scope.openMarkerInfo($scope.shownMarkers[open_marker_index]);
    };


    /***
     * @ngdoc method
     * @name openMarkerInfo
     * @methodOf BB.Directives:bbMap
     * @description
     * Display marker information on the map
     *
     * @param {object} marker The marker
     */
    $scope.openMarkerInfo = marker =>

        $timeout(function () {

                $scope.currentMarker = marker;
                $scope.myMap.setCenter(marker.position);
                $scope.myInfoWindow.open($scope.myMap, marker);
                for (let shown_marker of Array.from($scope.shownMarkers)) {
                    if (shown_marker.company.id === marker.company.id) {
                        shown_marker.is_open = true;
                    }
                }
                return $scope.shownMarkers;
            }
            , 250)
    ;


    /***
     * @ngdoc method
     * @name selectItem
     * @methodOf BB.Directives:bbMap
     * @description
     * Select an item from map
     *
     * @param {array} item The Map or BookableItem to select
     * @param {string=} route A specific route to load
     */
    $scope.selectItem = function (company, route) {
        if (!$scope.$debounce(1000)) {
            return;
        }

        if (!company) {
            AlertService.warning(ErrorService.getError('STORE_NOT_SELECTED'));
            return;
        } else if (!company.id) {
            AlertService.warning(ErrorService.getError('STORE_NOT_SELECTED'));
            $log.warn('valid company object not found');
            return;
        }


        loader.notLoaded();

        // if the selected store changes, emit an event. the form data store uses
        // this to clear data, but it can be used to action anything.
        if ($scope.selectedStore && ($scope.selectedStore.id !== company.id)) {
            $scope.$emit('change:storeLocation');
        }

        $scope.selectedStore = company;

        // Add answers object to the item_defaults if questions have already been asked before the map step
        if ($scope.bb.current_item.item_details && $scope.bb.current_item.item_details.questions) {
            setAnswers();
        }

        if (company.service) {
            $scope.bb.item_defaults.service = company.service.id;
        }

        let init_obj = {
            company_id: company.id,
            item_defaults: $scope.bb.item_defaults,
            no_route: $scope.options.no_route
        };
        if (route) {
            init_obj.first_page = route;
        }

        loader.setLoaded();

        return $scope.initWidget(init_obj);
    };


    var setAnswers = function () {
        let answers = {};
        for (let q of Array.from($scope.bb.current_item.item_details.questions)) {
            answers[`q_${q.name}`] = q.answer;
        }
        if (!_.isEmpty(answers)) {
            return $scope.bb.item_defaults.answers = answers;
        }
    };


    /***
     * @ngdoc method
     * @name roundNumberUp
     * @methodOf BB.Directives:bbMap
     * @description
     * Calculate the round number up
     *
     * @param {integer} num The number of places
     * @param {object} places The places
     */
    $scope.roundNumberUp = (num, places) => Math.round(num * Math.pow(10, places)) / Math.pow(10, places);

    /***
     * @ngdoc method
     * @name geolocate
     * @methodOf BB.Directives:bbMap
     * @description
     * Get geolocation information
     */
    $scope.geolocate = function (loadMapOnGeolocate = true) {
        if (!navigator.geolocation || ($scope.reverse_geocode_address && ($scope.reverse_geocode_address === $scope.address))) {
            return false;
        }

        $scope.loadMapOnGeolocate = loadMapOnGeolocate;

        loader.notLoaded();

        return webshim.ready('geolocation', function () {
            // set timeout as 5 seconds and max age as 1 hour
            let options = {timeout: 5000, maximumAge: 3600000};
            return navigator.geolocation.getCurrentPosition(reverseGeocode, geolocateFail, options);
        });
    };


    /***
     * @ngdoc method
     * @name geolocateFail
     * @methodOf BB.Directives:bbMap
     * @description
     * Geolocation fail and display an error message
     *
     * @param {object} error The error
     */
    var geolocateFail = function (error) {
        switch (error.code) {
            // if the geocode failed because the position was unavailable or the request timed out, raise an alert
            case 2:
            case 3:
                loader.setLoaded();
                AlertService.raise('GEOLOCATION_ERROR');
                break;
            default:
                loader.setLoaded();
        }
        return $scope.$apply();
    };


    /***
     * @ngdoc method
     * @name reverseGeocode
     * @methodOf BB.Directives:bbMap
     * @description
     * Reverse geocode in according of position parameter
     *
     * @param {object} positon The postion get latitude and longitude from google maps api
     */
    var reverseGeocode = function (position) {
        let lat = parseFloat(position.coords.latitude);
        let long = parseFloat(position.coords.longitude);
        let latlng = new google.maps.LatLng(lat, long);

        return new google.maps.Geocoder().geocode({'latLng': latlng}, function (results, status) {
            if ((results.length > 0) && (status === 'OK')) {
                $scope.geocoder_result = results[0];

                for (let ac of Array.from($scope.geocoder_result.address_components)) {
                    if (ac.types.indexOf("route") >= 0) {
                        $scope.reverse_geocode_address = ac.long_name;
                    }
                    if (ac.types.indexOf("locality") >= 0) {
                        $scope.reverse_geocode_address += `, ${ac.long_name}`;
                    }
                    $scope.address = $scope.reverse_geocode_address;
                }
                searchSuccess($scope.geocoder_result);
            }
            return $timeout(() => loader.setLoaded());
        });
    };


    /***
     * @ngdoc method
     * @name increaseRange
     * @methodOf BB.Directives:bbMap
     * @description
     * Increase range, the range limit is infinity
     */
    $scope.increaseRange = function () {
        $scope.range_limit = Infinity;
        return $scope.searchAddress($scope.search_prms);
    };


    // look for change in display size to determine if the map needs to be refreshed
    $scope.$watch('display.xs', (new_value, old_value) => {
            if ((new_value !== old_value) && $scope.loc) {
                $scope.myInfoWindow.close();
                loadMap();
                return;
            }
        }
    );


    return $rootScope.$on('widget:restart', function () {
        $scope.loc = null;
        $scope.reverse_geocode_address = null;
        return $scope.address = null;
    });
});
