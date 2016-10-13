angular.module('BBMember.Services').factory "BB.Service.payment_item", ($q, BBModel, UnwrapService) ->
  unwrap: (resource) ->
    UnwrapService.unwrapResource(BBModel.Member.PaymentItem, resource)
