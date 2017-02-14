// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Services').factory("PurchaseService", ($q, halClient, BBModel, $window, UriTemplate) =>

    ({
        query(params) {
            let defer = $q.defer();
            let uri = params.url_root + "/api/v1/purchases/" + params.purchase_id;
            halClient.$get(uri, params).then(function (purchase) {
                    purchase = new BBModel.Purchase.Total(purchase);
                    return defer.resolve(purchase);
                }
                , err => defer.reject(err));
            return defer.promise;
        },


        bookingRefQuery(params) {
            let defer = $q.defer();
            let uri = new UriTemplate(params.url_root + "/api/v1/purchases/booking_ref/{booking_ref}{?raw}").fillFromObject(params);
            halClient.$get(uri, params).then(function (purchase) {
                    purchase = new BBModel.Purchase.Total(purchase);
                    return defer.resolve(purchase);
                }
                , err => defer.reject(err));
            return defer.promise;
        },


        update(params) {
            let booking;
            let defer = $q.defer();

            if (!params.purchase) {
                defer.reject("No purchase present");
                return defer.promise;
            }

            // only send email on the last item we're moving - otherwise we'll send an email on each item!
            let data = {};

            if (params.bookings) {
                let bdata = [];
                for (booking of Array.from(params.bookings)) {
                    bdata.push(booking.getPostData());
                }
                data.bookings = bdata;
            }

            if (params.move_reason) {
                for (booking of Array.from(data.bookings)) {
                    booking.move_reason = params.move_reason;
                }
            }

            params.purchase.$put('self', {}, data).then(purchase => {
                    purchase = new BBModel.Purchase.Total(purchase);
                    return defer.resolve(purchase);
                }
                , err => {
                    return defer.reject(err);
                }
            );
            return defer.promise;
        },


        bookWaitlistItem(params) {

            let defer = $q.defer();

            if (!params.purchase && !params.purchase_id) {
                defer.reject("No purchase or purchase_id present");
            }

            let data = {};
            //data.booking = params.booking.getPostData() if params.booking
            data.booking_id = params.booking.id;

            if (params.purchase) {

                params.purchase.$put('book_waitlist_item', {}, data).then(purchase => {
                        purchase = new BBModel.Purchase.Total(purchase);
                        return defer.resolve(purchase);
                    }
                    , err => defer.reject(err));

            } else if (params.purchase_id && params.url_root) {

                let uri = params.url_root + "/api/v1/purchases/" + params.purchase_id + '/book_waitlist_item';

                halClient.$put(uri, {}, data).then(function (purchase) {
                        purchase = new BBModel.Purchase.Total(purchase);
                        return defer.resolve(purchase);
                    }
                    , err => defer.reject(err));
            }

            return defer.promise;
        },


        deleteAll(purchase) {

            let defer = $q.defer();

            if (!purchase) {
                defer.reject("No purchase present");
                return defer.promise;
            }

            purchase.$del('self').then(function (purchase) {
                    purchase = new BBModel.Purchase.Total(purchase);
                    return defer.resolve(purchase);
                }
                , err => {
                    return defer.reject(err);
                }
            );

            return defer.promise;
        },


        deleteItem(params) {
            let defer = $q.defer();
            let uri = params.api_url + "/api/v1/purchases/" + params.long_id + "/purchase_item/" + params.purchase_item_id;
            halClient.$del(uri, {}).then(function (purchase) {
                    purchase = new BBModel.Purchase.Total(purchase);
                    return defer.resolve(purchase);
                }
                , err => defer.reject(err));
            return defer.promise;
        }
    })
);

