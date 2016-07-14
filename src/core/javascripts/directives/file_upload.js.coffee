'use strict'

###**
* @ngdoc directive
* @name BB.Directives:bbFileUpload
* @restrict AE
* @scope true
*
* @description
* File upload
*
* @example
  <example>
  <div bb-file-upload class="form-group"></div>
  </example>
###

angular.module('BB.Directives').directive 'bbFileUpload', () ->
  restrict: 'AE'
  replace: false
  scope : true
  controller : 'FileUpload',
  templateUrl: 'file_upload.html'
  link : (scope, element, attrs) ->

angular.module('BB.Controllers').controller 'FileUpload', ($scope, Upload) ->

  $scope.controller = "public.controllers.FileUpload"

  ###**
  * @ngdoc method
  * @name uploadFile
  * @methodOf BB.Directives:bbItemDetails
  * @description
  * Upload a file
  * For more information see https://github.com/danialfarid/ng-file-upload
  * To use this module:
  *
  * @param {object} item basket item
  * @param {object} file uploaded file
  * @param {number} existing attachment id
  * @param {array} errFiles errors array
  ###
  $scope.uploadFile = (item, file, errFiles, existing) ->
    if file
      $scope.myFile = file
      if existing  then att_id = existing else att_id = null

      method = "POST"
      method = "PUT" if att_id
      url = item.$href('add_attachment')

      $scope.errFile = errFiles and errFiles[0]

      onSuccess = (response) ->
        file.result = response.data
        item.attachment = response.data
        item.attachment_id = response.data.id
        file.progress = 100

      onError = (response) ->
        $scope.showError = true
        file.progress = 100

      onProgress = (evt) ->
        file.progress = Math.min(100, parseInt(99.0 * evt.loaded / evt.total))

      file.upload = Upload.upload(
        url: url,
        method: method
        data: {attachment_id: att_id},
        file: file
      )
      file.upload.then onSuccess, onError, onProgress

