describe 'checkout', () ->
  beforeEach module('BB')
  beforeEach module('templates')

  it('should show order details', inject(($compile, $rootScope, $templateCache, $httpBackend) ->
    scope = $rootScope.$new()
    $compile($templateCache.get('checkout.html'))(scope)
  ))
