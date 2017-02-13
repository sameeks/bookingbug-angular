describe('BBMember, MemberBookings controller', function() {
  let $rootScope = null;
  let $scope = null;

  let setup = function() {
    module('BBMember');

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
