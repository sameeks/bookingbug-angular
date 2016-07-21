'use strict';

describe 'bbTe.blogArticle, SampleProvider provider', () ->
  SampleProvider = null

  beforeEachFn = () ->
    module('bbTe.blogArticle')

    inject ($injector) ->
      SampleProvider = $injector.get 'SampleProvider'
      return
    return

  beforeEach beforeEachFn

  it 'test', ->


  return

return
