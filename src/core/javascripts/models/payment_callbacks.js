'use strict'


###**
* @ngdoc service
* @name BB.Models:PaymentCallbacks
*
* @description
* Representation of an PaymentCallbacks Object
####


angular.module('BB.Models').factory "PaymentCallbacksModel", ($q, $filter,
  BBModel, BaseModel) ->

  class PaymentCallbacks extends BaseModel

    constructor: (data) ->
      super(data)