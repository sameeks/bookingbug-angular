'use strict'

angular.module('BB.Directives').directive 'calendarAdmin', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'calendarAdminCtrl'


angular.module('BB.Controllers').controller 'calendarAdminCtrl', ($scope, $element, $controller, $attrs, $modal) ->
  $scope.adult_count    = 0
  $scope.show_child_qty = false
  $scope.show_price     = false

  angular.extend(this, $controller('TimeList',
    {$scope: $scope,
    $attrs: $attrs,
    $element: $element}
    )
  )

  $scope.week_view = true
  $scope.name_switch = "switch to week view"
  $scope.switchWeekView = () ->
    if $scope.week_view
      $scope.week_view = false
      $scope.name_switch = "switch to day view"
    else
      $scope.week_view = true
      $scope.name_switch = "switch to week view"

  $scope.popupBooking = () ->
    modalInstance = $modal.open {
      template: admin_calender_confirmation,
      controller: ModalInstanceCtrl,
      scope: $scope,
      backdrop: true
    }

  admin_calender_confirmation =
  '
  <div class="cal-modal-header">
    <h4 class="cal-modal-h-text">Book Anyway !</h4>
  </div>
  <div class="cal-modal-body row">
    <div class="col-md-12">
      <div class="col-md-4 pull-right">
        <button class="btn btn-danger btn-block" type="button" ng-click="bookAnyway()">Book Anyway!</button><br>
        <button class="btn btn-primary btn-block" type="button" ng-click="cancel()">Cancel</button>
      </div>

      <div class="widget-wrapper col-md-8">
        <ul>
            <li class="bb-confirmation-summary-item" ng-show="bb.current_item.company">
              <div class="bb-summary-label">
                <i class="fa fa-map-marker pull-left"></i>
              </div>
              <div class="bb-summary-value"><span>{{bb.current_item.company.name}}</span>
              </div>
            </li>
            <li class="bb-confirmation-summary-item" ng-show="bb.current_item.resource">
              <div class="bb-summary-label">
                <i class="fa fa-user pull-left"></i>
              </div>
              <div class="bb-summary-value"><span>{{bb.current_item.resource.name}}</span>
              </div>
            </li>
            <li class="bb-confirmation-summary-item" ng-show="bb.current_item.date">
              <div class="bb-summary-label">
                <i class="fa fa-calendar pull-left"></i>
              </div>
              <div class="bb-summary-value"><span>{{bb.current_item.date.date | datetime: "dddd MMMM Do":false}}</span>
              </div>
            </li>
            <li class="bb-confirmation-summary-item" ng-show="bb.current_item.time">
              <div class="bb-summary-label">
                <i class="fa fa-clock-o pull-right"></i>
              </div>
              <div class="bb-summary-value">
                <span>{{bb.current_item.start_datetime() | datetime: "h[:]mma":false }}</span>
              </div>
            </li>
            <li class="bb-confirmation-summary-item" ng-show="bb.current_item.duration">
              <div class="bb-summary-label">
                <i class="fa fa-clock-o pull-left"></i>
              </div>
              <div class="bb-summary-value">
                <span>{{bb.current_item.duration | time_period}}</span>
              </div>
            </li>
            <li class="bb-confirmation-summary-item" ng-show="bb.current_item.price">
              <div class="bb-summary-label">
                Price:
              </div>
              <div class="bb-summary-value">
                <span>{{bb.current_item.price | currency}}</span>
              </div>
            </li>
        </ul>
      </div>

    </div>
  </div>
  '

  ModalInstanceCtrl = ($scope,  $rootScope, $modalInstance, BBModel) ->
    $scope.controller = "ModalInstanceCtrl"
    $scope.confirmDelete = () ->
      $modalInstance.close(purchase)

    $scope.cancel = ->
      $modalInstance.dismiss "cancel"

    $scope.bookAnyway = ->
      $scope.new_timeslot = new BBModel.TimeSlot({time: $scope.current_item.defaults.time, avail: 1})
      $scope.selectSlot($scope.new_timeslot)
      console.log $scope.new_timeslot
      $scope.cancel()
