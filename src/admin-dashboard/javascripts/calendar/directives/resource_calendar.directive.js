angular
  .module('BBAdminDashboard.calendar.directives')
  .directive('bbResourceCalendar', function($compile) {
    'ngInject';

    let link = function(scope, element, attrs) {

      let init = function() {
        scope.$on('UICalendar:EventAfterAllRender', addDatePickerToFCToolbar);
      };

      var addDatePickerToFCToolbar = function() {
        let uiCalElement = angular.element(document.getElementById('uicalendar'));
        let datePicker = uiCalElement.find('bb-calendar-date-picker');
        if (!datePicker.length) {
          let toolbarElement = angular.element(uiCalElement.children()[0]);
          let toolbarLeftElement = angular.element(toolbarElement.children()[0]);
          let datePickerComponent = '<bb-calendar-date-picker on-change-date="vm.updateDateHandler($event)" current-date="vm.currentDate"></bb-calendar-date-picker>';
          let datePickerElement = $compile(datePickerComponent)(scope);
          toolbarLeftElement.append(datePickerElement);
        }
      };

      init();

    };

    return {
      controller: 'bbResourceCalendarController',
      controllerAs: 'vm',
      link,
      templateUrl: 'calendar/resource-calendar.html',
      replace: true,
      scope: {
        labelAssembler: '@',
        blockLabelAssembler: '@',
        externalLabelAssembler: '@',
        model: '=?'
      }
    };});
