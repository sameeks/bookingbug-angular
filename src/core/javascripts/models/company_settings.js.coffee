'use strict'


###**
* @ngdoc service
* @name BB.Models:CompanySettings
*
* @description
* Representation of an CompanySettings Object
####



angular.module('BB.Models').factory "CompanySettingsModel", ($q, BBModel, BaseModel) ->

  class CompanySettings extends BaseModel

