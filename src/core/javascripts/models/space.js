/***
* @ngdoc service
* @name BB.Models:Space
*
* @description
* Representation of an Space Object
*/

angular.module('BB.Models').factory("SpaceModel", ($q, BBModel, BaseModel, SpaceService) =>

  class Space extends BaseModel {

    $query(company) {
      return SpaceService.query(company);
    }
  }
);

