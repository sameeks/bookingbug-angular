angular.module('BBMember.Services').factory("MemberPrePaidBookingService", ($q, BBModel) => {

        return {
            query(member, params) {
                let deferred = $q.defer();
                if (!params) {
                    params = {};
                }
                params.no_cache = true;
                if (!member.$has('pre_paid_bookings')) {
                    deferred.reject("member does not have pre paid bookings");
                } else {
                    member.$get('pre_paid_bookings', params).then(bookings => {
                            let booking;
                            if (angular.isArray(bookings)) {
                                // pre paid bookings embedded in member
                                bookings = (() => {
                                    let result = [];
                                    for (booking of Array.from(bookings)) {
                                        result.push(new BBModel.PrePaidBooking(booking));
                                    }
                                    return result;
                                })();
                                return deferred.resolve(bookings);
                            } else {
                                params.no_cache = false;
                                return bookings.$get('pre_paid_bookings', params).then(bookings => {
                                        bookings = (() => {
                                            let result1 = [];
                                            for (booking of Array.from(bookings)) {
                                                result1.push(new BBModel.PrePaidBooking(booking));
                                            }
                                            return result1;
                                        })();
                                        return deferred.resolve(bookings);
                                    }
                                );
                            }
                        }
                        , err => {
                            return deferred.reject(err);
                        }
                    );
                }
                return deferred.promise;
            }
        };
    }
);
