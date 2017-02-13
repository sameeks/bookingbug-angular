describe('bbForm directive', function() {
  let $compile = null;
  let $scope = null;
  let $timeout = null;
  let validatorService = null;

  let element = null;

  beforeEach(function() {
    module('BB');

    inject(function($injector) {
      $compile = $injector.get('$compile');
      $scope = $injector.get('$rootScope');
      $timeout = $injector.get('$timeout');
      return validatorService = $injector.get('ValidatorService');
    });

  });

  it('can submit normal form by hitting input with "submit" type', function() {
    element = angular.element(`\
<form bb-form name="parent"> \
<input type="submit" value="Submit"> \
</form>\
`);

    $compile(element)($scope);
    $scope.$digest();

    let submitInput = element.find('input[type=submit]');
    submitInput.click();

    return expect(element.scope().parent.$submitted)
      .toBe(true);
  });

  it('can submit normal form by hitting button with "submit" type', function() {
    element = angular.element(`\
<form bb-form name="parent"> \
<button type="submit">Submit</button> \
</form>\
`);

    $compile(element)($scope);
    $scope.$digest();

    let submitBtn = element.find('button[type=submit]');
    submitBtn.click();

    return expect(element.scope().parent.$submitted)
      .toBe(true);
  });

  it('can submit ng-form by hitting element with ng-click on it', function() {
    element = angular.element(`\
<ng-form bb-form name="parent" bb-form-route="calendar"> \
<button class="submit" ng-click="submitForm()"></button> \
</ng-form>\
`);

    $compile(element)($scope);
    $scope.$digest();

    let submitBtn = element.find('button.submit');
    submitBtn.click();

    return expect(element.scope().parent.$submitted)
      .toBe(true);
  });


  describe('once submit method is triggered', function() {
    beforeEach(function() {
      element = angular.element(`\
<ng-form bb-form name="parent" bb-form-route="calendar"> \
<ng-form name="child"> \
<ng-form name="inner-child"> \
<button class="submit" ng-click="submitForm()"></button> \
</ng-form> \
</ng-form> \
</ng-form>\
`);

      $compile(element)($scope);
      $scope.$digest();
      element.scope().submitForm();

    });

    it('parent form is submitted', () =>      

      expect(element.scope().parent.$submitted)
        .toBe(true)
    );

    it('child form is submitted', () =>      

      expect(element.scope().parent.child.$submitted)
        .toBe(true)
    );

    return it('inner-child form is submitted', () =>
      
      expect(element.scope().parent.child['inner-child'].$submitted)
        .toBe(true)
    );
  });

  describe('when bb-form is wrapped with bb-page and bb-form-route attribute is present with no value', function() {
    let $bbPageController = null;

    beforeEach(function() {
      element = angular.element(`\
<div bb-page> \
<form bb-form name="parent" bb-form-route> \
<input type="submit" value="Submit"> \
</form> \
</div>\
`);

      $compile(element)($scope);
      $scope.$digest();

      $bbPageController = element.controller('bbPage');
      spyOn($bbPageController.$scope, 'checkReady');
      spyOn($bbPageController.$scope, 'routeReady');

    });

    it('checkReady will be triggered ', function() {
      element.scope().submitForm();

      return expect($bbPageController.$scope.checkReady)
        .toHaveBeenCalled();
    });

    return it('routeReady will be triggered with no argument', function() {
      element.scope().submitForm();

      return expect($bbPageController.$scope.routeReady)
        .toHaveBeenCalledWith();
    });
  });

  describe('when bb-form is wrapped with bb-page and bb-form-route attribute is present with "calendar" value', function() {
    let $bbPageController = null;

    beforeEach(function() {
      element = angular.element(`\
<div bb-page> \
<form bb-form name="parent" bb-form-route="calendar"> \
<input type="submit" value="Submit"> \
</form> \
</div>\
`);

      $compile(element)($scope);
      $scope.$digest();

      $bbPageController = element.controller('bbPage');
      spyOn($bbPageController.$scope, 'checkReady');
      spyOn($bbPageController.$scope, 'routeReady');

    });

    it('checkReady will be triggered ', function() {
      element.scope().submitForm();

      return expect($bbPageController.$scope.checkReady)
        .toHaveBeenCalled();
    });

    return it('routeReady will be triggered with argument', function() {
      element.scope().submitForm();

      return expect($bbPageController.$scope.routeReady)
        .toHaveBeenCalledWith('calendar');
    });
  });

  describe('when bb-form is wrapped with bb-page but bb-form-route attribute is not present', function() {
    let $bbPageController = null;

    beforeEach(function() {
      element = angular.element(`\
<div bb-page> \
<form bb-form name="parent"> \
<input name="foo" type="text" ng-model="foo"> \
<input type="submit" value="Submit"> \
</form> \
</div>\
`);

      $compile(element)($scope);
      $scope.$digest();

      $bbPageController = element.controller('bbPage');
      spyOn($bbPageController.$scope, 'checkReady');
      spyOn($bbPageController.$scope, 'routeReady');

    });

    it('checkReady will be triggered ', function() {
      element.scope().submitForm();

      return expect($bbPageController.$scope.checkReady)
        .toHaveBeenCalled();
    });

    return it('routeReady will be triggered with no argument', function() {
      element.scope().submitForm();

      return expect($bbPageController.$scope.routeReady)
        .toHaveBeenCalledWith();
    });
  });

  return describe('when bb-form is wrapped with bb-page and bb-form-route attribute but form is invalid', function() {
    let $bbPageController = null;

    beforeEach(function() {
      element = angular.element(`\
<div bb-page> \
<form bb-form name="parent" bb-form-route> \
<input name="foo" type="text" ng-model="foo" required> \
<input type="submit" value="Submit"> \
</form> \
</div>\
`);

      $compile(element)($scope);
      $scope.$digest();

      $bbPageController = element.controller('bbPage');
      spyOn($bbPageController.$scope, 'checkReady');
      spyOn($bbPageController.$scope, 'routeReady');

    });

    it('checkReady will be not triggered ', function() {
      element.scope().submitForm();

      return expect($bbPageController.$scope.checkReady)
        .not.toHaveBeenCalled();
    });

    return it('routeReady will be not triggered with no argument', function() {
      element.scope().submitForm();

      return expect($bbPageController.$scope.routeReady)
        .not.toHaveBeenCalledWith();
    });
  });
});