describe('BBAdminDashboard.clients.controllers bbClientBookingsTableCtrl', function () {
    let $rootScope = null;
    let $scope = null;


    let beforeEachFn = function () {
        module('BB');

        inject(($injector, $controller) =>  {
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
        });


        $scope.$apply();
    };


    beforeEach(beforeEachFn);

});

