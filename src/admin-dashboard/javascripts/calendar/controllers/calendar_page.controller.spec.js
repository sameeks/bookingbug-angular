// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
describe('BBAdminDashboard.calendar.controllers, CalendarPageCtrl', function() {
  let $compile = null;
  let $controller = null;
  let $httpBackend = null;
  let $rootScope = null;
  let $state = null;
  let $log = null;

  let controllerInstance = null;
  let $scope = null;

  let pusherChannelMock = {
    bind() {}
  };

  let companyMock = {
    getPusherChannel(channelName) {
      return pusherChannelMock;
    }
  };

  let bbMockCompanyHasPeople = {
    company: {
      $has(type) {
        if (type === 'people') {
          return true;
        }

        return false;
      }
    }
  };

  let bbMockCompanyHasResources = {
    company: {
      $has(type) {
        if (type === 'resources') {
          return true;
        }

        return false;
      }
    }
  };

  let setup = function() {
    module('BBAdminDashboard');
    module('BB');

    inject(function($injector) {
      $compile = $injector.get('$compile');
      $controller = $injector.get('$controller');
      $httpBackend = $injector.get('$httpBackend');
      $rootScope = $injector.get('$rootScope');
      $scope = $rootScope.$new();
      $state = $injector.get('$state');
      return $log = $injector.get('$log');
    });

    $scope.adminlte = {};
    $scope.company = companyMock;

    spyOn(pusherChannelMock, 'bind');
    spyOn($state, 'go')
    .and.callThrough();

  };

  beforeEach(setup);

  let getControllerInstance = () =>
    $controller(
      'CalendarPageCtrl',{
      '$log': $log,
      '$scope': $scope,
      '$state': $state
    }
    )
  ;

  it('bind proper events on company "bookings" pusher channel', function() {
    controllerInstance = getControllerInstance();

    expect(pusherChannelMock.bind.calls.argsFor(0)[0])
    .toEqual('create');

    expect(pusherChannelMock.bind.calls.argsFor(1)[0])
    .toEqual('update');

    expect(pusherChannelMock.bind.calls.argsFor(2)[0])
    .toEqual('destroy');

  });

  describe('current state is different than calendar', function() {
    beforeEach(function() {
      $state.current.name = 'calendar'; // TODO find better way to set current state
    });

    afterEach(function() {
      expect(pusherChannelMock.bind.calls.count())
      .toEqual(3);
    });

    it('redirects to people', function() {
      $scope.bb = bbMockCompanyHasPeople;
      controllerInstance = getControllerInstance();

      expect($state.go)
      .toHaveBeenCalledWith('calendar.people');
    });

    it('redirects to resources', function() {
      $scope.bb = bbMockCompanyHasResources;
      controllerInstance = getControllerInstance();

      expect($state.go)
      .toHaveBeenCalledWith('calendar.resources');
    });

  });

});