# v1 of Unit testing for Address Model
# Begin test
# Address Model Unit Testing using mockup data.
# Check if static method @$query returns similar data from public rest api on Address List end point.
# The company id is 21, app-id is **** and app-key is **** .
describe '@$query', () ->

  beforeEach module('BB')

  httpBackend = httpBackend
  $compile = null
  $rootScope = null
  BBModel = BBModel
  BaseModel = BaseModel
  AddressListService = AddressListService

  beforeEach (inject ((_$httpBackend_, _$compile_, _$rootScope_, _BBModel_, _BaseModel_, _AddressListService_) ->
    httpBackend = httpBackend
    $compile = _$compile_
    $rootScope = _$rootScope_
    BBModel = _BBModel_
    BaseModel = _BaseModel_
    AddressListService = _AddressListService_
  ))

  it 'Successfully result', () ->
    scope = $rootScope.$new()
    # Use mock data from Address List Service.
    # Make an query to rest api end point.
    AddressModelMockData =
      address1: "1"
      address2: "2"
      address3: ""
      address4: "3"
      address5: "4"
      postcode: "5"
      country: "United Kingdom"
    # Verify if mock data are equals.
    expect(AddressModelMockData.address1).toBe("1")
    expect(AddressModelMockData.address2).toBe("2")
    expect(AddressModelMockData.address3).toBe("")
    expect(AddressModelMockData.address4).toBe("3")
    expect(AddressModelMockData.address5).toBe("4")
    expect(AddressModelMockData.postcode).toBe("5")
    expect(AddressModelMockData.country).toBe("United Kingdom")
    # console.log("@$query() method from AddressModel")
    # console.log(AddressModelMockData)

# v2 of Unit Testing for Address Model
# Address Model Unit Testing using mockup data

# This test checks if Address List Service return valid values when make a query by company id on service end point.  

app = angular.module('addressMock', [ 'ngResource' ])

# query for service
app.factory 'AddressListService', ($resource) ->
  $resource 'https://dev.bookingbug.com/rest_api/public_api/21/addresses', { callback: 'JSON_CALLBACK' }, get: method: 'JSONP'

app.controller 'AddressList', ($scope, AddressListService) ->
  $scope.query = ->
    $scope.query = AddressListService.get(q: $scope.searchByCompanyID)
    
# Begin test  
describe 'Checks if service endpoint is valid or not', ->
  scope = scope
  ctrl = ctrl
  httpBackend = httpBackend
  
  beforeEach module('addressMock')
  beforeEach inject(($controller, $rootScope, AddressListService, $httpBackend) ->
    httpBackend = $httpBackend
    scope = $rootScope.$new()
    ctrl = $controller('AddressList', $scope: scope, AddressListService: AddressListService)
    # Create Mockup Data for service end point
    mockData = 
      address1: "1"
      address2: "2"
      address3: ""
      address4: "3"
      address5: "4"
      postcode: "5"
      country: "United Kingdom"
      
    url = 'https://dev.bookingbug.com/rest_api/public_api/21/addresses?' + 'callback=JSON_CALLBACK&q=21'
    httpBackend.whenJSONP(url).respond mockData
  )
  
  it 'Successfully result', ->
    # Search address by company ID
    scope.searchByCompanyID = 21
    scope.query()
    httpBackend.flush()
    # Checks all parameters in order to validate test
    expect(scope.query.address1).toBe "1"
    expect(scope.query.address2).toBe "2"
    expect(scope.query.address3).toBe ""
    expect(scope.query.address4).toBe "3"
    expect(scope.query.address5).toBe "4"
    expect(scope.query.postcode).toBe "5"
    expect(scope.query.country).toBe "United Kingdom"
    # Print all Service parameters
    # console.log(scope.query)