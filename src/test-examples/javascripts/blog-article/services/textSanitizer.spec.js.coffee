'use strict';

describe 'bbTe.blogArticle, bbTeBlogArticleTextSanitizer service', () ->
  articleSanitizer = null

  sampleText = ' SomE Sample text, SomE Sample text    ';
  expected = null;

  setup = () ->
    module('bbTe.blogArticle')

    inject ($injector) ->
      articleSanitizer = $injector.get 'bbTeBlogArticleTextSanitizer'

      return

    expected = articleSanitizer.sanitize(sampleText)

    return

  beforeEach setup

  it 'remove trailing whitespaces', () ->

    expect expected[0]
    .not.toBe ' '

    return

  it 'returns only 10 characters', () ->

    expect expected.length
    .toBe 10

    return

  it 'lowercase the text', () ->

    expect expected
    .toBe expected.toLowerCase()

    return



