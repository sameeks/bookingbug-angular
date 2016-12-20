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

timezoneSelectController = ($translate, TimezoneList) ->

  this.$onInit = () ->
    this.timezones = TimezoneList.generateTzList(this.restrictRegion)
    return

  this.preventClose = (event) ->
    event.stopPropagation()

  return

timezoneSelectComponent =
  templateUrl: 'core/_timezone-select.html',
  bindings:
    restrictRegion: '<'
  controller: timezoneSelectController

angular
  .module 'BBAdminDashboard'
  .component 'timezoneSelect', timezoneSelectComponent
