angular.module('BBAdmin.Services').factory('AdminBookingService', ($q, $window, halClient, BookingCollections, BBModel, UriTemplate) => {

        return {
            query(prms) {

                let company;
                if (prms.slot) {
                    prms.slot_id = prms.slot.id;
                }
                if (prms.date) {
                    prms.start_date = prms.date;
                    prms.end_date = prms.date;
                }
                if (prms.company) {
                    ({company} = prms);
                    delete prms.company;
                    prms.company_id = company.id;
                }

                if (prms.per_page == null) {
                    prms.per_page = 1024;
                }
                if (prms.include_cancelled == null) {
                    prms.include_cancelled = false;
                }

                let deferred = $q.defer();
                let existing = BookingCollections.find(prms);
                if (existing && !prms.skip_cache) {
                    deferred.resolve(existing);
                } else if (company) {
                    if (prms.skip_cache) {
                        if (existing) {
                            BookingCollections.delete(existing);
                        }
                        company.$flush('bookings', prms);
                    }
                    company.$get('bookings', prms).then(collection =>
                            collection.$get('bookings').then(function (bookings) {
                                    let models = (Array.from(bookings).map((b) => new BBModel.Admin.Booking(b)));
                                    let spaces = new $window.Collection.Booking(collection, models, prms);
                                    BookingCollections.add(spaces);
                                    return deferred.resolve(spaces);
                                }
                                , err => deferred.reject(err))

                        , err => deferred.reject(err));
                } else {
                    let url = "";
                    if (prms.url) {
                        ({url} = prms);
                    }
                    let href = url + "/api/v1/admin/{company_id}/bookings{?slot_id,start_date,end_date,service_id,resource_id,person_id,page,per_page,include_cancelled,embed,client_id}";
                    let uri = new UriTemplate(href).fillFromObject(prms || {});

                    halClient.$get(uri, {}).then(found => {
                            return found.$get('bookings').then(items => {
                                    let sitems = [];
                                    for (let item of Array.from(items)) {
                                        sitems.push(new BBModel.Admin.Booking(item));
                                    }
                                    let spaces = new $window.Collection.Booking(found, sitems, prms);
                                    BookingCollections.add(spaces);
                                    return deferred.resolve(spaces);
                                }
                            );
                        }
                        , err => {
                            return deferred.reject(err);
                        }
                    );
                }

                return deferred.promise;
            },

            getBooking(prms) {
                let deferred = $q.defer();
                if (prms.company && !prms.company_id) {
                    prms.company_id = prms.company.id;
                }

                let url = "";
                if (prms.url) {
                    ({url} = prms);
                }
                let href = url + "/api/v1/admin/{company_id}/bookings/{id}{?embed}";
                let uri = new UriTemplate(href).fillFromObject(prms || {});
                halClient.$get(uri, {no_cache: true}).then(function (item) {
                        let booking = new BBModel.Admin.Booking(item);
                        BookingCollections.checkItems(booking);
                        return deferred.resolve(booking);
                    }
                    , err => {
                        return deferred.reject(err);
                    }
                );
                return deferred.promise;
            },

            cancelBooking(prms, booking) {
                let deferred = $q.defer();
                let href = "/api/v1/admin/{company_id}/bookings/{id}?notify={notify}";
                if (prms.id == null) {
                    prms.id = booking.id;
                }

                let {notify} = prms;
                if (notify == null) {
                    notify = true;
                }

                let uri = new UriTemplate(href).fillFromObject(prms || {});
                halClient.$del(uri, {notify}).then(function (item) {
                        booking = new BBModel.Admin.Booking(item);
                        BookingCollections.checkItems(booking);
                        return deferred.resolve(booking);
                    }
                    , err => {
                        return deferred.reject(err);
                    }
                );
                return deferred.promise;
            },

            updateBooking(prms, booking) {
                let deferred = $q.defer();
                let href = "/api/v1/admin/{company_id}/bookings/{id}";
                if (prms.id == null) {
                    prms.id = booking.id;
                }

                let uri = new UriTemplate(href).fillFromObject(prms || {});
                halClient.$put(uri, {}, prms).then(function (item) {
                        booking = new BBModel.Admin.Booking(item);
                        BookingCollections.checkItems(booking);
                        return deferred.resolve(booking);
                    }
                    , err => {
                        return deferred.reject(err);
                    }
                );
                return deferred.promise;
            },

            blockTimeForPerson(prms, person) {
                let deferred = $q.defer();
                let href = "/api/v1/admin/{company_id}/people/{person_id}/block";
                if (prms.person_id == null) {
                    prms.person_id = person.id;
                }
                prms.booking = true;
                let uri = new UriTemplate(href).fillFromObject(prms || {});
                halClient.$put(uri, {}, prms).then(function (item) {
                        let booking = new BBModel.Admin.Booking(item);
                        BookingCollections.checkItems(booking);
                        return deferred.resolve(booking);
                    }
                    , err => {
                        return deferred.reject(err);
                    }
                );
                return deferred.promise;
            },

            addStatusToBooking(prms, booking, status) {
                let deferred = $q.defer();
                let href = "/api/v1/admin/{company_id}/bookings/{booking_id}/multi_status";
                if (prms.booking_id == null) {
                    prms.booking_id = booking.id;
                }
                let uri = new UriTemplate(href).fillFromObject(prms || {});
                halClient.$put(uri, {}, {status}).then(function (item) {
                        booking = new BBModel.Admin.Booking(item);
                        BookingCollections.checkItems(booking);
                        return deferred.resolve(booking);
                    }
                    , err => {
                        return deferred.reject(err);
                    }
                );
                return deferred.promise;
            },

            addPrivateNoteToBooking(prms, booking, note) {
                let noteParam;
                let deferred = $q.defer();
                let href = "/api/v1/admin/{company_id}/bookings/{booking_id}/private_notes";
                if (prms.booking_id == null) {
                    prms.booking_id = booking.id;
                }

                if (note.note != null) {
                    noteParam = note.note;
                }
                if (noteParam == null) {
                    noteParam = note;
                }

                let uri = new UriTemplate(href).fillFromObject(prms || {});
                halClient.$put(uri, {}, {note: noteParam}).then(function (item) {
                        booking = new BBModel.Admin.Booking(item);
                        BookingCollections.checkItems(booking);
                        return deferred.resolve(booking);
                    }
                    , err => {
                        return deferred.reject(err);
                    }
                );
                return deferred.promise;
            },

            updatePrivateNoteForBooking(prms, booking, note) {
                let deferred = $q.defer();
                let href = "/api/v1/admin/{company_id}/bookings/{booking_id}/private_notes/{id}";
                if (prms.booking_id == null) {
                    prms.booking_id = booking.id;
                }
                if (prms.id == null) {
                    prms.id = note.id;
                }

                let uri = new UriTemplate(href).fillFromObject(prms || {});
                halClient.$put(uri, {}, {note: note.note}).then(function (item) {
                        booking = new BBModel.Admin.Booking(item);
                        BookingCollections.checkItems(booking);
                        return deferred.resolve(booking);
                    }
                    , err => {
                        return deferred.reject(err);
                    }
                );
                return deferred.promise;
            },

            deletePrivateNoteFromBooking(prms, booking, note) {
                let deferred = $q.defer();
                let href = "/api/v1/admin/{company_id}/bookings/{booking_id}/private_notes/{id}";
                if (prms.booking_id == null) {
                    prms.booking_id = booking.id;
                }
                if (prms.id == null) {
                    prms.id = note.id;
                }

                let uri = new UriTemplate(href).fillFromObject(prms || {});
                halClient.$del(uri, {}).then(function (item) {
                        booking = new BBModel.Admin.Booking(item);
                        BookingCollections.checkItems(booking);
                        return deferred.resolve(booking);
                    }
                    , err => {
                        return deferred.reject(err);
                    }
                );
                return deferred.promise;
            }
        };
    }
);
