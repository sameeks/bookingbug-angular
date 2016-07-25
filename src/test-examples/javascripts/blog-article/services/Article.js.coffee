service = ($log) ->
  'ngInject'
  class BbTeBlogArticle
    constructor: (title = 'default title', content = 'default content') ->
      @title = title
      @content = content
      return

    getTitle: () ->
      return @title

    setTitle: (title) ->
      @title = title
      return

  return BbTeBlogArticle

angular
.module('bbTe.blogArticle')
.service('BbTeBaBlogArticle', service)
