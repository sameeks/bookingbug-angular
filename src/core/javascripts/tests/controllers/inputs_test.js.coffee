describe 'cardSecurityCode', () ->

  beforeEach module('BB')

  $compile = null
  $rootScope = null

  beforeEach(inject((_$compile_, _$rootScope_) ->
    $compile = _$compile_
    $rootScope = _$rootScope_
  ))

  getCompiledElement = () ->
    element = angular.element('<input type="number" credit-card-number card-number="card_number"/>')
    compiledElement = compile(element)(scope)
    scope.$digest()
    return compiledElement

  it 'should set maxlength to 4 for american express', () ->
    scope = $rootScope.$new()
    element = angular.element('<input type="number" card-security-code card-type="card_type"/>')
    $compile(element)(scope)
    scope.card_type = 'american_express'
    scope.$digest()
    expect(element.attr('maxlength')).toBe('4') 

  it 'should set maxlength to 4 for am3erican express', () ->
    scope = $rootScope.$new()
    element = angular.element('<input type="number" card-security-code card-type="card_type"/>')
    $compile(element)(scope)
    scope.card_type != 'american_express'
    scope.$digest()
    expect(element.attr('maxlength')).toBe('3') 


describe 'creditCardNumber', () ->

  beforeEach module('BB')

  $compile = null
  $rootScope = null
  scope = null

  beforeEach(inject((_$compile_, _$rootScope_) ->
    $compile = _$compile_
    $rootScope = _$rootScope_
    scope = $rootScope.$new();
  ))


  it 'should set credit card type', () ->
    scope.cridit_card_number = 444
    element = angular.element('<input type="number" credit-card-number card-number="card_number"/>')
    compiledElement = $compile(element)(scope)
    

    console.log scope.cridit_card_number
    console.log compiledElement
    scope.$digest()
    console.log compiledElement.attr("card-number")
    # expect("4444").toCreditCardNumber("diners_club_enroute")
    #console.log scope.getCardType("4444")
