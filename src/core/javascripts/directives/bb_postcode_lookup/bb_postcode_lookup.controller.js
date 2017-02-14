// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Controllers').controller('PostcodeLookup', function ($scope, $rootScope, $q, ValidatorService, AlertService, LoadingService, $attrs) {

    angular.extend(this, new CompanyListBase($scope, $rootScope, $q, $attrs));

    let loader = LoadingService.$loader($scope);

    /***
     * @ngdoc method
     * @name searchPostcode
     * @methodOf BB.Directives:bbCompanies
     * @description
     * Search the postcode
     *
     * @param {object} form The form where postcode has been searched
     * @param {object} prms The parameters of postcode searching
     */
    $scope.searchPostcode = (form, prms) => {

        loader.notLoaded();

        let promise = ValidatorService.validatePostcode(form, prms);
        if (promise) {
            return promise.then(function () {
                    $scope.bb.postcode = ValidatorService.getGeocodeResult().address_components[0].short_name;
                    $scope.postcode = $scope.bb.postcode;
                    let loc = ValidatorService.getGeocodeResult().geometry.location;
                    return $scope.selectItem($scope.getNearestCompany({center: loc}));
                }
                , err => loader.setLoaded());
        } else {
            return loader.setLoaded();
        }
    };

    /***
     * @ngdoc method
     * @name getNearestCompany
     * @methodOf BB.Directives:bbCompanies
     * @description
     * Get nearest company in according of centre parameter
     *
     * @param {string} centre Map centre
     */
    return $scope.getNearestCompany = ({centre}) => {

        let distances = [];

        for (let company of Array.from($scope.items)) {

            if (company.address.lat && company.address.long && company.live) {

                let map_centre = {
                    lat: center.lat(),
                    long: centre.lng()
                };

                let company_position = {
                    lat: company.address.lat,
                    long: company.address.long
                };

                company.distance = GeolocationService.haversine(map_centre, company_position);

                distances.push(company);
            }
        }

        distances.sort((a, b) => {
                return a.distance - b.distance;
            }
        );

        return distances[0];
    };
});
