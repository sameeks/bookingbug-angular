'use strict'

angular.module('BB.Controllers').controller 'bbContentController', ($scope) ->
  'ngInject'

  $scope.controller = "public.controllers.bbContentController"
  $scope.initPage = () =>
    $scope.setPageLoaded()
    $scope.setLoadingPage(false)

  return