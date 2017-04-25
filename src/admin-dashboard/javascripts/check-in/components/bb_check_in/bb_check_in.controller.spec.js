describe('BBAdminDashboard.check-in.directives bbCheckInController', function () {
    let $rootScope = null;

    let beforeEachFn = function () {
        module('BBAdminDashboard.check-in.directives');
        module('BBAdminBooking');
        module('BB.Models');

        inject(($injector, $controller) => {

            $controller = $injector.get('$controller');
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
        });
    };


    beforeEach(beforeEachFn);

});

