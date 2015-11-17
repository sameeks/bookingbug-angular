'use strict'


###**
* @ngdoc service
* @name BB.Models:AdminClientQueue
*
* @description
* Representation of an Client Queue Object
####


angular.module('BB.Models').factory "Admin.ClientQueueModel", ($q, BBModel, BaseModel) ->

  class Admin_ClientQueue extends BaseModel