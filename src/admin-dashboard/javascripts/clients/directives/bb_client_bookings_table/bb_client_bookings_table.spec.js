describe('BBAdminDashboard.clients.controllers bbClientBookingsTableCtrl', function () {
    let $controller = null;
    let $rootScope = null;
    let $scope = null;
    let ClientBookingsCtrl;


    let beforeEachFn = function() {
        module('BB');

        inject(function($injector, $controller) {

            $controller = $injector.get('$controller');
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();

            ClientBookingsCtrl = $controller('bbClientBookingsTableCtrl as $bbClientBookingsTableCtrl', {
                '$scope': $scope
            });
        });


        $scope.$apply();
    };


    beforeEach(beforeEachFn)

    it('stores startDate to scope as current time if not already present', function() {

    });

});

