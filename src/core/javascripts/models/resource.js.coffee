'use strict';

###**
* @ngdoc service
* @name BB.Models:Resource
*
* @description
* Representation of an Resource Object
*
* @property {number} id Resource id
* @property {string} name Resource name
* @property {string} description  Resource description
* @property {string} type Resource type
* @property {hash} extra Any extra custom business information
* @property {boolean} deleted Verify if resources is deleted or not
* @property {boolean} disabled Verify if resources is disabled or not
####

angular.module('BB.Models').factory "ResourceModel", ($q, BBModel, BaseModel, ResourceService) ->

  class Resource extends BaseModel

    ###**
    * @ngdoc method
    * @name $query
    * @methodOf BB.Models:Resource
    * @description
    * Static function that loads an array of resources from a company object.
    *
    * @param {object} company company parameter
    *
    * @returns {promise} A returned promise
    ###
    @$query: (company) ->
      ResourceService.query(company)

