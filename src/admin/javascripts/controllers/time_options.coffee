'use strict'

angular.module('BBAdmin.Controllers').controller 'TimeOptions', (
  $scope, $location, $rootScope, BBModel) ->

  BBModel.Admin.Resource.$query({company: $scope.bb.company}).then (resources) ->
    $scope.resources = resources

  BBModel.Admin.Person.$query({company: $scope.bb.company}).then (people) ->
    $scope.people = people

  $scope.block = ->
    if $scope.person
      params =
        start_time: $scope.start_time
        end_time: $scope.end_time
      BBModel.Admin.Person.$block($scope.bb.company, $scope.person, params)
    $scope.ok()

