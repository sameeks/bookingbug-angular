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
*   <timezone-options restrict-region="Europe"></timezone-options>
* </example>
###

timezoneOptionsController = ($rootScope, TimezoneOptions, GeneralOptions, CompanyStoreService) ->

  this.$onInit = () ->
    this.timezones = TimezoneOptions.generateTzList(this.restrictRegion)
    if localStorage.selectedTimeZone
      this.selectedTimezone = TimezoneOptions.mapTzForDisplay(localStorage.selectedTimeZone)
    else
      this.selectedTimezone = TimezoneOptions.mapTzForDisplay(CompanyStoreService.time_zone)
    return

  this.setTimezone = (selectedTimezone, setTimezoneAutomatically) ->
    localStorage.selectedTimeZone = selectedTimezone
    GeneralOptions.set_time_zone_automatically = setTimezoneAutomatically
    GeneralOptions.display_time_zone = selectedTimezone
    $rootScope.$emit('timezoneUpdated', selectedTimezone)

  this.setAutomaticTimezone = () ->
    if (this.automaticTimezone)
      tz = moment.tz.guess()
      this.selectedTimezone = TimezoneOptions.mapTzForDisplay(tz)
      this.setTimezone(tz, true)
      $rootScope.$broadcast('close-select')

    if (!this.automaticTimezone)
      this.selectedTimezone = TimezoneOptions.mapTzForDisplay(CompanyStoreService.time_zone)
      this.setTimezone(null, false)
      localStorage.removeItem('selectedTimeZone')

    return

  return

timezoneOptionsComponent =
  templateUrl: 'core/_timezone-options.html',
  bindings:
    restrictRegion: '<'
  controller: timezoneOptionsController

angular
  .module 'BBAdminDashboard'
  .component 'timezoneOptions', timezoneOptionsComponent
