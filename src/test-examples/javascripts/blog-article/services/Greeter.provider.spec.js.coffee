'use strict';

describe 'bbTe.blogArticle, BbTeBaGreeter provider', () ->
  GreeterProviderObj = null
  Greeter = null

  beforeEachFn = () ->
    module 'bbTe.blogArticle'

    module (BbTeBaGreeterProvider) ->
      GreeterProviderObj = BbTeBaGreeterProvider
      return

    inject ($injector) ->
      Greeter = $injector.get 'BbTeBaGreeter'
      return

    return

  beforeEach beforeEachFn

  it 'can use provider to modify greeting', ->

    greeter = new Greeter

    expect greeter.greet 'B'
    .toBe 'Hello B!'

    GreeterProviderObj.setGreeting 'Hi'

    expect greeter.greet 'B'
    .toBe 'Hi B!'

    return

  return
