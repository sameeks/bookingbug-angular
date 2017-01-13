'use strict'

angular.module('BBAdmin.Directives').directive 'bbAdminClients', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'AdminClients'
  link : (scope, element, attrs) ->
    return


angular.module('BBAdmin.Controllers').controller 'AdminClients', ($scope, $rootScope, $q, $log, AlertService, LoadingService, BBModel) ->

  $scope.clientDef = $q.defer()
  $scope.clientPromise = $scope.clientDef.promise
  $scope.per_page = 15
  $scope.total_entries = 0
  $scope.clients = []

  loader = LoadingService.$loader($scope)

  $scope.getClients = (currentPage, filterBy, filterByFields, orderBy, orderByReverse) ->
    clientDef = $q.defer()

    $rootScope.connection_started.then ->
      loader.notLoaded()
      params =
        company: $scope.bb.company
        per_page: $scope.per_page
        page: currentPage + 1
        filter_by: filterBy
        filter_by_fields: filterByFields
        order_by: orderBy
        order_by_reverse: orderByReverse
      BBModel.Admin.Client.$query(params).then (clients) =>
        $scope.clients = clients.items
        loader.setLoaded()
        $scope.setPageLoaded()
        $scope.total_entries = clients.total_entries
        clientDef.resolve(clients.items)
      , (err) ->
        clientDef.reject(err)
        loader.setLoadedAndShowError(err, 'Sorry, something went wrong')
    true

  $scope.edit = (item) ->
    $log.info("not implemented")

