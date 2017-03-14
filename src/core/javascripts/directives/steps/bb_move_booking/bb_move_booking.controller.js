(() => {

    angular
        .module('BB.Controllers')
        .controller('bbMoveBookingController', MoveBooking);

        function MoveBooking($scope, $attrs, LoadingService, PurchaseBookingService, BBModel) {
            this.init = function() {
                this.loader = LoadingService.$loader($scope);
                this.options = $scope.$eval($attrs.bbMoveBooking) || {};
            }

            this.initMove = function(booking) {
                // check if booking is ready to be moved (datetime has been changed) - add method to basketItem model?
                // update purchaseBooking
                this.updateSingleBooking(booking);

                // call different method when moving multiple bookings which POSTS to PurchaseService
            }

            this.updateSingleBooking = (booking) => {
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

                    $scope.decideNextPage('purchase');
                });
            }

            this.init();
        }

})();

