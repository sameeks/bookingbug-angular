'use strict';

angular.module('BBAdminBooking').directive 'bbAdminBookingClients', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'adminBookingClients'


angular.module('BBAdminBooking').controller 'adminBookingClients', ($scope, $rootScope, $q, AdminClientService, AlertService, ClientService, ValidatorService, ErrorService, $log, PaginationService) ->

  $scope.validator  = ValidatorService
  $scope.clients    = []
  $scope.pagination = PaginationService.initialise({page_size: 10, max_size: 5})
  
  $scope.sort_by_options = [
    {key: 'first_name', name: 'First Name'},
    {key: 'last_name', name: 'Last Name'},
    {key: 'email', name: 'Email'},
    {key: 'mobile', name: 'Mobile'},
    {key: 'phone', name: 'Phone'}
  ]

  $scope.sort_by = $scope.sort_by_options[0].key


  $rootScope.connection_started.then () ->
    $scope.clearClient()


  $scope.selectClient = (client, route) =>
    $scope.setClient(client)
    $scope.client.setValid(true)
    $scope.decideNextPage(route)


  $scope.createClient = (route) =>

    $scope.notLoaded $scope

    # we need to validate the client information has been correctly entered here
    if $scope.bb && $scope.bb.parent_client
      $scope.client.parent_client_id = $scope.bb.parent_client.id

    $scope.client.setClientDetails($scope.client_details) if $scope.client_details

    ClientService.create_or_update($scope.bb.company, $scope.client).then (client) =>
      $scope.setLoaded $scope
      $scope.selectClient(client, route)
    , (err) ->

      if err.data and err.data.error is "Please Login"
        $scope.setLoaded($scope)
        AlertService.raise('EMAIL_ALREADY_REGISTERED_ADMIN')
      else if err.data and err.data.error is "Sorry, it appears that this phone number already exists"
        $scope.setLoaded($scope)
        AlertService.raise('PHONE_NUMBER_ALREADY_REGISTERED_ADMIN')
      else
        $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')


  $scope.getClients = (params, options = {}) ->

    return if !params

    $scope.params =
      company: $scope.bb.company
      per_page: 10
      filter_by: params.filter_by
      search_by_fields: 'phone,mobile'
      order_by: params.order_by
      order_by_reverse: params.order_by_reverse
      page: if params.page then params.page else 1

    $scope.notLoaded $scope

    AdminClientService.query($scope.params).then (result) ->
      $scope.search_complete = true
      if options.append
        $scope.clients = $scope.clients.concat(result.items)
      else 
        $scope.clients = result.items
      PaginationService.update($scope.pagination, result.total_entries)
      $scope.setLoaded $scope
      $scope.setPageLoaded()


  $scope.searchClients = (search_text) ->

    defer = $q.defer()

    params =
      filter_by: search_text
      company: $scope.bb.company

    AdminClientService.query(params).then (clients) =>
      defer.resolve(clients.items)
      clients.items

    return defer.promise


  $scope.typeHeadResults = ($item, $model, $label) ->

    item          = $item
    model         = $model
    label         = $label
    $scope.client = item

    $scope.selectClient($item)


  $scope.clearSearch = () ->
    $scope.clients = []
    $scope.typehead_result = null
    $scope.search_complete = false


  $scope.edit = (item) ->
    $log.info("not implemented")


  $scope.pageChanged = () ->
    if PaginationService.checkItems($scope.pagination, $scope.clients.length)
      $scope.params.page = $scope.pagination.current_page
      $scope.getClients($scope.params, {append: true})