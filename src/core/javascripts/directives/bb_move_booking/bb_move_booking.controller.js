(() => {

    angular
        .module('BB.Controllers')
        .controller('bbMoveBookingController', MoveBooking);

        function MoveBooking($scope, $attrs, LoadingService, PurchaseBookingService, BBModel, WidgetModalService,
            $rootScope, AlertService, $translate, $timeout, CompanyStoreService) {

            this.loader = LoadingService.$loader($scope);

            this.initMove = (booking) => {
                if(WidgetModalService.isStudioModal) {
                    // if we are on the studio dashboard than we can move bookings without checking they are movable
                    this.updateSingleBooking(booking);
                }
                else if(WidgetModalService.isMemberModal) {
                    this.checkBookingReadyToMove(booking);
                }
                else {
                    // open modal as were are on public purchase template
                    openCalendarModal(booking);
                }
            }

            this.checkBookingReadyToMove = (booking) => {
                if(booking.canMove()) {
                    return $scope.decideNextPage('basket_summary');
                }
                else {
                    this.loader.setLoaded();
                    AlertService.add('info', { msg: $translate.instant('PUBLIC_BOOKING.ITEM_DETAILS.MOVE_BOOKING_FAIL_ALERT')});
                }
            }

            this.updateSingleBooking = (booking) => {
                this.loader.notLoaded();
                PurchaseBookingService.update(booking).then((purchaseBooking) => {
                    let booking = new BBModel.Purchase.Booking(purchaseBooking);
                    this.loader.setLoaded()
                    $scope.bb.purchase = booking.updatePurchaseBookingData($scope.bb.purchase);
                    resolveMove(booking);
                });
            }


            let openCalendarModal = (booking) => {
                WidgetModalService.open({
                    company_id: booking.company_id,
                    template: 'main_view_booking',
                    total_id: booking.purchase_ref,
                    first_page: 'calendar'
                });
            }


            let resolveMove = (booking) => {
                $rootScope.$broadcast("booking:moved", $scope.bb.purchase);
                // isMemberModal property is defined when openCalendarModal method is called from memberBookings controller
                // we dont want to close the modal when on the member or admin dashboard
                if(WidgetModalService.isMemberModal || WidgetModalService.isStudioModal) {
                    $scope.decideNextPage('confirmation');
                }
                else  {
                    WidgetModalService.close();
                    AlertService.add('info', { msg: $translate.instant('PUBLIC_BOOKING.ITEM_DETAILS.MOVE_BOOKING_SUCCESS_ALERT', {datetime: booking.datetime})});
                }
            }
        }
})();

