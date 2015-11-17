

###**
* @ngdoc service
* @name BB.Models:User
*
* @description
* Representation of an User Object
###


angular.module('BB.Models').factory "Admin.UserModel", ($q, BBModel, BaseModel) ->

  class User extends BaseModel

