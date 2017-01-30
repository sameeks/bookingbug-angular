'use strict'

angular.module('BBAdminBooking').directive 'bbAdminBookingClients', () ->
  restrict: 'AE'
  replace: false
  scope : true
  controller : 'adminBookingClients'
  templateUrl: 'admin_booking_clients.html'


angular.module('BBAdminBooking').controller 'adminBookingClients', ($scope,  $rootScope, $q, AlertService,
  ValidatorService, ErrorService, $log, BBModel,  $timeout, LoadingService, AdminBookingOptions, $translate) ->

  $scope.validator  = ValidatorService
  $scope.admin_options = AdminBookingOptions
  $scope.clients = new BBModel.Pagination({page_size: 10, max_size: 5, request_page_size: 10})
  loader = LoadingService.$loader($scope)

  $scope.sort_by_options = [
    {key: 'first_name', name: $translate.instant('ADMIN_BOOKING.CUSTOMER.SORT_BY_FIRST_NAME')},
    {key: 'last_name', name: $translate.instant('ADMIN_BOOKING.CUSTOMER.SORT_BY_LAST_NAME')},
    {key: 'email', name: $translate.instant('ADMIN_BOOKING.CUSTOMER.SORT_BY_EMAIL')}
  ]

  $scope.sort_by = $scope.sort_by_options[0].key


  $rootScope.connection_started.then () ->
    $scope.clearClient()

  $scope.selectClient = (client, route) =>
    $scope.setClient(client)
    $scope.client.setValid(true)
    $scope.decideNextPage(route)


  $scope.createClient = (route) =>

    loader.notLoaded()

    # we need to validate the client information has been correctly entered here
    if $scope.bb && $scope.bb.parent_client
      $scope.client.parent_client_id = $scope.bb.parent_client.id

    $scope.client.setClientDetails($scope.client_details) if $scope.client_details

    # set the default_company_id on the client so that we can filter search results by child company if AdminBookingOptions.use_default_company_id is set
    $scope.client.default_company_id = $scope.bb.company.id

    BBModel.Client.$create_or_update($scope.bb.company, $scope.client).then (client) =>
      loader.setLoaded()
      $scope.selectClient(client, route)
    , (err) ->

      if err.data and err.data.error is "Please Login"
        loader.setLoaded()
        AlertService.raise('EMAIL_IN_USE')
      else if err.data and err.data.error is "Sorry, it appears that this phone number already exists"
        loader.setLoaded()
        AlertService.raise('PHONE_NUMBER_IN_USE')
      else
        loader.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')


  $scope.getClients = (params, options = {}) ->

    $scope.search_triggered = true

    $timeout ->
      $scope.search_triggered = false
    , 1000

    return if !params or (params and !params.filter_by)

    $scope.params =
      company: params.company or $scope.bb.company
      per_page: params.per_page or $scope.clients.request_page_size
      filter_by: params.filter_by
      search_by_fields: params.search_by_fields or 'phone,mobile'
      order_by: params.order_by or $scope.sort_by
      order_by_reverse: params.order_by_reverse
      page: params.page or 1
    $scope.params.default_company_id = $scope.bb.company.id if AdminBookingOptions.use_default_company_id

    $scope.notLoaded $scope

    BBModel.Admin.Client.$query($scope.params).then (result) ->

      $scope.search_complete = true

      if options.add
        $scope.clients.add(params.page, result.items)
      else
        $scope.clients.initialise(result.items, result.total_entries)

      loader.setLoaded()


  $scope.searchClients = (search_text) ->
    defer = $q.defer()
    params =
      filter_by: search_text
      company: $scope.bb.company
    params.default_company_id = $scope.bb.company.id if AdminBookingOptions.use_default_company_id
    BBModel.Admin.Client.$query(params).then (clients) =>
      defer.resolve(clients.items)
    defer.promise


  $scope.typeHeadResults = ($item, $model, $label) ->

    item          = $item
    model         = $model
    label         = $label
    $scope.client = item

    $scope.selectClient($item)


  $scope.clearSearch = () ->
    $scope.clients.initialise()
    $scope.typeahead_result = null
    $scope.search_complete = false


  $scope.edit = (item) ->
    $log.info("not implemented")


  $scope.pageChanged = () ->

    [items_present, page_to_load] = $scope.clients.update()

    if !items_present
      $scope.params.page = page_to_load
      $scope.getClients($scope.params, {add: true})


  $scope.sortChanged = (sort_by) ->
    $scope.params.order_by = sort_by
    $scope.params.page = 1
    $scope.getClients($scope.params)

