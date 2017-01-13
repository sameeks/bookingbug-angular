angular.module('BB.Controllers').controller 'PostcodeLookup', ($scope,  $rootScope, $q, ValidatorService, AlertService, LoadingService, $attrs) ->
  $scope.controller = "PostcodeLookup"
  angular.extend(this, new CompanyListBase($scope, $rootScope, $q, $attrs))


  $scope.validator = ValidatorService
  loader = LoadingService.$loader($scope)

  ###**
  * @ngdoc method
  * @name searchPostcode
  * @methodOf BB.Directives:bbCompanies
  * @description
  * Search the postcode
  *
  * @param {object} form The form where postcode has been searched
  * @param {object} prms The parameters of postcode searching
  ###
  $scope.searchPostcode = (form, prms) =>

    loader.notLoaded()

    promise = ValidatorService.validatePostcode(form, prms)
    if promise
      promise.then () ->
        $scope.bb.postcode = ValidatorService.getGeocodeResult().address_components[0].short_name
        $scope.postcode = $scope.bb.postcode
        loc = ValidatorService.getGeocodeResult().geometry.location
        $scope.selectItem($scope.getNearestCompany({center: loc}))
      ,(err) ->
        loader.setLoaded()
    else
      loader.setLoaded()

  ###**
  * @ngdoc method
  * @name getNearestCompany
  * @methodOf BB.Directives:bbCompanies
  * @description
  * Get nearest company in according of centre parameter
  *
  * @param {string} centre Map centre
  ###
  $scope.getNearestCompany = ({centre}) =>

    distances = []

    for company in $scope.items

      if company.address.lat and company.address.long and company.live

        map_centre = {
          lat:  center.lat()
          long: centre.lng()
        }

        company_position = {
          lat:  company.address.lat
          long: company.address.long
        }

        company.distance = GeolocationService.haversine(map_centre, company_position)

        distances.push company

    distances.sort (a,b) =>
      a.distance - b.distance

    return distances[0]
