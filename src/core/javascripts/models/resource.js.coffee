'use strict';


###**
* @ngdoc service
* @name BB.Models:Resource
*
* @description
* Representation of an Resource Object
*
* @property {integer} total_entries The total entries
* @property {array} resources An array with resources elements
* @property {integer} id The resources id
* @property {string} name Name of resources
* @propertu {string} type Type of resources
* @property {boolean} deleted Verify if resources is deleted or not
* @property {boolean} disabled Verify if resources is disabled or not
####


angular.module('BB.Models').factory "ResourceModel", ($q, BBModel, BaseModel, ResourceService) ->

  class Resource extends BaseModel


    @$query: (company) ->
      ResourceService.query(company)

