'use strict'


###**
* @ngdoc service
* @name BB.Models:Image
*
* @description
* Representation of an Image Object
*
* @property {array} iamges An array with event images
####


angular.module('BB.Models').factory "ImageModel", ($q, $filter, BBModel, BaseModel) ->

  class Image extends BaseModel

    constructor: (data) ->
      super(data)

