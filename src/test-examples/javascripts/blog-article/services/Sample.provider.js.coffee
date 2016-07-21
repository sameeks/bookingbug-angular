provider = ($logProvider) ->
  'ngInject'

  companyName = 'Default Company'

  @getCompanyName = () ->
    return companyName

  @setCompanyName = (name) ->
    companyName = name
    return

  introduceEmployee = (employeeName) ->
    return employeeName + ' works at ' + companyName

  @$get = () ->
    'ngInject'
    introduceEmployee: introduceEmployee

  return

angular
.module('bbTe.blogArticle')
.provider('Sample', provider)
