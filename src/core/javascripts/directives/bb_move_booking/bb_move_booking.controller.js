(() => {

    angular
        .module('BB.Controllers')
        .controller('bbMoveBookingController', MoveBooking);

        function MoveBooking($scope, $attrs, LoadingService, PurchaseBookingService, BBModel, WidgetModalService,
            $rootScope, AlertService, $translate, $timeout, CompanyStoreService) {


            let init = () => {
                this.loader = LoadingService.$loader($scope);
            }

            this.initMove = (booking, openInModal) => {
                if(openInModal) {
                    openCalendarModal(booking);
                }
                else if($rootScope.user){
                    return this.updateSingleBooking(booking);
                }
                else {
                    this.checkBookingReadyToMove(booking);
                }

                // call different method when moving multiple bookings which POSTS to PurchaseService
            }

            let openCalendarModal = (booking) => {
                WidgetModalService.open({
                    company_id: booking.company_id,
                    template: 'main_view_booking',
                    total_id: booking.purchase_ref,
                    first_page: 'calendar'
                });
            }

            this.checkBookingReadyToMove = (booking) => {
                this.loader.notLoaded();

                if(PurchaseBookingService.purchaseBookingNotMovable(booking)) {
                    this.loader.setLoaded();
                    AlertService.add('info', { msg: $translate.instant('PUBLIC_BOOKING.ITEM_DETAILS.MOVE_BOOKING_FAIL_ALERT')});

                    $timeout(() => {
                        AlertService.clear();
                    }, 5000);
                }

                else {
                    if(CompanyStoreService.hasMoveReasons) {
                        return $scope.decideNextPage('reschedule_reasons');
                    }

                    else return this.updateSingleBooking(booking);
                }
            }

            this.updateSingleBooking = (booking) => {
                PurchaseBookingService.update(booking).then((purchaseBooking) => {
                    let booking = new BBModel.Purchase.Booking(purchaseBooking);
                    this.loader.setLoaded()

                    // update the $scope purchase to the newly updated purchaseBooking
                    $scope.bb.purchase = PurchaseBookingService.updatePurchaseBookingRef($scope.bb.purchase, booking);
                    resolveMove();
                });
            }

            let resolveMove = () => {
                $rootScope.$broadcast("booking:moved", $scope.bb.purchase);

                // isMemberDashboard property is defined when openCalendarModal method is called from memberBookings controller
                // we dont want to close the modal when on the member or admin dashboard
                if(WidgetModalService.isMemberDashboard || $rootScope.user) {
                    $scope.decideNextPage('confirmation');
                }
                else  {
                    WidgetModalService.close();
                }
            }

            init();
        }
})();

