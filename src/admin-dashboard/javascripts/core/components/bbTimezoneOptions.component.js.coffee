'use strict'

###**
* @ngdoc component
* @name BBAdminDashboard.timezoneOptions
*
* @description
* Timezone options
*
* @example
* <example>
*   <timezone-options restrict-region="'Europe'"></timezone-options>
*   <timezone-options restrict-region="['Asia', 'America']"></timezone-options>
* </example>
###

timezoneOptionsController = ($scope, $rootScope, TimezoneOptions, GeneralOptions, CompanyStoreService) ->
  'ngInject'

  ctrl = @

  ctrl.timezones = []
  ctrl.automaticTimezone = false
  ctrl.selectedTimezone = null

  ctrl.$onInit = () ->
    ctrl.timezones = TimezoneOptions.generateTimezoneList(ctrl.restrictRegion)
    ctrl.setNewTimezone = setNewTimezone
    setDefaults()
    return

  ctrl.automaticTimezoneToggle = () ->

    if ctrl.automaticTimezone
      tz = moment.tz.guess()
      ctrl.selectedTimezone = TimezoneOptions.mapTimezoneForDisplay(tz)
      ctrl.setNewTimezone(tz, true)

    if !ctrl.automaticTimezone
      tz = CompanyStoreService.time_zone
      ctrl.selectedTimezone = TimezoneOptions.mapTimezoneForDisplay(tz)
      resetTimezone(tz)

    $scope.$broadcast('UISelect:CloseSelect')

    return

  setNewTimezone = (timezone, setTzAutomatically = false) ->
    localStorage.selectedTimezone = GeneralOptions.display_time_zone = timezone
    GeneralOptions.custom_time_zone = true if timezone isnt CompanyStoreService.time_zone
    GeneralOptions.set_time_zone_automatically = setTzAutomatically
    moment.tz.setDefault(timezone)
    $rootScope.$emit('BBTimezoneOptions:timezoneChanged', timezone)
    return

  resetTimezone = (tz) ->
    localStorage.removeItem('selectedTimezone')
    GeneralOptions.display_time_zone = null
    GeneralOptions.custom_time_zone = GeneralOptions.set_time_zone_automatically = false
    moment.tz.setDefault(tz)
    $rootScope.$emit('BBTimezoneOptions:timezoneChanged', null)

  setDefaults = () ->
    if localStorage.selectedTimezone
      ctrl.selectedTimezone = TimezoneOptions.mapTimezoneForDisplay(localStorage.selectedTimezone)
      ctrl.automaticTimezone = true if moment.tz.guess() is localStorage.selectedTimezone
    else
      ctrl.selectedTimezone = TimezoneOptions.mapTimezoneForDisplay(CompanyStoreService.time_zone)
    return

  return

timezoneOptionsComponent =
  templateUrl: 'core/_bb-timezone-options.html',
  bindings:
    restrictRegion: '<'
  controller: timezoneOptionsController

angular
  .module 'BBAdminDashboard'
  .component 'bbTimezoneOptions', timezoneOptionsComponent
