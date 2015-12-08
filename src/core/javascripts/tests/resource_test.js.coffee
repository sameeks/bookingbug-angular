# v1 of Unit Testing of Resource Model
# Begin test
# Resource Model Unit Testing using mockup data.
# Check if static method @$query returns similar data from public rest api on Resource List end point.
# The company id is 21, app-id is **** and app-key is **** .
describe '@$query', () ->

  beforeEach module('BB')

  $compile = null
  $rootScope = null
  BBModel = BBModel
  BaseModel = BaseModel
  ResourceService = ResourceService

  beforeEach (inject((_$httpBackend_, _$compile_, _$rootScope_, _BBModel_, _BaseModel_, _ResourceService_) ->
    httpBackend = httpBackend
    $compile = _$compile_
    $rootScope = _$rootScope_
    BBModel = _BBModel_
    BaseModel = _BaseModel_
    ResourceService = _ResourceService_
  ))

  it 'Successfully result', () ->
    scope = $rootScope.$new()
    # Use mock data from Resource Service.
    # Make an query to rest api end point.
    ResourceModelMockData = 
      id: 16
      name: "My Resource"
      type: "resource"
      deleted: false
      disabled: false
    # Verify if mock data are equals.
    expect(ResourceModelMockData.id).toBe(16)
    expect(ResourceModelMockData.name).toBe("My Resource")
    expect(ResourceModelMockData.type).toBe("resource")
    expect(ResourceModelMockData.deleted).toBe(false)
    expect(ResourceModelMockData.disabled).toBe(false)
    # console.log("@$query() method from ResourceModel")
    # console.log(ResourceModelMockData)

# v2 of Unit Testing for Resource Model
# Resource Model Unit Testing using mockup data
# This test checks if Resource Service return valid values when make a query by company id on service end point.  

app = angular.module('resourceMock', [ 'ngResource' ])

# query for service
app.factory 'ResourceService', ($resource) ->
  $resource 'https://dev.bookingbug.com/rest_api/public_api/21/resources', { callback: 'JSON_CALLBACK' }, get: method: 'JSONP'

app.controller 'ResourceList', ($scope, ResourceService) ->
  $scope.query = ->
    $scope.query = ResourceService.get(q: $scope.searchByCompanyID)
   
# Begin test  
describe 'Checks if service endpoint is valid or not', ->
  scope = scope
  ctrl = ctrl
  httpBackend = httpBackend
  
  beforeEach module('resourceMock')
  beforeEach inject(($controller, $rootScope, ResourceService, $httpBackend) ->
    httpBackend = $httpBackend
    scope = $rootScope.$new()
    ctrl = $controller('ResourceList', $scope: scope, ResourceService: ResourceService)
    # Create Mockup Data for service end point
    mockData = 
      id: 16
      name: "My Resource"
      type: "resource"
      deleted: false
      disabled: false
      
    url = 'https://dev.bookingbug.com/rest_api/public_api/21/resources?' + 'callback=JSON_CALLBACK&q=21'
    httpBackend.whenJSONP(url).respond mockData
  )
  
  it 'Successfully result', ->
    # Search resource by company ID
    scope.searchByCompanyID = 21
    scope.query()
    httpBackend.flush()
    # Checks all parameters in order to validate test
    expect(scope.query.id).toBe 16
    expect(scope.query.name).toBe  "My Resource"
    expect(scope.query.type).toBe "resource"
    expect(scope.query.deleted).toBe false
    expect(scope.query.disabled).toBe false
    # Print all Service parameters
    # console.log(scope.query)