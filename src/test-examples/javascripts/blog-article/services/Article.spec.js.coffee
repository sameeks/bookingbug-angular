'use strict';

describe 'bbTe.blogArticle, BbTeBaBlogArticle service', () ->
  BlogArticle = null

  beforeEachFn = () ->
    module('bbTe.blogArticle')

    inject ($injector) ->
      BlogArticle = $injector.get 'BbTeBaBlogArticle'
      return
    return

  beforeEach beforeEachFn

  it 'can instantiate using defaults', ->

    article = new BlogArticle

    expect article.title
    .toBe 'default title'

    expect article.content
    .toBe 'default content'

    return

  it 'can instantiate with custom title and content', ->
    article1 = new BlogArticle 'some custom title', 'some custom content'

    expect article1.title
    .toMatch /custom/

    expect article1.content
    .toMatch /custom/

    return

  it 'can can change title', ->
    article = new BlogArticle 'aaa'

    article.setTitle 'changed'

    expect article.getTitle()
    .toBe 'changed'

    return

  return
