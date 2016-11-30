'use strict'

BBContentController = ($scope) ->
  'ngInject'

  $scope.controller = "public.controllers.bbContentController"
  $scope.initPage = () =>
    $scope.setPageLoaded()
    $scope.setLoadingPage(false)

  return

angular.module('BB.Controllers').controller 'bbContentController', BBContentController