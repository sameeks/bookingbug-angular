'use strict';

describe 'bbTe.blogArticle, Sample provider', () ->
  SampleProviderObj = null
  Sample = null

  beforeEachFn = () ->
    module 'bbTe.blogArticle'

    module (SampleProvider) ->
      SampleProviderObj = SampleProvider
      return

    inject ($injector) ->
      Sample = $injector.get 'Sample'
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
