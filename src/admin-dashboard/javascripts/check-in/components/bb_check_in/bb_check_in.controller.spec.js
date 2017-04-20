describe('BBAdminDashboard.check-in.directives bbCheckInController', function () {
    let $controller = null;
    let $rootScope = null;
    let $scope = null;
    let ctrl = null;
    let BBModel;
    let deferred;
    let $q = null;

    let beforeEachFn = function() {
        module('BBAdminDashboard.check-in.directives');
        module('BBAdminBooking');
        module('BB.Models');

        inject(function($injector, $controller, _BBModel_) {
            BBModel = _BBModel_

            $controller = $injector.get('$controller');
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
            $q = $injector.get('$q');
            deferred = $q.defer();

            ctrl = $controller('bbCheckInController', {
                '$scope': $scope,
                'BBModel': BBModel
            });
        });


        $rootScope.$digest();
    };


    beforeEach(beforeEachFn)

});

