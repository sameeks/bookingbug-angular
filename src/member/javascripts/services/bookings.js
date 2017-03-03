angular.module('BBMember.Services').factory("MemberBookingService", ($q, SpaceCollections, $rootScope, MemberService, BBModel) => {

        return {
            query(member, params) {
                let deferred = $q.defer();
                if (!params) {
                    params = {};
                }
                params.no_cache = true;
                if (!member.$has('bookings')) {
                    deferred.reject("member does not have bookings");
                } else {
                    member.$get('bookings', params).then(bookings => {
                            let booking;
                            if (angular.isArray(bookings)) {
                                // bookings embedded in member
                                bookings = ((() => {
                                    let result = [];
                                    for (booking of Array.from(bookings)) {
                                        result.push(new BBModel.Member.Booking(booking));
                                    }
                                    return result;
                                })());
                                return deferred.resolve(bookings);
                            } else {
                                params.no_cache = false;
                                return bookings.$get('bookings', params).then(bookings => {
                                        bookings = ((() => {
                                            let result1 = [];
                                            for (booking of Array.from(bookings)) {
                                                result1.push(new BBModel.Member.Booking(booking));
                                            }
                                            return result1;
                                        })());
                                        return deferred.resolve(bookings);
                                    }
                                    , err => deferred.reject(err));
                            }
                        }
                        , err => deferred.reject(err));
                }
                return deferred.promise;
            },

            cancel(member, booking) {
                let deferred = $q.defer();
                booking.$del('self').then(b => {
                        booking.deleted = true;
                        b = new BBModel.Member.Booking(b);
                        BBModel.Member.Member.$refresh(member).then(member => {
                                return member;
                            }
                            , err => {
                            });
                        return deferred.resolve(b);
                    }
                    , err => {
                        return deferred.reject(err);
                    }
                );
                return deferred.promise;
            },

            update(booking) {
                let deferred = $q.defer();
                booking.$put('self', {}, booking).then(booking => {
                        let book = new BBModel.Member.Booking(booking);
                        SpaceCollections.checkItems(book);
                        return deferred.resolve(book);
                    }
                    , err => {
                        _.each(booking, function (value, key, booking) {
                            if ((key !== 'data') && (key !== 'self')) {
                                return booking[key] = booking.data[key];
                            }
                        });
                        return deferred.reject(err, new BBModel.Member.Booking(booking));
                    }
                );
                return deferred.promise;
            },

            flush(member, params) {
                if (member.$has('bookings')) {
                    return member.$flush('bookings', params);
                }
            }
        };
    }
);
