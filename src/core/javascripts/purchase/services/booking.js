angular.module('BB.Services').factory("PurchaseBookingService", ($q, halClient, BBModel) =>

  ({
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
    }
  })
);

