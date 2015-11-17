'use strict'


###**
* @ngdoc service
* @name BB.Models:AdminLogin
*
* @description
* Representation of an Login Object
*
* @property {string} email The admin email address
* @property {string} auth_token Admin authentication token
* @property {integer} company_id The id of admin company
* @property {string} company_name Company name
###


angular.module('BB.Models').factory "Admin.LoginModel", ($q, BBModel, BaseModel) ->

  class Admin_Login extends BaseModel

    constructor: (data) ->
      super(data)
