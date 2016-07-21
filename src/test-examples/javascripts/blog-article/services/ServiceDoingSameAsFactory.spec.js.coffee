'use strict';

describe 'bbTe.blogArticle, BbTeBlogArticleServiceDoingSameAsFactory service', () ->
  ServiceDoingSameAsFactory = null

  beforeEachFn = () ->
    module('bbTe.blogArticle')

    inject ($injector) ->
      ServiceDoingSameAsFactory = $injector.get 'BbTeBlogArticleServiceDoingSameAsFactory'
      return
    return

  beforeEach beforeEachFn

  it 'can say hello', ->

    expect ServiceDoingSameAsFactory.sayHello('test')
    .toBe 'Hi test!'

  return

return
