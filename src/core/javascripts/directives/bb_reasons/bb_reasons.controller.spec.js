describe('BB bbReasonsController', function () {
    let $controller = null;
    let $rootScope = null;
    let $scope = null;
    let ReasonsController;

    let companyMock = {
        id: 37280,
        reasons: {
            reason1: 'reason1',
            reason2: 'reason2'
        }
    }


    let beforeEachFn = function() {
        module('BB');

        inject(function($injector, $controller) {

            $controller = $injector.get('$controller');
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();

            ReasonsController = $controller('bbReasonsController as $bbReasonsCtrl', {
                '$scope': $scope
            });
        });

        spyOn(ReasonsController, 'init').and.callThrough();
        spyOn(ReasonsController, 'initReasons').and.callThrough();
        spyOn($rootScope, '$broadcast').and.callThrough();

        $scope.bb = {
            company_id: companyMock.id
        }

        ReasonsController.init();

        $scope.$apply();
    };


    beforeEach(beforeEachFn)

    it('initialises reasons controller with a numeric company id', function() {
        expect(ReasonsController.initReasons).toHaveBeenCalledWith(jasmine.any(Number));
    });

    it('broadcasts cancel reasons on $rootScope', function() {
        spyOn(ReasonsController, 'setCancelReasons').and.callThrough();
        ReasonsController.setCancelReasons()

        expect($rootScope.$broadcast).toHaveBeenCalledWith('booking:cancelReasonsLoaded', jasmine.any(Array));
    });

    it('broadcasts move reasons on $rootScope', function() {
        spyOn(ReasonsController, 'setMoveReasons').and.callThrough();
        ReasonsController.setMoveReasons()

        expect($rootScope.$broadcast).toHaveBeenCalledWith('booking:moveReasonsLoaded', jasmine.any(Array));
    });
});


