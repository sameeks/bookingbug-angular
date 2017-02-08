'use strict'

describe 'bbForm directive', ->
  $compile = null
  $scope = null
  $timeout = null
  validatorService = null

  element = null

  beforeEach ->
    module 'BB'

    inject ($injector) ->
      $compile = $injector.get('$compile')
      $scope = $injector.get('$rootScope')
      $timeout = $injector.get('$timeout')
      validatorService = $injector.get('ValidatorService')

    return

  it 'can submit normal form by hitting input with "submit" type', ->
    element = angular.element('
<form bb-form name="parent">
      <input type="submit" value="Submit">
</form>
')

    $compile(element)($scope)
    $scope.$digest()

    submitInput = element.find('input[type=submit]')
    submitInput.click()

    expect element.scope().parent.$submitted
      .toBe true

  it 'can submit normal form by hitting button with "submit" type', ->
    element = angular.element('
<form bb-form name="parent">
      <button type="submit">Submit</button>
</form>
')

    $compile(element)($scope)
    $scope.$digest()

    submitBtn = element.find('button[type=submit]')
    submitBtn.click()

    expect element.scope().parent.$submitted
      .toBe true

  it 'can submit ng-form by hitting element with ng-click on it', ->
    element = angular.element('
<ng-form bb-form name="parent" bb-form-route="calendar">
  <button class="submit" ng-click="submitForm()"></button>
</ng-form>
  ')

    $compile(element)($scope)
    $scope.$digest()

    submitBtn = element.find('button.submit')
    submitBtn.click()

    expect element.scope().parent.$submitted
      .toBe true


  describe 'once submit method is triggered', ->
    beforeEach ->
      element = angular.element('
<ng-form bb-form name="parent" bb-form-route="calendar">
  <ng-form name="child">
    <ng-form name="inner-child">
      <button class="submit" ng-click="submitForm()"></button>
    </ng-form>
  </ng-form>
</ng-form>
')

      $compile(element)($scope)
      $scope.$digest()
      element.scope().submitForm()

      return

    it 'parent form is submitted', ->      

      expect element.scope().parent.$submitted
        .toBe true

    it 'child form is submitted', ->      

      expect element.scope().parent.child.$submitted
        .toBe true

    it 'inner-child form is submitted', ->
      
      expect element.scope().parent.child['inner-child'].$submitted
        .toBe true

  describe 'when bb-form is wrapped with bb-page and bb-form-route attribute is present with no value', ->
    $bbPageController = null

    beforeEach ->
      element = angular.element('
<div bb-page>
<form bb-form name="parent" bb-form-route>
      <input type="submit" value="Submit">
</form>
</div>
')

      $compile(element)($scope)
      $scope.$digest()

      $bbPageController = element.controller('bbPage')
      spyOn $bbPageController.$scope, 'checkReady'
      spyOn $bbPageController.$scope, 'routeReady'

      return

    it 'checkReady will be triggered ', ->
      element.scope().submitForm()

      expect $bbPageController.$scope.checkReady
        .toHaveBeenCalled()

    it 'routeReady will be triggered with no argument', ->
      element.scope().submitForm()

      expect $bbPageController.$scope.routeReady
        .toHaveBeenCalledWith()

  describe 'when bb-form is wrapped with bb-page and bb-form-route attribute is present with "calendar" value', ->
    $bbPageController = null

    beforeEach ->
      element = angular.element('
<div bb-page>
<form bb-form name="parent" bb-form-route="calendar">
      <input type="submit" value="Submit">
</form>
</div>
')

      $compile(element)($scope)
      $scope.$digest()

      $bbPageController = element.controller('bbPage')
      spyOn $bbPageController.$scope, 'checkReady'
      spyOn $bbPageController.$scope, 'routeReady'

      return

    it 'checkReady will be triggered ', ->
      element.scope().submitForm()

      expect $bbPageController.$scope.checkReady
        .toHaveBeenCalled()

    it 'routeReady will be triggered with argument', ->
      element.scope().submitForm()

      expect $bbPageController.$scope.routeReady
        .toHaveBeenCalledWith('calendar')

  describe 'when bb-form is wrapped with bb-page but bb-form-route attribute is not present', ->
    $bbPageController = null

    beforeEach ->
      element = angular.element('
<div bb-page>
<form bb-form name="parent">
      <input name="foo" type="text" ng-model="foo">
      <input type="submit" value="Submit">
</form>
</div>
')

      $compile(element)($scope)
      $scope.$digest()

      $bbPageController = element.controller('bbPage')
      spyOn $bbPageController.$scope, 'checkReady'
      spyOn $bbPageController.$scope, 'routeReady'

      return

    it 'checkReady will be triggered ', ->
      element.scope().submitForm()

      expect $bbPageController.$scope.checkReady
        .toHaveBeenCalled()

    it 'routeReady will be not triggered with no argument', ->
      element.scope().submitForm()

      expect $bbPageController.$scope.routeReady
        .toHaveBeenCalledWith()

  describe 'when bb-form is wrapped with bb-page and bb-form-route attribute but form is invalid', ->
    $bbPageController = null

    beforeEach ->
      element = angular.element('
<div bb-page>
<form bb-form name="parent" bb-form-route>
      <input name="foo" type="text" ng-model="foo" required>
      <input type="submit" value="Submit">
</form>
</div>
')

      $compile(element)($scope)
      $scope.$digest()

      $bbPageController = element.controller('bbPage')
      spyOn $bbPageController.$scope, 'checkReady'
      spyOn $bbPageController.$scope, 'routeReady'

      return

    it 'checkReady will be not triggered ', ->
      element.scope().submitForm()

      expect $bbPageController.$scope.checkReady
        .not.toHaveBeenCalled()

    it 'routeReady will be not triggered with no argument', ->
      element.scope().submitForm()

      expect $bbPageController.$scope.routeReady
        .not.toHaveBeenCalledWith()