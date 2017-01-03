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
    <div
      bb-file-upload
      item="item"
      max-size="100KB"
      pretty-accept="images, .pdf, .doc/docx"
      accept="'application/pdf,application/msword,image/*'">
    </div>
  </example>
###

angular.module('BB.Directives').directive 'bbFileUpload', () ->
  restrict: 'A'
  replace: false
  scope: {
    accept: '@',
    prettyAccept: '@',
    maxSize: '@',
    item: '='
  }
  controller : 'FileUpload',
  templateUrl: 'file_upload.html'
