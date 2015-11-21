'use strict';


###**
* @ngdoc service
* @name BB.Models:Person
*
* @description
* Representation of an Person Object
*
* @property {integer} id Person id
* @property {string} name Person name
* @property {boolean} deleted Verify if person is deleted or not
* @property {boolean} disabled Verify if person is disabled or not
* @property {integer} order The person order
####


angular.module('BB.Models').factory "PersonModel", ($q, BBModel, BaseModel, PersonService) ->

  class Person extends BaseModel



    @$query: (company) ->
      PersonService.query(company)

