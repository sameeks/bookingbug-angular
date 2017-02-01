'use strict'
    
calendarDatePickerController = () ->
  'ngInject'
  
  ctrl = @
  
  ctrl.openDatePicker = ($event) ->
    $event.preventDefault()
    $event.stopPropagation()
    ctrl.datePickerOpened = true     
  
  ctrl.datePickerUpdated = () ->
    if _.isDate(ctrl.currentDate)
      ctrl.onChangeDate({
        $event: { date: ctrl.currentDate }
      })
  
  return

calendarDatePickerComponent =
  templateUrl: 'bb_calendar_date_picker.html'
  bindings:
    onChangeDate: '&'
    currentDate: '<'
  controller: calendarDatePickerController
    
angular
  .module 'BBAdminDashboard.calendar.directives'
  .component 'bbCalendarDatePicker', calendarDatePickerComponent   
