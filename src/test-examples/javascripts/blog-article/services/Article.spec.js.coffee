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

  it 'can create new articles and change their names', ->
    ar1 = new BbTeBlogArticle.model()
    ar1.setTitle 'ar1 title'

    ar2 = new BbTeBlogArticle.model()

    expect ar1.getTitle()
    .toBe 'ar1 title'

    expect ar2.getTitle()
    .toBe 'default title'

    return

  return
