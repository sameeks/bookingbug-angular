provider = ($logProvider) ->
  ### @ngInject ###
  return {
    $get: () ->
      return
  }

angular
.module('bbTe.blogArticle')
.provider('SampleProvider', provider)
