# v1 of Unit Testing for Person Model
# Begin test
# Person Model Unit Testing using mockup data.
# Check if static method @$query returns similar data from public rest api on Person List end point.
# The company id is 21, app-id is **** and app-key is **** .
describe '@$query', () ->

  beforeEach module ('BB')

  $compile = null
  $rootScope = null
  BBModel = BBModel
  BaseModel = BaseModel
  PersonService = PersonService

  beforeEach (inject ((_$httpBackend_, _$compile_, _$rootScope_, _BBModel_, _BaseModel_, _PersonService_) ->
    httpBackend = httpBackend
    $compile = _$compile_
    $rootScope = _$rootScope_
    BBModel = _BBModel_
    BaseModel = _BaseModel_
    PersonService = _PersonService_
  ))

  it 'Successfully result' , () ->
    scope = $rootScope.$new()
    # Use mock data from Persone Service.
    # Make an query to rest api end point.
    PersonModelMockData =
      id: 74
      name: "Jhon Smith"
      type: "person"
      deleted: false
      disabled: false
      order: 74
    # Verify if mock data are equals.
    expect(PersonModelMockData.id).toBe(74)
    expect(PersonModelMockData.name).toBe("Jhon Smith")
    expect(PersonModelMockData.type).toBe("person")
    expect(PersonModelMockData.deleted).toBe (false)
    expect(PersonModelMockData.disabled).toBe(false)
    expect(PersonModelMockData.order).toBe(74)
    # console.log("@$query() method from PersonModel")
    # console.log(PersonModelMockData)

# v2 of Unit Testing for Person Model
# Person Model Unit Testing using mockup data

# This test checks if Person Service return valid values when make a query by company id on service end point.  

app = angular.module('personMock', [ 'ngResource' ])

# query for service
app.factory 'PersonService', ($resource) ->
  $resource 'https://dev.bookingbug.com/rest_api/public_api/21/people', { callback: 'JSON_CALLBACK' }, get: method: 'JSONP'

app.controller 'PersonList', ($scope, PersonService) ->
  $scope.query = ->
    $scope.query = PersonService.get(q: $scope.searchByCompanyID)

# Begin test  
describe 'Checks if service endpoint is valid or not', ->
  scope = scope
  ctrl = ctrl
  httpBackend = httpBackend
  
  beforeEach module('personMock')
  beforeEach inject(($controller, $rootScope, PersonService, $httpBackend) ->
    httpBackend = $httpBackend
    scope = $rootScope.$new()
    ctrl = $controller('PersonList', $scope: scope, PersonService: PersonService)
    # Create Mockup Data for service end point
    mockData = 
      id: 74
      name: "Jhon Smith"
      type: "person"
      deleted: false
      disabled: false
      order: 74
      
    url = 'https://dev.bookingbug.com/rest_api/public_api/21/people?' + 'callback=JSON_CALLBACK&q=21'
    httpBackend.whenJSONP(url).respond mockData
  )
  
  it 'Successfully result', ->
    # Search person by company ID
    scope.searchByCompanyID = 21
    scope.query()
    httpBackend.flush()
    # Checks all parameters in order to validate test
    expect(scope.query.id).toBe 74
    expect(scope.query.name).toBe  "Jhon Smith"
    expect(scope.query.type).toBe "person"
    expect(scope.query.deleted).toBe false
    expect(scope.query.disabled).toBe false
    expect(scope.query.order).toBe 74
    # Print all Service parameters
    # console.log(scope.query)