'use strict'

angular.module('BBAdminServices').directive 'personTable', ($log, ModalForm,
  BBModel) ->

  controller = ($scope) ->

    $scope.fields = ['id', 'name', 'mobile']

    $scope.getPeople = () ->
      BBModel.Admin.Person.$query(company: $scope.company).then (people) ->
        $scope.people = people

    $scope.newPerson = () ->
      ModalForm.new
        company: $scope.company
        title: 'New Person'
        new_rel: 'new_person'
        post_rel: 'people'
        success: (person) ->
          $scope.people.push(person)

    $scope.delete = (person) ->
      person.$del('self').then () ->
        $scope.people = _.reject $scope.people, person
      , (err) ->
        $log.error "Failed to delete person"

    $scope.edit = (person) ->
      ModalForm.edit
        model: person
        title: 'Edit Person'

    $scope.schedule = (person) ->
      person.$get('schedule').then (schedule) ->
        ModalForm.edit
          model: schedule
          title: 'Edit Schedule'

  link = (scope, element, attrs) ->
    if scope.company
      scope.getPeople()
    else
      BBModel.Admin.Company.$query(attrs).then (company) ->
        scope.company = company
        scope.getPeople()

  {
    controller: controller
    link: link
    templateUrl: 'person_table_main.html'
  }

