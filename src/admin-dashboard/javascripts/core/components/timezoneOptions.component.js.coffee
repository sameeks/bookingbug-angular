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
    this.timezones = TimezoneOptions.generateTimezoneList(this.restrictRegion)
    if localStorage.selectedTimezone
      this.selectedTimezone = TimezoneOptions.mapTimezoneForDisplay(localStorage.selectedTimezone)
      this.automaticTimezone = if moment.tz.guess() is localStorage.selectedTimezone then true else false
    else
      this.selectedTimezone = TimezoneOptions.mapTimezoneForDisplay(CompanyStoreService.time_zone)
    return

  this.automaticTimezoneToggle = () ->

    if this.automaticTimezone
      tz = moment.tz.guess()
      this.selectedTimezone = TimezoneOptions.mapTimezoneForDisplay(tz)
      this.setNewTimezone(tz, true)

    if !this.automaticTimezone
      tz = CompanyStoreService.time_zone
      this.selectedTimezone = TimezoneOptions.mapTimezoneForDisplay(tz)
      this.resetTimezone(tz)

    $rootScope.$broadcast('close-select')

    return

  this.setNewTimezone = (timezone, setTzAutomatically = false) ->
    localStorage.selectedTimezone = GeneralOptions.display_time_zone = timezone
    GeneralOptions.custom_time_zone = if timezone != CompanyStoreService.time_zone then true else false
    GeneralOptions.set_time_zone_automatically = setTzAutomatically
    moment.tz.setDefault(timezone)
    $rootScope.$emit('timezoneUpdated', timezone)
    return

  this.resetTimezone = (tz) ->
    localStorage.removeItem('selectedTimezone')
    GeneralOptions.display_time_zone = null
    GeneralOptions.custom_time_zone = GeneralOptions.set_time_zone_automatically = false
    moment.tz.setDefault(tz)
    $rootScope.$emit('timezoneUpdated', null)

  return

timezoneOptionsComponent =
  templateUrl: 'core/_timezone-options.html',
  bindings:
    restrictRegion: '<'
  controller: timezoneOptionsController

angular
  .module 'BBAdminDashboard'
  .component 'bbTimezoneOptions', timezoneOptionsComponent
