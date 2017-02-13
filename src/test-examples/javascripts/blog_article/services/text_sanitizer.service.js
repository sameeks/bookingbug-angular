service = ($log) ->
  'ngInject'

  currentText = null;

  lowercase = () ->
    currentText = currentText.toLowerCase()

  shorten = () ->
    currentText = currentText.substr(0, 10)

  trim = () ->
    currentText = currentText.trim()

  sanitize = (text)->
    currentText = text

    trim()
    shorten()
    lowercase()

    currentText

  return {
    sanitize: sanitize
  }

angular
.module('bbTe.blogArticle')
.service('bbTeBaTextSanitizer', service)
