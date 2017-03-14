(() => {

    angular
        .module('BB.Controllers')
        .controller('bbMoveBookingController', MoveBooking);

        function MoveBooking($scope, $attrs, LoadingService, PurchaseBookingService, BBModel, WidgetModalService, $rootScope) {
            this.init = () => {
                this.loader = LoadingService.$loader($scope);
                this.options = $scope.$eval($attrs.bbMoveBooking) || {};
            }

            this.initMove = function(booking, openInModal) {
                if(openInModal) {
                    openCalendarModal(booking);
                } else {
                    // check if booking is ready to be moved (datetime has been changed) - add method to basketItem model?
                    // update purchaseBooking
                    updateSingleBooking(booking);
                }

                // call different method when moving multiple bookings which POSTS to PurchaseService
            }

            let openCalendarModal = function(booking) {
                WidgetModalService.open({
                    company_id: booking.company_id,
                    template: 'main_view_booking',
                    total_id: booking.purchase_ref,
                    first_page: 'calendar'
                });
            }

            let resolveMove = function() {
                $rootScope.$broadcast("booking:moved", $scope.bb.purchase);
                WidgetModalService.close()
            }

            let updateSingleBooking = (booking) => {
                this.loader.notLoaded();
                PurchaseBookingService.update(booking).then((purchaseBooking) => {
                    let booking = new BBModel.Purchase.Booking(purchaseBooking);
                    this.loader.setLoaded()

                    let i, len, oldb, ref;

                    if ($scope.bb.purchase) {
                        ref = $scope.bb.purchase.bookings;
                        for (i = 0, len = ref.length; i < len; i++) {
                            oldb = ref[i];
                            if (oldb.id === booking.id) {
                                $scope.bb.purchase.bookings[i] = booking;
                            }
                        }
                    }
                    resolveMove();
                });
            }

            this.init();
        }
})();

