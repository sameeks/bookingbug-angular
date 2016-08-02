'use strict';

describe 'bbTe.blogArticle, bbTeBaServiceDoingSameAsFactory service', () ->
  bbTeBaServiceDoingSameAsFactory = null

  beforeEachFn = () ->
    module('bbTe.blogArticle')

    inject ($injector) ->
      bbTeBaServiceDoingSameAsFactory = $injector.get 'bbTeBaServiceDoingSameAsFactory'
      return
    return

  beforeEach beforeEachFn

  it 'can say hello', ->

    expect bbTeBaServiceDoingSameAsFactory.sayHello('test')
    .toBe 'Hi test!'

  return

return
