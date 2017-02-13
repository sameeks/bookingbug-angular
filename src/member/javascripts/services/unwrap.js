angular.module('BBMember.Services').factory("BB.Service.payment_item", ($q, BBModel, UnwrapService) =>
  ({
    unwrap(resource) {
      return UnwrapService.unwrapResource(BBModel.Member.PaymentItem, resource);
    }
  })
);
