'use strict'

angular.module('BBAdminBooking').component 'bbAdminResourcesDropdown', {
  bindings: {
    formCtrl: '<'
  }
  controller: 'BBAdminResourcesDropdownCtrl'
  controllerAs: '$bbAdminResourcesDropdownCtrl'
  require: {
    $bbCtrl: '^^bbAdminBooking'
  }
  templateUrl: 'admin-booking/admin_resources_dropdown.html'
}

BBAdminResourcesDropdownCtrl = (BBAssets, $rootScope, $scope) ->
  'ngInject'

  @pickedResource = null
  @resources = []
  @_resourceChangedUnSubscribe = null

  @$onInit = () =>
    @changeResource = changeResource

    BBAssets.getAssets(@$bbCtrl.$scope.bb.company).then setLoadedResources
    @_resourceChangedUnSubscribe = $scope.$on 'bbAdminResourcesDropdown:resourceChanged', resourceChangedListener
    return

  @$onDestroy = () =>
    @_resourceChangedUnSubscribe()
    return

  resourceChangedListener = (event) =>
    if not @pickedResource?
      delete @$bbCtrl.$scope.bb.current_item.resource
      delete @$bbCtrl.$scope.bb.current_item.person
      return

    type = @pickedResource.split('_')[1]
    for resource, resourceKey in  @resources
      if resource.identifier == @pickedResource
        if type == 'p'
          @$bbCtrl.$scope.bb.current_item.person = resource
          @pickedResource = resource
          delete @$bbCtrl.$scope.bb.current_item.resource
        else if type == 'r'
          @$bbCtrl.$scope.bb.current_item.resource = resource
          @pickedResource = resource
          delete @$bbCtrl.$scope.bb.current_item.person
        break

    return

  ###*
  * @param {Array} resources
  ###
  setLoadedResources = (resources) =>
    @resources = resources
    setCurrentResource()
    return

  setCurrentResource = () =>
    if @$bbCtrl.$scope.bb.current_item.person? and @$bbCtrl.$scope.bb.current_item.person.id?
      @pickedResource = @$bbCtrl.$scope.bb.current_item.person
      @pickedResource.identifier = @$bbCtrl.$scope.bb.current_item.person.id + '_p'
    else if @$bbCtrl.$scope.bb.current_item.resource? and @$bbCtrl.$scope.bb.current_item.resource.id?
      @pickedResource = @$bbCtrl.$scope.bb.current_item.resource
      @pickedResource.identifier = @$bbCtrl.$scope.bb.current_item.resource.id + '_r'

    return

  changeResource = () =>
    $rootScope.$broadcast 'bbAdminResourcesDropdown:resourceChanged'
    return

  return

angular.module('BBAdminBooking').controller 'BBAdminResourcesDropdownCtrl', BBAdminResourcesDropdownCtrl
