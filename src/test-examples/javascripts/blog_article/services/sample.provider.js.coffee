provider = ($logProvider) ->
  'ngInject'

  companyName = 'Default Company'

  @getCompanyName = () ->
    return companyName

  @setCompanyName = (name) ->
    companyName = name
    return

  @$get = () ->
    'ngInject'

    introduceEmployee = (employeeName) ->
      return employeeName + ' works at ' + companyName

    return {
      introduceEmployee: introduceEmployee
    }

  return

angular
.module('bbTe.blogArticle')
.provider('bbTeBaSample', provider)
