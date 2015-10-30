'use strict';

###**
* @ngdoc service
* @name BB.Models:Space
*
* @description
* Representation of an Space Object
###

angular.module('BB.Models').factory "SpaceModel", ($q, BBModel, BaseModel) ->

  class Space extends BaseModel

   