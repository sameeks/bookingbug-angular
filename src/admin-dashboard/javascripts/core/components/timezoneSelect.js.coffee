'use strict'

###**
* @ngdoc component
* @name BBAdminDashboard.timezoneSelect
*
* @description
* Timezone list using ui-select
*
* @example
* <example>
*   <timezone-select restrict-region="Europe"></timezone-select>
* </example>
###

timezoneSelectController = ($timeout, $rootScope, $translate, TimezoneList, GeneralOptions, uiCalendarConfig) ->

  # angular.element('#uicalendar').fullCalendar('option', 'timezone', 'Australia/Sydney')
  #
  # $timeout(() ->
  #   angular.element('#uicalendar').fullCalendar('option', 'timezone', 'Australia/Sydney')
  #   console.log('done')
  # , 10000)

  this.$onInit = () ->
    this.timezones = TimezoneList.generateTzList(this.restrictRegion)
    return

  this.preventClose = (event) ->
    event.stopPropagation()

  this.updateTimeZone = (selectedTimezone) ->
    GeneralOptions.display_time_zone = selectedTimezone
    localStorage.selectedTimeZone = selectedTimezone
    $rootScope.$emit('timezoneUpdated', selectedTimezone)

  return

timezoneSelectComponent =
  templateUrl: 'core/_timezone-select.html',
  bindings:
    restrictRegion: '<'
  controller: timezoneSelectController

angular
  .module 'BBAdminDashboard'
  .component 'timezoneSelect', timezoneSelectComponent
