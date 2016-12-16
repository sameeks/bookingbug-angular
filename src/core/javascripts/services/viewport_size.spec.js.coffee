describe 'viewport size service', ->

  $compile = null
  $rootScope = null
  # $scope = null
  viewportSize = null

  beforeEach ->
    module 'BB'

    inject ($injector) ->
      $compile = $injector.get '$compile'
      $rootScope = $injector.get '$rootScope'
      # $scope = $rootScope.$new()
      viewportSize = $injector.get 'ViewportSize'

  it 'set viewport size', ->

    viewportSize.init()

    element = $compile("<div class='visibile-xs'></div>")($rootScope)

    $rootScope.$digest()

    # console.log 'XS: ' + viewportSize.isXS()
    # console.log 'SM: ' + viewportSize.isSM()
    # console.log 'MD: ' + viewportSize.isMD()
    # console.log 'LG: ' + viewportSize.isLG()
    # console.log 'size: ' + viewportSize.getViewportSize()

    expect(true).toBe(true)

  it 'adjust values when window has resized', ->
    expect(true).toBe(false)