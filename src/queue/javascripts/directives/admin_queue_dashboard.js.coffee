angular.module('BBQueue').directive 'bbIfLogin', ($log, $q,
  $rootScope, AdminQueueService, AdminCompanyService, $compile, $templateCache,
  ModalForm, BBModel) ->

  compile = () ->
    {
      pre: ( scope, element, attributes ) ->
        @whenready = $q.defer()
        scope.loggedin = @whenready.promise
        AdminCompanyService.query(attributes).then (company) ->
          scope.company = company
          @whenready.resolve()
      ,
      post: ( scope, element, attributes ) ->
    }

  link = (scope, element, attrs) ->
  {
    compile: compile
#    controller: 'bbQueuers'
    # templateUrl: 'queuer_table.html'
  }



angular.module('BBQueue').directive 'bbQueueDashboard', ($log,
  $rootScope, $compile, $templateCache,
  ModalForm, BBModel) ->

  link = (scope, element, attrs) ->
    scope.loggedin.then () ->
      scope.getSetup()

  {
    link: link
    controller: 'bbQueueDashboardController'
  }



angular.module('BBQueue').directive 'bbQueues', ($log,
  $rootScope, $compile, $templateCache,
  ModalForm, BBModel) ->

  link = (scope, element, attrs) ->
    scope.loggedin.then () ->
      scope.getQueues()

  {
    link: link
    controller: 'bbQueues'
    # templateUrl: 'queuer_table.html'
  }


angular.module('BBQueue').directive 'bbQueueServers', ($log,
  $rootScope, $compile, $templateCache,
  ModalForm, BBModel) ->

  link = (scope, element, attrs) ->
    scope.loggedin.then () ->
      scope.getServers()

  {
    link: link
    controller: 'bbQueueServers'
    # templateUrl: 'queuer_table.html'
  }
