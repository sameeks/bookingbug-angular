'use strict';

###**
* @ngdoc service
* @name BB.Models:Space
*
* @description
* Representation of an Space Object
###

angular.module('BB.Models').factory "SpaceModel", ($q, BBModel, BaseModel, SpaceService) ->

  class Space extends BaseModel

    ###**
    * @ngdoc method
    * @name $query
    * @methodOf BB.Models:Space
    * @description
    * Static function that loads an array of space from a company object.
    *
    * @returns {promise} A returned promise
    ###
    @$query: (company) ->
      SpaceService.query(company)
