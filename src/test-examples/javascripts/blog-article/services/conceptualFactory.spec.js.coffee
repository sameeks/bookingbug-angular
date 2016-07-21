'use strict';

describe 'bbTe.blogArticle, bbTeBlogArticleConceptualFactory factory', () ->
  ConceptualFactory = null

  beforeEachFn = () ->
    module('bbTe.blogArticle')

    inject ($injector) ->
      ConceptualFactory = $injector.get 'bbTeBlogArticleConceptualFactory'
      return
    return

  beforeEach beforeEachFn

  it 'can say hello', ->
    expect ConceptualFactory.sayHello('test')
    .toBe 'Hi test!'
  return

return
