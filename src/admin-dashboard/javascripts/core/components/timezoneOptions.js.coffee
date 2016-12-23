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
    this.automaticTimezone = true
    this.timezones = TimezoneOptions.generateTzList(this.restrictRegion)
    this.generalTimezone = GeneralOptions
    return

  this.updateTimeZone = (selectedTimezone) ->
    GeneralOptions.display_time_zone = selectedTimezone
    console.log(GeneralOptions.display_time_zone)
    localStorage.selectedTimeZone = selectedTimezone
    $rootScope.$emit('timezoneUpdated', selectedTimezone)

  this.resetTimezone = () ->
    if (!this.automaticTimezone)
      GeneralOptions.use_local_time_zone = true
      this.selectedTimezone = TimezoneOptions.getLocalTimezone()
    if (this.automaticTimezone)
      $rootScope.$broadcast('close-select')
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
