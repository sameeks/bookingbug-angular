describe('BBAdminServices, personTable directive', function() {
  let $rootScope = null;
  let $scope = null;

  let setup = function() {
    module('BBAdminBooking');
    module('BBAdminServices');

    inject(function($injector) {
      $rootScope = $injector.get('$rootScope');
      $scope = $rootScope.$new();
    });

  };

  beforeEach(setup);

  it('dummy test', () =>
    expect(true)
    .toBe(true)
  );

});
