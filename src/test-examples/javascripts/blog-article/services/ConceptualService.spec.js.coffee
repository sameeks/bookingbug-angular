'use strict';

describe 'bbTe.blogArticle, BbTeBlogArticleConceptualService service', () ->
  ConceptualService = null

  beforeEachFn = () ->
    module('bbTe.blogArticle')

    inject ($injector) ->
      ConceptualService = $injector.get 'BbTeBlogArticleConceptualService'
      return
    return

  beforeEach beforeEachFn

  it 'can say hello', ->

    expect ConceptualService.sayHello('test')
    .toBe 'Hi test!'

  return

return
