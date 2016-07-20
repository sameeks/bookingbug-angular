service = () ->

  @model = ->
    @id = null
    @title = 'default title'
    @content = 'default content'

    @getTitle = getTitle
    @setTitle = setTitle

    return

  getTitle = () ->
    return @title

  setTitle = (title) ->
    @title = title
    return

  return #because service by default returns object

angular
.module('bbTe.blogArticle')
.service('BbTeBlogArticle', service)
