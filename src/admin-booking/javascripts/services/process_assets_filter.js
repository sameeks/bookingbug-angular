// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
* @ngdoc service
* @name BBAdminBooking.service:ProcessAssetsFilter
* @description
* Returns array of assets from a comma delimited string
*/
angular.module('BBAdminBooking').factory('ProcessAssetsFilter', function() {
  return function(string){
    let assets = [];

    if ((typeof string === 'undefined') || (string === '')) {
      return assets;
    }

    return angular.forEach(string.split(','), value=> assets.push(parseInt(decodeURIComponent(value))));
  };

  return assets;
});

