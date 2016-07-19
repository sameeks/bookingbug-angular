'use strict';

describe 'bbTe.blogArticle, BbTeBlogArticleGateway service', () ->
  ArticleGateway = null

  setup = () ->
    module('bbTe.blogArticle')

    inject ($injector) ->
      ArticleGateway = $injector.get 'BbTeBlogArticleGateway'

      return

    return

  beforeEach setup

  xit 'can load article', () ->

    console.log ArticleGateway.getArticle(1)

    return


