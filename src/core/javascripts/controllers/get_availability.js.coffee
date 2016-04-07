'use strict';

###**
* @ngdoc directive
* @name BB.Directives:bbGetAvailability
* @restrict AE
* @scope true
*
* @description
* Loads a list of availability for the currently in scope company.
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @property {array} earliest_day Earliest available day
* @property {object} alert Alert Service- see {@link BB.Services:Alert Alert Service}
* @example
*  <example module="BB">
*    <file name="index.html">
*      <div bb-api-url='https://dev01.bookingbug.com'>
*        <div bb-widget='{company_id:37167}'>
*          <div bb-get-availability>
*
*          </div>
*        </div>
*      </div>
*    </file>
*  </example>
####

angular.module('BB.Directives').directive 'bbGetAvailability', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'GetAvailability'
  link : (scope, element, attrs) ->
    scope.options = scope.$eval(attrs.bbGetAvailability) or {}
    scope.directives = "public.GetAvailability"
    if attrs.bbGetAvailability
      scope.loadAvailability(scope.$eval( attrs.bbGetAvailability ) )
    return


angular.module('BB.Controllers').controller 'GetAvailability',
($scope, $element, $attrs, $rootScope, $q, TimeService, AlertService, BBModel, halClient) ->

  ###**
  * @ngdoc method
  * @name loadAvailability
  * @methodOf BB.Directives:bbGetAvailability
  * @description
  * Load availability of services according to prms parameter.
  *
  * @param {array} prms Availability parameter
  ###
  $scope.loadAvailability = (prms) =>

    service = halClient.$get($scope.bb.api_url + '/api/v1/' + prms.company_id + '/services/' + prms.service )
    service.then (serv) =>
      $scope.earliest_day = null
      sday = moment()
      eday = moment().add(30, 'days')
      serv.$get('days', {date: sday.toISOString(), edate: eday.toISOString()}).then (res) ->
        for day in res.days
          if day.spaces > 0 && !$scope.earliest_day
            $scope.earliest_day = moment(day.date)
            if day.first
              $scope.earliest_day.add(day.first, "minutes")
