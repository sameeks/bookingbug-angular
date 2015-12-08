# v1 of Unit Testing for Bookable Item Model
# Begin test
# Bookable Item Model Unit Testing using mockup data.
# Check if static method @$query returns similar data from public rest api on Bookable Item List end point.
# The company id is 21, app-id is **** and app-key is **** .
describe '@$query', () ->

  beforeEach module ('BB')

  $compile = null
  $rootScope = null
  BBModel = BBModel
  BaseModel = BaseModel
  ItemService = ItemService

  beforeEach (inject ((_$httpBackend_, _$compile_, _$rootScope_, _BBModel_, _BaseModel_, _ItemService_) ->
    httpBackend = httpBackend
    $compile = _$compile_
    $rootScope = _$rootScope_
    BBModel = _BBModel_
    BaseModel = _BaseModel_
    ItemService = _ItemService_
  ))

  it 'Successfully result', () ->
    scope=$rootScope.$new()
    # Use mock data from Item Service.
    # Make an query to rest api end point.
    BookableItemModelMockData =
      name: "-Waiting-"
      ready: true
      item: "Bookable item"
    # Verify if mock data are equals.
    expect(BookableItemModelMockData.name).toBe("-Waiting-")
    expect(BookableItemModelMockData.ready).toBe(true)
    expect(BookableItemModelMockData.item).toBe("Bookable item")
    # console.log("@$query() method from Bookable Item Model")
    # console.log(BookableItemModelMockData)

# v2 of Unit Testing for Bookable Item Model
# Bookable Item Model Unit Testing using mockup data
# This test checks if Item Service return valid values when make a query by company id on service end point.  
app = angular.module('bookableMock', [ 'ngResource' ])

# query for service
app.factory 'ItemService', ($resource) ->
  $resource 'https://dev.bookingbug.com/rest_api/public_api/21/items', { callback: 'JSON_CALLBACK' }, get: method: 'JSONP'

app.controller 'BookableItem', ($scope, ItemService) ->
  $scope.query = ->
    $scope.query = ItemService.get(q: $scope.searchByCompanyID)

# Begin test  
describe 'Checks if service endpoint is valid or not', ->
  scope = scope
  ctrl = ctrl
  httpBackend = httpBackend
  
  beforeEach module('bookableMock')
  beforeEach inject(($controller, $rootScope, ItemService, $httpBackend) ->
    httpBackend = $httpBackend
    scope = $rootScope.$new()
    ctrl = $controller('BookableItem', $scope: scope, ItemService: ItemService)
    # Create Mockup Data for service end point
    mockData = 
      name: "-Waiting-"
      ready: true
      item: "Bookable item"
      
    url = 'https://dev.bookingbug.com/rest_api/public_api/21/items?' + 'callback=JSON_CALLBACK&q=21'
    httpBackend.whenJSONP(url).respond mockData
  )
  
  it 'Successfully result', ->
    # Search bookable item by company ID
    scope.searchByCompanyID = 21
    scope.query()
    httpBackend.flush()
    # Checks all parameters in order to validate test
    expect(scope.query.name).toBe "-Waiting-"
    expect(scope.query.ready).toBe true
    expect(scope.query.item).toBe "Bookable item"
    # Print all Service parameters
    # console.log(scope.query)