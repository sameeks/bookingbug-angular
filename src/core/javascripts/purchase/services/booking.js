(() => {

    angular
        .module('BB.Services')
        .factory("PurchaseBookingService", PurchaseBookingService);

    function PurchaseBookingService($q, halClient, BBModel) {

        return {
            update(booking) {
                let deferred = $q.defer();
                let data = booking.getPostData();
                booking.srcBooking.$put('self', {}, data).then(booking => {
                        return deferred.resolve(new BBModel.Purchase.Booking(booking));
                    }
                    , err => {
                        return deferred.reject(err, new BBModel.Purchase.Booking(booking));
                    }
                );
                return deferred.promise;
            },

            addSurveyAnswersToBooking(booking) {
                let deferred = $q.defer();
                let data = booking.getPostData();
                data.notify = false;
                data.notify_admin = false;
                booking.$put('self', {}, data).then(booking => {
                        return deferred.resolve(new BBModel.Purchase.Booking(booking));
                    }
                    , err => {
                        return deferred.reject(err, new BBModel.Purchase.Booking(booking));
                    }
                );
                return deferred.promise;
            },

            updatePurchaseBookingData(purchase, booking) {
                let i, len, oldb, ref;

                if (purchase) {
                    ref = purchase.bookings;
                    for (i = 0, len = ref.length; i < len; i++) {
                        oldb = ref[i];
                        if (oldb.id === booking.id) {
                            booking.moved = true;
                            purchase.bookings[i] = booking;
                        }
                    }

                    return purchase;
                }
                else {
                    return;
                }
            },

            purchaseBookingNotMovable(booking) {
                let timeNow = moment()
                return (booking.min_cancellation_time.isBefore(timeNow) || booking.time.datetime.isSame(booking.srcBooking.datetime))
            }
        };
    }
})();

