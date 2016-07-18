'use strict';

describe 'bbTe.blogArticle, BbTeBlogArticleGateway factory', () ->
  ArticleGateway = null

  setup = () ->
    module('bbTe.blogArticle')

    inject ($injector) ->
      ArticleGateway = $injector.get 'BbTeBlogArticleGateway'

      return

    return

  beforeEach setup

  it 'service expose proper methods', () ->
    expect ArticleGateway.someMethod1
    .toBeDefined()

    expect ArticleGateway.someMethod2
    .toBeDefined()
    return


