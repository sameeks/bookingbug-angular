(() => {

    angular
        .module('BB.Controllers')
        .controller('bbMoveBookingController', MoveBooking);

        function MoveBooking($scope, $attrs, LoadingService, PurchaseBookingService, BBModel, WidgetModalService, $rootScope, AlertService, $translate) {
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

                // isMemberDashboard property is defined when openCalendarModal method is called from memberBookings controller
                WidgetModalService.bookings = $scope.bb.purchase.bookings;

                // we dont want to close the modal when on the member or admin dashboard
                if(WidgetModalService.isMemberDashboard || $rootScope.user) {
                    $scope.decideNextPage('purchase');
                }
                else  {
                    WidgetModalService.close();
                }
            }


            let updateSingleBooking = (booking) => {
                this.loader.notLoaded();
                PurchaseBookingService.update(booking).then((purchaseBooking) => {
                    let booking = new BBModel.Purchase.Booking(purchaseBooking);
                    this.loader.setLoaded()

                    // update the $scope purchase to the newly updated purchaseBooking
                    $scope.bb.purchase = PurchaseBookingService.updatePurchaseBookingRef($scope.bb.purchase, booking);
                    resolveMove();
                });
            }

            this.init();
        }
})();

