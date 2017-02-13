'use strict'

angular.module('BBAdminServices').directive 'scheduleTable', (
  BBModel, $log, ModalForm) ->

  controller = ($scope) ->

    $scope.fields = ['id', 'name', 'mobile']

    $scope.getSchedules = () ->
      params =
        company: $scope.company
      BBModel.Admin.Schedule.query(params).then (schedules) ->
        $scope.schedules = schedules

    $scope.newSchedule = () ->
      ModalForm.new
        company: $scope.company
        title: 'New Schedule'
        new_rel: 'new_schedule'
        post_rel: 'schedules'
        size: 'lg'
        success: (schedule) ->
          $scope.schedules.push(schedule)

    $scope.delete = (schedule) ->
      schedule.$del('self').then () ->
        $scope.schedules = _.reject $scope.schedules, schedule
      , (err) ->
        $log.error "Failed to delete schedule"

    $scope.edit = (schedule) ->
      ModalForm.edit
        model: schedule
        title: 'Edit Schedule'
        size: 'lg'

  link = (scope, element, attrs) ->
    if scope.company
      scope.getSchedules()
    else
      BBModel.Admin.Company.query(attrs).then (company) ->
        scope.company = company
        scope.getSchedules()

  {
    controller: controller
    link: link
    templateUrl: 'schedule_table_main.html'
  }

