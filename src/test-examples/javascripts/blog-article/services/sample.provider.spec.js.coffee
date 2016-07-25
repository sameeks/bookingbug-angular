'use strict';

describe 'bbTe.blogArticle, bbTeBaSample provider', () ->
  sampleProviderObj = null
  sample = null

  beforeEachFn = () ->
    module 'bbTe.blogArticle'

    module (bbTeBaSampleProvider) ->
      sampleProviderObj = bbTeBaSampleProvider
      return

    inject ($injector) ->
      sample = $injector.get 'bbTeBaSample'
      return

    return

  beforeEach beforeEachFn

  it 'use default company name to introduce employee', ->
    expect sample.introduceEmployee 'B'
    .toBe 'B works at Default Company'

    return

  it 'use specific company name to introduce employee - by using provider method', ->
    sampleProviderObj.setCompanyName 'BookingBug'

    expect sample.introduceEmployee 'B'
    .toBe 'B works at BookingBug'

    expect sample.introduceEmployee 'C'
    .toBe 'C works at BookingBug'

    return


  it 'use specific company name to introduce employee - by using provider method', ->
    expect sample.introduceEmployee 'B'
    .toBe 'B works at Default Company'

    return

  return
