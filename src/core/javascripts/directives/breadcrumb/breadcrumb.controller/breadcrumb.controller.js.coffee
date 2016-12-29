'use strict'


angular.module('BB.Controllers').controller 'Breadcrumbs', ($scope) ->
  loadStep        = $scope.loadStep
  $scope.steps    = $scope.bb.steps
  $scope.allSteps = $scope.bb.allSteps

  # stop users from clicking back once the form is completed ###
  $scope.loadStep = (number) ->
    if !lastStep() && !currentStep(number) && !atDisablePoint()
      loadStep number


  lastStep = () ->
    return $scope.bb.current_step is $scope.bb.allSteps.length


  currentStep = (step) ->
    return step is $scope.bb.current_step


  atDisablePoint = () ->
    return false if !angular.isDefined($scope.bb.disableGoingBackAtStep)
    return $scope.bb.current_step >= $scope.bb.disableGoingBackAtStep


  $scope.isDisabledStep = (step) ->
    if lastStep() or currentStep(step.number) or !step.passed or atDisablePoint()
      return true
    else
      return false
