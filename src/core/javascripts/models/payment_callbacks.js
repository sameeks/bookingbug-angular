// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
 * @ngdoc service
 * @name BB.Models:PaymentCallbacks
 *
 * @description
 * Representation of an PaymentCallbacks Object
 *///


angular.module('BB.Models').factory("PaymentCallbacksModel", ($q, $filter,
                                                              BBModel, BaseModel) =>

    class PaymentCallbacks extends BaseModel {

        constructor(data) {
            super(data);
        }
    }
);
