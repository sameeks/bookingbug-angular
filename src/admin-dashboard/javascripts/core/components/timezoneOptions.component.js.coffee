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

timezoneOptionsController = ($rootScope, TimezoneOptions, GeneralOptions, CompanyStoreService) ->

  this.$onInit = () ->
    this.timezones = TimezoneOptions.generateTzList(this.restrictRegion)

    if localStorage.selectedTimezone
      this.selectedTz = TimezoneOptions.mapTzForDisplay(localStorage.selectedTimezone)
      this.automaticTz = if moment.tz.guess() is localStorage.selectedTimezone then true else false
    else
      this.selectedTz = TimezoneOptions.mapTzForDisplay(CompanyStoreService.time_zone)

    return

  this.setTimezone = (timezone, setTzAutomatically = false) ->
    localStorage.selectedTimezone = GeneralOptions.display_time_zone = timezone
    GeneralOptions.custom_time_zone = if timezone and timezone != CompanyStoreService.time_zone then true else false
    GeneralOptions.set_time_zone_automatically = setTzAutomatically
    moment.tz.setDefault(timezone)
    $rootScope.$emit('timezoneUpdated', timezone)
    return

  this.automaticTimezoneToggle = () ->

    if this.automaticTz
      tz = moment.tz.guess()
      this.selectedTz = TimezoneOptions.mapTzForDisplay(tz)
      this.setTimezone(tz, true)

    if !this.automaticTz
      tz = CompanyStoreService.time_zone
      this.selectedTz = TimezoneOptions.mapTzForDisplay(tz)
      moment.tz.setDefault(tz)
      GeneralOptions.custom_time_zone = GeneralOptions.set_time_zone_automatically = false
      GeneralOptions.display_time_zone = null
      localStorage.removeItem('selectedTimezone')
      $rootScope.$emit('timezoneUpdated', null)

    $rootScope.$broadcast('close-select')

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
