describe('BB Purchase', function() {
    let $controller = null;
    let $rootScope = null;
    let $scope = null;

    let PurchaseController;

    let reasonsMock = [
        {reason1: 'reason1'},
        {reason2: 'reason2'}
    ];

    let bookingMock = {
        id: 1
    }

    let beforeEachFn = function() {
        module('BB')

        inject(function($injector) {
            $rootScope = $injector.get('$rootScope');
            $controller = $injector.get('$controller');
            $scope = $rootScope.$new();

            PurchaseController = $controller('Purchase', {
                '$scope': $scope
            });
        });

        spyOn($scope, '$on').and.callThrough();

        $scope.$apply();
    }

    beforeEach(beforeEachFn);

    it('Should store cancel reasons on scope', function() {
        $rootScope.$broadcast('booking:cancelReasonsLoaded', reasonsMock);
        expect($scope.cancelReasons).toEqual(reasonsMock);
    });

    it('Should store move reasons on scope', function() {
        $rootScope.$broadcast('booking:moveReasonsLoaded', reasonsMock);
        expect($scope.moveReasons).toEqual(reasonsMock);
    });

    it('Should store purchase on scope', function() {
        $rootScope.$broadcast('booking:moved', bookingMock);
        expect($scope.purchase).toEqual(bookingMock);
    });
});
