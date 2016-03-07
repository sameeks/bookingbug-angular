'use strict';

CompanyListBase = ($scope, $rootScope, $q, $attrs) ->

  $scope.controller = "public.controllers.CompanyList"
  $scope.notLoaded $scope

  options = $scope.$eval $attrs.bbCompanies

  $rootScope.connection_started.then =>
    if $scope.bb.company.companies
      $scope.init($scope.bb.company)
      $rootScope.parent_id = $scope.bb.company.id
    else if $rootScope.parent_id
      $scope.initWidget({company_id:$rootScope.parent_id, first_page: $scope.bb.current_page})
      return
    else
      $scope.init($scope.bb.company)
  , (err) ->  $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')

  $scope.init = (comp) =>
    
    $scope.companies = $scope.bb.company.companies
    if !$scope.companies || $scope.companies.length == 0
      $scope.companies = [$scope.bb.company]

    if $scope.companies.length == 1
      $scope.skipThisStep()
      $scope.selectItem($scope.companies[0])
    else
      if options and options.hide_not_live_stores
        $scope.items = $scope.companies.filter (c) -> c.live
      else
        $scope.items = $scope.companies
    $scope.setLoaded $scope

  $scope.selectItem = (item, route) =>

    # if company id is passed in, set the company id to this number
    if angular.isNumber(item)
      company_id = item
    else
      company_id = item.id

    $scope.notLoaded $scope
    prms = {company_id: company_id}
    $scope.initWidget(prms)

  # TODO move this into a mothercare js file
  $scope.splitString = (company) ->
    arr    = company.name.split(' ')
    result = if arr[2] then arr[2] else ""


###**
* @ngdoc directive
* @name BB.Directives:bbCompanies
* @restrict AE
* @scope true
*
* @description
*
* Loads a list of companies for the currently in scope company
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @property {integer} id The company id
* @property {string} name The company name
* @property {integer} address_id Company address id
* @property {string} country_code Company country code
* @property {string} currency_code The company currency code
* @property {string} timezone The company time zone
* @property {integer} numeric_widget_id The numeric widget id of the company
* @property {object} validator The validator service - see {@link BB.Services:Validator Validator Service}
* @property {object} alert The alert service - see {@link BB.Services:Alert Alert Service}
* @example
*  <example module="BB"> 
*    <file name="index.html">
*   <div bb-api-url='https://uk.bookingbug.com'>
*   <div  bb-widget='{company_id:21}'>
*     <div bb-company>
*       <p>id: {{company.id}}</p>
*        <p>name: {{company.name}}</p>
*        <p>address_id: {{company.address_id}}</p>
*        <p>country_code: {{company.country_code}}</p>
*        <p>currency_code: {{company.country_code}}</p>
*        <p>timezone: {{company.timezone}}</p>
*        <p>numeric_widget_id: {{company.numeric_widget_id}}</p>
*      </div>
*     </div>
*     </div>
*   </file> 
*  </example> 
####

angular.module('BB.Directives').directive 'bbCompanies', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'CompanyList'

angular.module('BB.Controllers').controller 'CompanyList', CompanyListBase

angular.module('BB.Directives').directive 'bbPostcodeLookup', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'PostcodeLookup'


angular.module('BB.Controllers').controller 'PostcodeLookup', ($scope,  $rootScope, $q, ValidatorService, AlertService, $attrs) ->
  $scope.controller = "PostcodeLookup"
  angular.extend(this, new CompanyListBase($scope, $rootScope, $q, $attrs))


  $scope.validator = ValidatorService

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

    $scope.notLoaded($scope)

    promise = ValidatorService.validatePostcode(form, prms)
    if promise
      promise.then () ->
        $scope.bb.postcode = ValidatorService.getGeocodeResult().address_components[0].short_name
        $scope.postcode = $scope.bb.postcode
        loc = ValidatorService.getGeocodeResult().geometry.location
        $scope.selectItem($scope.getNearestCompany({center: loc}))
      ,(err) ->
        $scope.setLoaded($scope)
    else
      $scope.setLoaded($scope)

  ###**
  * @ngdoc method
  * @name getNearestCompany
  * @methodOf BB.Directives:bbCompanies
  * @description
  * Get nearest company in according of center parameter
  * 
  * @param {string} center Geolocation parameter
  ###
  $scope.getNearestCompany = ({center}) =>

    pi = Math.PI;
    R = 6371  #equatorial radius
    distances = []

    lat1 = center.lat();
    lon1 = center.lng();

    for company in $scope.items
      if company.address.lat && company.address.long && company.live
        latlong = new google.maps.LatLng(company.address.lat,company.address.long)

        lat2 = latlong.lat()
        lon2 = latlong.lng()

        chLat = lat2-lat1;
        chLon = lon2-lon1;

        dLat = chLat*(pi/180);
        dLon = chLon*(pi/180);

        rLat1 = lat1*(pi/180);
        rLat2 = lat2*(pi/180);

        a = Math.sin(dLat/2) * Math.sin(dLat/2) +
                Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(rLat1) * Math.cos(rLat2);
        c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
        d = R * c;

        company.distance = d
        distances.push company

      distances.sort (a,b)=>
        a.distance - b.distance

    return distances[0]

