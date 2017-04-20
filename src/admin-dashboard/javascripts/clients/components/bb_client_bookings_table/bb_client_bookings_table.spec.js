describe('BBAdminDashboard.clients.controllers bbClientBookingsTableCtrl', function () {
    let $controller = null;
    let $rootScope = null;
    let $scope = null;


    let beforeEachFn = function() {
        module('BB');

        inject(function($injector, $controller) {

            $controller = $injector.get('$controller');
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
        });


        $scope.$apply();
    };


    beforeEach(beforeEachFn)

});

