describe 'viewport size service', ->

  viewportSize = null
  $document = null

  beforeEach ->
    module 'BB'

    inject ($injector) ->
      viewportSize = $injector.get 'ViewportSize'
      $document = $injector.get '$document'

    # TODO adding bootstrap to document
    # should really grab one used by core
    headHTML = $document.find('head')
    bootstrapCss = angular.element('<link id="test" rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">')
    headHTML.append(bootstrapCss)

    viewportSize.init()


  it 'sets viewport size variables', ->

    console.log 'XS: ' + viewportSize.isXS()
    console.log 'SM: ' + viewportSize.isSM()
    console.log 'MD: ' + viewportSize.isMD()
    console.log 'LG: ' + viewportSize.isLG()
    console.log 'size: ' + viewportSize.getViewportSize()

    expect(true).toBe(true)


  it 'adjusts viewport size variables when window has resized', ->

    # window.resizeTo(1000, 700)
    # $(window).trigger('resize')

    console.log 'XS: ' + viewportSize.isXS()
    console.log 'SM: ' + viewportSize.isSM()
    console.log 'MD: ' + viewportSize.isMD()
    console.log 'LG: ' + viewportSize.isLG()
    console.log 'size: ' + viewportSize.getViewportSize()

    expect(true).toBe(false)
