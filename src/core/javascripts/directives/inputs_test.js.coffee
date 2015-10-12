describe 'cardSecurityCode', () ->

  beforeEach module('BB')

  $compile = null
  $rootScope = null

  beforeEach(inject((_$compile_, _$rootScope_) ->
    $compile = _$compile_
    $rootScope = _$rootScope_
  ))

  it 'should set maxlength to 4 for american express', () ->
    scope = $rootScope.$new()
    element = angular.element('<input type="number" card-security-code card-type="card_type"/>')
    $compile(element)(scope)
    scope.card_type = 'american_express'
    scope.$digest()
    expect(element.attr('maxlength')).toBe('4')

