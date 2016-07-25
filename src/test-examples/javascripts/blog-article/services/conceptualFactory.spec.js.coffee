'use strict';

describe 'bbTe.blogArticle, bbTeBaConceptualFactory factory', () ->
  ConceptualFactory = null

  beforeEachFn = () ->
    module('bbTe.blogArticle')

    inject ($injector) ->
      ConceptualFactory = $injector.get 'bbTeBaConceptualFactory'
      return
    return

  beforeEach beforeEachFn

  it 'can say hello', ->
    expect ConceptualFactory.sayHello('test')
    .toBe 'Hi test!'
  return

return
