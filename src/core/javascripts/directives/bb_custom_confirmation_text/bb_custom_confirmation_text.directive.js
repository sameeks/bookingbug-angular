angular.module('BB.Directives').directive 'bbCustomConfirmationText', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'CustomConfirmationText'