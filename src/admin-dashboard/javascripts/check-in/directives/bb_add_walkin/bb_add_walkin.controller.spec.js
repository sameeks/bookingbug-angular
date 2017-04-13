describe('BBAdminDashboard.check-in.directives bbAddWalkinCtrl', function () {
    let $controller = null;
    let $rootScope = null;
    let $scope = null;
    let ctrl = null;
    let AdminBookingPopup;

    let beforeEachFn = function() {
        module('BBAdminDashboard.check-in.directives');
        module('BBAdminBooking');

        inject(function($injector, $controller, _AdminBookingPopup_) {
            AdminBookingPopup = _AdminBookingPopup_;

            $controller = $injector.get('$controller');
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();

            ctrl = $controller('bbAddWalkinCtrl', {
                '$scope': $scope,
                'AdminBookingPopup': AdminBookingPopup
            });

            $scope.bb = {
                company: {
                    id: 37000
                }
            }

            $scope.configMock = {
                item_defaults: {
                    pick_first_time: true,
                    merge_people: true,
                    merge_resources: true,
                    date: moment().format('YYYY-MM-DD')
                },
                on_conflict: "cancel()",
                company_id: $scope.bb.company.id
            }
        });


        $rootScope.$digest();
    };

    it('calls AdminBookingPopup open function passing in config object', () => {
        spyOn(AdminBookingPopup, 'open');
        $scope.walkIn();
        expect(AdminBookingPopup.open).toHaveBeenCalledWith($scope.configMock);
    });


    beforeEach(beforeEachFn)

});

