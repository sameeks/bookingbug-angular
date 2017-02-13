angular.module('BB.Controllers').controller('FileUpload', ($scope, Upload) =>

  /***
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
  */
  $scope.uploadFile = function(item, file, err_files, existing) {
    $scope.err_file = err_files && err_files[0];
    $scope.show_error = false;
    $scope.file_type_error = false;
    $scope.my_file = file;
    let accepted_files = $scope.accept.replace(/\'/g,'').split(',');
    let file_is_valid = file && ((0 <= accepted_files.indexOf(file.type)) || (0 <= file.type.indexOf('image')));


    if (file_is_valid) {
      let att_id;
      if (existing) {  att_id = existing; } else { att_id = null; }

      let method = "POST";
      if (att_id) { method = "PUT"; }
      let url = item.$href('add_attachment');

      let onSuccess = function(response) {
        file.result = response.data;
        item.attachment = response.data;
        item.attachment_id = response.data.id;
        return file.progress = 100;
      };

      let onError = function(response) {
        $scope.show_error = true;
        return file.progress = 100;
      };

      let onProgress = evt => file.progress = Math.min(100, parseInt((99.0 * evt.loaded) / evt.total));

      Upload.rename(file, file.name.replace(/[^\x00-\x7F]/g, ''));

      file.upload = Upload.upload({
        url,
        method,
        data: {attachment_id: att_id},
        file
      });

      return file.upload.then(onSuccess, onError, onProgress);

    } else if (file_is_valid === false) {
      return $scope.file_type_error = true;
    }
  }
);
