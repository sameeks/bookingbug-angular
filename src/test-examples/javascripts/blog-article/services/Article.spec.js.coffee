'use strict';

describe 'bbTe.blogArticle, BbTeBlogArticle service', () ->
  BbTeBlogArticle = null

  beforeEachFn = () ->
    module('bbTe.blogArticle')

    inject ($injector) ->
      BbTeBlogArticle = $injector.get 'BbTeBlogArticle'
      return
    return

  beforeEach beforeEachFn

  it 'can instantiate using defaults', ->

    article = new BbTeBlogArticle

    expect article.title
    .toBe 'default title'

    expect article.content
    .toBe 'default content'

    return

  it 'can instantiate with custom title and content', ->
    article1 = new BbTeBlogArticle 'some custom title', 'some custom content'

    expect article1.title
    .toMatch /custom/

    expect article1.content
    .toMatch /custom/

    return

  it 'can can change title', ->
    article = new BbTeBlogArticle 'aaa'

    article.setTitle 'changed'

    expect article.getTitle()
    .toBe 'changed'

    return

  return
