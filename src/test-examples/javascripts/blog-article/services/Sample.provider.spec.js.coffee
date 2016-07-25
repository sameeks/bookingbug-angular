'use strict';

describe 'bbTe.blogArticle, BbTeBaSample provider', () ->
  SampleProviderObj = null
  Sample = null

  beforeEachFn = () ->
    module 'bbTe.blogArticle'

    module (BbTeBaSampleProvider) ->
      SampleProviderObj = BbTeBaSampleProvider
      return

    inject ($injector) ->
      Sample = $injector.get 'BbTeBaSample'
      return

    return

  beforeEach beforeEachFn

  it 'use default company name to introduce employee', ->
    expect Sample.introduceEmployee 'B'
    .toBe 'B works at Default Company'

    return

  it 'use specific company name to introduce employee - by using provider method', ->
    SampleProviderObj.setCompanyName 'BookingBug'

    expect Sample.introduceEmployee 'B'
    .toBe 'B works at BookingBug'

    expect Sample.introduceEmployee 'C'
    .toBe 'C works at BookingBug'

    return


  it 'use specific company name to introduce employee - by using provider method', ->
    expect Sample.introduceEmployee 'B'
    .toBe 'B works at Default Company'

    return

  return
