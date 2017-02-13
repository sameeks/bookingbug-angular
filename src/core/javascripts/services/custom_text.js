angular.module('BB.Services').factory("CustomTextService",  ($q, BBModel) =>

  ({
    BookingText(company, basketItem) {
      let deferred = $q.defer();
      company.$get('booking_text').then(emb => {
        return emb.$get('booking_text').then(details => {
          let msgs = [];
          for (let detail of Array.from(details)) {
            if (detail.message_type === "Booking") {
              for (let name in basketItem.parts_links) {
                let link = basketItem.parts_links[name];
                if (detail.$href('item') === link) {
                  if (msgs.indexOf(detail.message) === -1) {
                    msgs.push(detail.message);
                  }
                }
              }
            }
          }
          return deferred.resolve(msgs);
        }
        );
      }
      , err => {
        return deferred.reject(err);
      }
      );
      return deferred.promise;
    },

    confirmationText(company, total) {
      let deferred = $q.defer();
      company.$get('booking_text').then(emb =>
        emb.$get('booking_text').then(details =>
          total.getMessages(details, "Confirm").then(msgs => deferred.resolve(msgs))
        )
      
      , err => deferred.reject(err));
      return deferred.promise;
    }
  })
);

