'use strict';

describe 'bbTe.blogArticle, bbTeBaConceptualFactory factory', () ->
  conceptualFactory = null

  beforeEachFn = () ->
    module('bbTe.blogArticle')

    inject ($injector) ->
      conceptualFactory = $injector.get 'bbTeBaConceptualFactory'
      return
    return

  beforeEach beforeEachFn

  it 'can say hello', ->

    expect conceptualFactory.sayHello('test')
    .toBe 'Hi test!'
  return

return
