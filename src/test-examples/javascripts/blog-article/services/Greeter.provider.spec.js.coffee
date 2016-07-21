'use strict';

describe 'bbTe.blogArticle, Greeter provider', () ->
  GreeterProviderObj = null
  Greeter = null

  beforeEachFn = () ->
    module 'bbTe.blogArticle'

    module (GreeterProvider) ->
      GreeterProviderObj = GreeterProvider
      return

    inject ($injector) ->
      Greeter = $injector.get 'Greeter'
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
