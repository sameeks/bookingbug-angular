// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
* @ngdoc service
* @name BB.Models:Resource
*
* @description
* Representation of an Resource Object
*
* @property {integer} id The resources id
* @property {string} name Name of the resource
* @property {string} description Description of the resource
* @property {string} type Type of the resource
* @property {hash} extra Any extra custom business information
* @property {boolean} deleted Verify if resources is deleted or not
* @property {boolean} disabled Verify if resources is disabled or not
*///


angular.module('BB.Models').factory("ResourceModel", ($q, BBModel, BaseModel, ResourceService) =>

  class Resource extends BaseModel {


    /***
    * @ngdoc method
    * @name $query
    * @methodOf BB.Models:Resource
    * @description
    * Static function that loads an array of resources from a company object
    *
    * @returns {promise} A returned promise
    */
    static $query(company) {
      return ResourceService.query(company);
    }
  }
);

