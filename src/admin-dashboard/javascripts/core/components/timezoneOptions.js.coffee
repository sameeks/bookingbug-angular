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
    return

  this.updateTimeZone = (selectedTimezone) ->
    GeneralOptions.display_time_zone = selectedTimezone
    localStorage.selectedTimeZone = selectedTimezone
    $rootScope.$emit('timezoneUpdated', selectedTimezone)

  this.automaticTimezoneChanged = () ->
    if (this.automaticTimezone)
      this.selectedTimezone = null
      $rootScope.$broadcast('close-select')

    if (!this.automaticTimezone)
      GeneralOptions.use_local_time_zone = true
      this.selectedTimezone = TimezoneOptions.getLocalTimezone()
      $rootScope.$emit('timezoneUpdated', this.selectedTimezone.value)

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
