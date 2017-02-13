describe 'bbAdminResourcesDropdown component', ->
  $componentController = null
  $rootScope = null
  $scope = null
  $q = null

  BBAssets = null
  assetsDeferred = null

  assetPerson = {id: 1, type: 'person', identifier: '1_p'}
  assetResource = {id: 2, type: 'resource', identifier: '2_r'}

  assets = [assetPerson, assetResource]

  ctrl = null
  ctrlDependencies = null

  beforeEach () ->
    module 'BB'
    module 'BBAdminBooking'

    inject ($injector) ->
      $componentController = $injector.get('$componentController')
      $rootScope = $injector.get('$rootScope')
      $scope = $rootScope.$new()

      $q = $injector.get('$q')
      BBAssets = $injector.get('BBAssets')

    assetsDeferred = $q.defer()
    spyOn(BBAssets, 'getAssets').and.returnValue(assetsDeferred.promise)
    assetsDeferred.resolve(assets)

    ctrlDependencies = {
      'BBAssets': BBAssets,
      '$rootScope': $rootScope,
      '$scope': $scope
    }

  createBindings = (asset) ->
    bindings = {
      '$bbCtrl': {
        $scope: {
          bb: {
            current_item: asset
          }
        }
      }
    }
    return bindings

  describe 'can change dropdown value from "resource" asset to "person" asset', ->
    beforeEach ->
      ctrlBindings = createBindings({resource: {id: 2}})
      ctrl = $componentController('bbAdminResourcesDropdown', ctrlDependencies, ctrlBindings)
      ctrl.$onInit()
      $rootScope.$apply()

    it 'resource is defined before change, id = 2', ->
      expect(ctrl.$bbCtrl.$scope.bb.current_item.resource.id).toBe(2)

    it 'resource is undefined after change', ->
      ctrl.pickedResource = assetPerson.identifier
      ctrl.changeResource()
      expect(ctrl.$bbCtrl.$scope.bb.current_item.resource).toBeUndefined()

    it 'person is undefined before change', ->
      expect(ctrl.$bbCtrl.$scope.bb.current_item.person).toBeUndefined()

    it 'person is defined after change, id = 1', ->
      ctrl.pickedResource = assetPerson.identifier
      ctrl.changeResource()
      expect(ctrl.$bbCtrl.$scope.bb.current_item.person.id).toBe(1)

  describe 'can change dropdown value from "person" asset to "resource" asset', ->
    beforeEach ->
      ctrlBindings = createBindings({person: {id: 1}})
      ctrl = $componentController('bbAdminResourcesDropdown', ctrlDependencies, ctrlBindings)
      ctrl.$onInit()
      $rootScope.$apply()

    it 'person is defined before change, id = 1', ->
      expect(ctrl.$bbCtrl.$scope.bb.current_item.person.id).toBe(1)

    it 'person is undefined after change', ->
      ctrl.pickedResource = assetResource.identifier
      ctrl.changeResource()
      expect(ctrl.$bbCtrl.$scope.bb.current_item.person).toBeUndefined()

    it 'resource is undefined before change', ->
      expect(ctrl.$bbCtrl.$scope.bb.current_item.resource).toBeUndefined()

    it 'resource is defined after change, id = 2', ->
      ctrl.pickedResource = assetResource.identifier
      ctrl.changeResource()
      expect(ctrl.$bbCtrl.$scope.bb.current_item.resource.id).toBe(2)

  describe 'can undo dropdown selection', ->
    beforeEach ->
      ctrlBindings = createBindings({person: {id: 1}})
      ctrl = $componentController('bbAdminResourcesDropdown', ctrlDependencies, ctrlBindings)
      ctrl.$onInit()
      $rootScope.$apply()

    it 'person is defined before change, id = 1', ->
      expect(ctrl.$bbCtrl.$scope.bb.current_item.person.id).toBe(1)

    it 'resource is undefined before change', ->
      expect(ctrl.$bbCtrl.$scope.bb.current_item.resource).toBeUndefined()

    it 'person is undefined after change', ->
      ctrl.pickedResource = null
      ctrl.changeResource()
      expect(ctrl.$bbCtrl.$scope.bb.current_item.person).toBeUndefined()

    it 'resource is undefined after change', ->
      ctrl.pickedResource = undefined
      ctrl.changeResource()
      expect(ctrl.$bbCtrl.$scope.bb.current_item.resource).toBeUndefined()

  it 'adds bbAdminResourcesDropdown:resourceChanged listener when initialising scope', ->
    ctrlBindings = createBindings({resource: {id: 2}})
    ctrl = $componentController('bbAdminResourcesDropdown', ctrlDependencies, ctrlBindings)
    ctrl.$onInit()
    $rootScope.$apply()
    expect($scope.$$listenerCount['bbAdminResourcesDropdown:resourceChanged']).toBeDefined()

  it 'removes bbAdminResourcesDropdown:resourceChanged listener when destroying scope', ->
    ctrlBindings = createBindings({resource: {id: 2}})
    ctrl = $componentController('bbAdminResourcesDropdown', ctrlDependencies, ctrlBindings)
    ctrl.$onInit()
    ctrl.$onDestroy()
    $rootScope.$apply()
    expect($scope.$$listenerCount['bbAdminResourcesDropdown:resourceChanged']).toBeUndefined()