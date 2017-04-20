describe('BBAdminDashboard.check-in.controllers bbAddWalkinCtrl', function () {
    let $controller = null;
    let $rootScope = null;
    let $scope = null;
    let AdminBookingPopup, bbAddWalkinCtrl;

    let beforeEachFn = function() {
        module('BBAdminDashboard.check-in.controllers');
        module('BBAdminBooking');

        inject(function($injector, $controller, _AdminBookingPopup_) {
            AdminBookingPopup = _AdminBookingPopup_;

            $controller = $injector.get('$controller');
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();

            bbAddWalkinCtrl = $controller('bbAddWalkinCtrl', {
                '$scope': $scope,
                'AdminBookingPopup': AdminBookingPopup
            });

            $scope.bb = {
                company: {
                    id: 37000
                }
            }
        });


        $rootScope.$digest();
    };

    it('calls AdminBookingPopup open function passing in config object', () => {
        spyOn(AdminBookingPopup, 'open');
        bbAddWalkinCtrl.walkIn();
        expect(AdminBookingPopup.open).toHaveBeenCalledWith(jasmine.any(Object));
    });


    beforeEach(beforeEachFn)

});

