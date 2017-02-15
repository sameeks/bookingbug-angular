// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBMember.Services').factory("BB.Service.payment_item", ($q, BBModel, UnwrapService) => {

        return {
            unwrap(resource) {
                return UnwrapService.unwrapResource(BBModel.Member.PaymentItem, resource);
            }
        };
    }
);
