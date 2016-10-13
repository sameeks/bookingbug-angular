'use strict'

angular.module('BBAdminDashboard.check-in.directives').directive 'bbAddWalkin', () ->
  restrict: 'AE'
  replace: true
  scope : true
  link : (scope, element, attrs) ->
    return
  controller : ($scope, AdminBookingPopup, $timeout) ->

    $scope.walkIn = () ->

      AdminBookingPopup.open
        item_defaults:
          pick_first_time: true
          merge_people: true
          merge_resources: true
          date: moment().format('YYYY-MM-DD')
        on_conflict: "cancel()"
        company_id: $scope.bb.company.id

