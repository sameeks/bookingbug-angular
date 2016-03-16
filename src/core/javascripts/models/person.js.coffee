'use strict';

###**
* @ngdoc service
* @name BB.Models:Person
*
* @description
* Representation of an Person Object
*
* @property {number} id Person id
* @property {string} name Person name
* @property {string} description Person description
* @property {hash} extra Any extra custom business information
* @property {boolean} deleted Verifies if person is deleted or not
* @property {boolean} disabled Verifies if person is disabled or not
* @property {number} order The person order
####

angular.module('BB.Models').factory "PersonModel", ($q, BBModel, BaseModel, PersonService) ->

  class Person extends BaseModel

    ###**
    * @ngdoc method
    * @name $query
    * @methodOf BB.Models:Person
    * @description
    * Static function that loads an array of people from a company object
    *
    * @returns {promise} A returned promise
    ###
    @$query: (company) ->
      PersonService.query(company)

