###
* @ngdoc service
* @name BBAdminBooking.service:ProcessAssetsFilter
* @description
* Returns array of assets from a comma delimited string
###
angular.module('BBAdminBooking').factory 'ProcessAssetsFilter', () ->
  return (string)->
    assets = []

    if typeof string == 'undefined' or string == ''
      return assets

    angular.forEach(string.split(','), (value)->
        assets.push parseInt(decodeURIComponent(value))
    )

  return assets

