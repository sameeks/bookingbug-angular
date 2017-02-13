'use strict'

angular.module('BBAdminSettings').directive 'adminTable', ($log,
  ModalForm, BBModel) ->

  controller = ($scope) ->

    $scope.getAdministrators = () ->
      params =
        company: $scope.company
      BBModel.Admin.Administrator.$query(params).then (administrators) ->
        $scope.admin_models = administrators
        $scope.administrators = _.map administrators, (administrator) ->
          _.pick administrator, 'id', 'name', 'email', 'role'

    $scope.newAdministrator = () ->
      ModalForm.new
        company: $scope.company
        title: 'New Administrator'
        new_rel: 'new_administrator'
        post_rel: 'administrators'
        success: (administrator) ->
          $scope.administrators.push(administrator)

    $scope.edit = (id) ->
      admin = _.find $scope.admin_models, (p) -> p.id == id
      ModalForm.edit
        model: admin
        title: 'Edit Administrator'

  link = (scope, element, attrs) ->
    if scope.company
      scope.getAdministrators()
    else
      BBModel.Admin.Company.$query(attrs).then (company) ->
        scope.company = company
        scope.getAdministrators()

  {
    controller: controller
    link: link
    templateUrl: 'admin-table/admin_table_main.html'
  }

