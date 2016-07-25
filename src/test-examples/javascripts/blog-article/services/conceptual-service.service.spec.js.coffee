'use strict';

describe 'bbTe.blogArticle, bbTeBaConceptualService service', () ->
  conceptualService = null

  beforeEachFn = () ->
    module('bbTe.blogArticle')

    inject ($injector) ->
      conceptualService = $injector.get 'bbTeBaConceptualService'
      return
    return

  beforeEach beforeEachFn

  it 'can say hello', ->
    expect conceptualService.sayHello('test')
    .toBe 'Hi test!'

  return

return
