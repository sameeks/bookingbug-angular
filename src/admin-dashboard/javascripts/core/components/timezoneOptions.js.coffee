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

timezoneOptionsController = ($rootScope, TimezoneOptions, GeneralOptions) ->

  this.$onInit = () ->
    this.selectedTimezone = TimezoneOptions.getLocalTimezone()
    this.automaticTimezone = true
    this.timezones = TimezoneOptions.generateTzList(this.restrictRegion)
    return

  this.updateTimeZone = (selectedTimezone) ->
    GeneralOptions.display_time_zone = selectedTimezone
    localStorage.selectedTimeZone = selectedTimezone
    $rootScope.$emit('timezoneUpdated', selectedTimezone)

  this.resetTimezone = () ->
    if (this.automaticTimezone)
      this.selectedTimezone = TimezoneOptions.getLocalTimezone()
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
