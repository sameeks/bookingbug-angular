# v1 of Unit Testing for Service Model
# Begin test
# Service Model Unit Testing using mockup data.
# Check if static method @$query returns similar data from public rest api on Service List end point.
# The company id is 21, app-id is **** and app-key is **** .
describe '@$query', () ->

  beforeEach module('BB')

  $compile = null
  $rootScope = null
  BBModel = BBModel
  BaseModel = BaseModel
  ServiceService = ServiceService

  beforeEach (inject((_$httpBackend_, _$compile_, _$rootScope_, _BBModel_, _BaseModel_, _ServiceService_) ->
    httpBackend = httpBackend
    $compile = _$compile_
    $rootScope = _$rootScope_
    BBModel = _BBModel_
    BaseModel = _BaseModel_
    ServiceService = _ServiceService_
  ))

  it 'Successfully result', () ->
    scope = $rootScope.$new()
    # Use mock data from Service Service.
    # Make an query to rest api end point.
    ServiceModelMockData =
      id: 46 
      name: "Tennis Lesson"
      duration: 60
      prices: 1000
      detail_group_id: 14
      booking_time_step: 60
      min_bookings: 1
      max_bookings: 1
    # Verify if mock data are equals.
    expect(ServiceModelMockData.id).toBe(46)
    expect(ServiceModelMockData.name).toBe ("Tennis Lesson")
    expect(ServiceModelMockData.duration).toBe(60)
    expect(ServiceModelMockData.prices).toBe (1000)
    expect(ServiceModelMockData.detail_group_id).toBe(14)
    expect(ServiceModelMockData.booking_time_step).toBe (60)
    expect(ServiceModelMockData.min_bookings).toBe (1)
    expect(ServiceModelMockData.max_bookings).toBe (1)
    # console.log("@$query() method from ServiceModel")
    # console.log(ServiceModelMockData)

#v2 of Unit Testing for Service Model
# Service Model Unit Testing using mockup data

# This test checks if Service Service return valid values when make a query by company id on service end point.  

app = angular.module('serviceMock', [ 'ngResource' ])

# query for service
app.factory 'ServiceService', ($resource) ->
  $resource 'https://dev.bookingbug.com/rest_api/public_api/21/services', { callback: 'JSON_CALLBACK' }, get: method: 'JSONP'

app.controller 'ServiceList', ($scope, ServiceService) ->
  $scope.query = ->
    $scope.query = ServiceService.get(q: $scope.searchByCompanyID)

# Begin test  
describe 'Checks if service endpoint is valid or not', ->
  scope = scope
  ctrl = ctrl
  httpBackend = httpBackend
  
  beforeEach module('serviceMock')
  beforeEach inject(($controller, $rootScope, ServiceService, $httpBackend) ->
    httpBackend = $httpBackend
    scope = $rootScope.$new()
    ctrl = $controller('ServiceList', $scope: scope, ServiceService: ServiceService)
    # Create Mockup Data for service end point
    mockData = 
      id: 46 
      name: "Tennis Lesson"
      duration: 60
      prices: 1000
      detail_group_id: 14
      booking_time_step: 60
      min_bookings: 1
      max_bookings: 1
      
    url = 'https://dev.bookingbug.com/rest_api/public_api/21/services?' + 'callback=JSON_CALLBACK&q=21'
    httpBackend.whenJSONP(url).respond mockData
  )
  
  it 'Successfully result', ->
    # Search company by ID
    scope.searchByCompanyID = 21
    scope.query()
    httpBackend.flush()
    # Checks all parameters in order to validate test
    expect(scope.query.id).toBe 46
    expect(scope.query.name).toBe  "Tennis Lesson"
    expect(scope.query.duration).toBe 60
    expect(scope.query.prices).toBe 1000
    expect(scope.query.detail_group_id).toBe 14
    expect(scope.query.booking_time_step).toBe 60
    expect(scope.query.min_bookings).toBe 1
    expect(scope.query.max_bookings).toBe 1
    # Print all Service parameters
    # console.log(scope.query)
  