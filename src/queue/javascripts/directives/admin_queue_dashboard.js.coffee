'use strict'

angular.module('BBQueue').directive 'bbIfLogin', ($q, $compile, BBModel) ->

  compile = () ->
    {
      pre: ( scope, element, attributes ) ->
        @whenready = $q.defer()
        scope.loggedin = @whenready.promise
        BBModel.Admin.Company.$query(attributes).then (company) ->
          scope.company = company
          @whenready.resolve()
      ,
      post: ( scope, element, attributes ) ->
    }

  link = (scope, element, attrs) ->
  {
    compile: $compile
  }


angular.module('BBQueue').directive 'bbQueueDashboard', () ->

  link = (scope, element, attrs) ->
    scope.loggedin.then () ->
      scope.getSetup()

  {
    link: link
    controller: 'bbQueueDashboardController'
  }


angular.module('BBQueue').directive 'bbQueues', () ->

  link = (scope, element, attrs) ->
    scope.loggedin.then () ->
      scope.getQueues()

  {
    link: link
    controller: 'bbQueues'
  }

angular.module('BBQueue').directive 'bbQueueServers', () ->

  link = (scope, element, attrs) ->
    scope.loggedin.then () ->
      scope.getServers()

  {
    link: link
    controller: 'bbQueueServers'
  }

