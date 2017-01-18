'use strict'

WidgetPage = (AlertService, BBModel, LoadingService, LoginService, $rootScope, $sce) ->
  'ngInject'

  $scope = null

  setScope = ($s) ->
    $scope = $s;
    return

  guardScope = () ->
    if $scope is null
      throw new Error 'please set scope'

  clearPage = () ->
    guardScope()
    $scope.bb_main = ""

  hidePage = () ->
    guardScope()
    $scope.hide_page = true

  jumpToPage = (route) =>
    guardScope()
    $scope.current_page = route
    $scope.jumped = true
    $scope.bb_main = $sce.trustAsResourceUrl($scope.partial_url + route + $scope.page_suffix)

  setLoadingPage = (val) =>
    guardScope()
    $scope.loading_page = val

  isLoadingPage = () =>
    guardScope()
    $scope.loading_page

  setPageRoute = (route) =>
    guardScope()
    $scope.bb.current_page_route = route
    if $scope.bb.routeSteps && $scope.bb.routeSteps[route]
      showPage($scope.bb.routeSteps[route])
      return true
    return false

  showPage = (route, dont_record_page) =>
    guardScope()
    $scope.bb.updateRoute(route)
    $scope.jumped = false

    # don't load a new page if we are still loading an old one - helps prevent double clicks
    return if isLoadingPage()

    setLoadingPage(true)
    if $scope.bb.current_page == route
      $scope.bb_main = ""
      setTimeout () ->
        $scope.bb_main = $sce.trustAsResourceUrl($scope.bb.pageURL(route))
        $scope.$apply()
      , 0
    else
      AlertService.clear() # clear any alerts as part of loading a new page
      $scope.bb.current_page = route
      $scope.bb.recordCurrentPage() if !dont_record_page
      LoadingService.notLoaded($scope)
      $scope.bb_main = $sce.trustAsResourceUrl($scope.bb.pageURL(route))

    $rootScope.$broadcast "page:loaded"

  decideNextPage = (route) ->
    guardScope()

    if route
      if route == 'none'
        return
      else
        if $scope.bb.total && $scope.bb.payment_status == 'complete'
          return if setPageRoute($rootScope.Route.Confirmation)
          return showPage('confirmation')
        else
          return showPage(route)

    # do we have a pre-set route...
    if $scope.bb.nextSteps && $scope.bb.current_page && $scope.bb.nextSteps[$scope.bb.current_page] && !$scope.bb.routeSteps
      return showPage($scope.bb.nextSteps[$scope.bb.current_page])
    if !$scope.client.valid() && LoginService.isLoggedIn()
# make sure we set the client to the currently logged in member
# we should also just check the logged in member is  a member of the company they are currently booking with
      $scope.client = new BBModel.Client(LoginService.member()._data)

    if ($scope.bb.company && $scope.bb.company.companies) || (!$scope.bb.company && $scope.affiliate)
      return if setPageRoute($rootScope.Route.Company)
      return showPage('company_list')
    else if $scope.bb.total && $scope.bb.payment_status == "complete"
      return if setPageRoute($rootScope.Route.Confirmation)
      return showPage('confirmation')

    else if ($scope.bb.total && $scope.bb.payment_status == "pending")
      return showPage('payment')
    else if ($scope.bb.company.$has('event_groups') && !$scope.bb.current_item.event_group && !$scope.bb.current_item.service && !$scope.bb.current_item.product && !$scope.bb.current_item.deal) or ($scope.bb.company.$has('events') && $scope.bb.current_item.event_group && !$scope.bb.current_item.event? && !$scope.bb.current_item.product && !$scope.bb.current_item.deal)
      return if setPageRoute($rootScope.Route.Event)
      return showPage('event_list')
    else if ($scope.bb.company.$has('events') && $scope.bb.current_item.event && !$scope.bb.current_item.num_book && (!$scope.bb.current_item.tickets || !$scope.bb.current_item.tickets.qty) && !$scope.bb.current_item.product && !$scope.bb.current_item.deal)
      return showPage('event')
    else if ($scope.bb.company.$has('services') && !$scope.bb.current_item.service && !$scope.bb.current_item.event? && !$scope.bb.current_item.product && !$scope.bb.current_item.deal)
      return if setPageRoute($rootScope.Route.Service)
      return showPage('service_list')
    else if ($scope.bb.company.$has('resources') && !$scope.bb.current_item.resource && !$scope.bb.current_item.event? && !$scope.bb.current_item.product && !$scope.bb.current_item.deal)
      return if setPageRoute($rootScope.Route.Resource)
      return showPage('resource_list')
    else if ($scope.bb.company.$has('people') && !$scope.bb.current_item.person && !$scope.bb.current_item.event? && !$scope.bb.current_item.product && !$scope.bb.current_item.deal)
      return if setPageRoute($rootScope.Route.Person)
      return showPage('person_list')
    else if (!$scope.bb.current_item.duration && !$scope.bb.current_item.event? && !$scope.bb.current_item.product && !$scope.bb.current_item.deal)
      return if setPageRoute($rootScope.Route.Duration)
      return showPage('duration_list')
    else if ($scope.bb.current_item.days_link && !$scope.bb.current_item.date && !$scope.bb.current_item.event? && !$scope.bb.current_item.deal)
      if $scope.bb.company.$has('availability_slots')
        return if setPageRoute($rootScope.Route.Slot)
        return showPage('slot_list')
      else
        return if setPageRoute($rootScope.Route.Date)
        # if we're an admin and we've pre-selected a time - route to that instead
        return showPage('calendar')
    else if ($scope.bb.current_item.days_link && !$scope.bb.current_item.time && !$scope.bb.current_item.event? && (!$scope.bb.current_item.service || $scope.bb.current_item.service.duration_unit != 'day') && !$scope.bb.current_item.deal)
      return if setPageRoute($rootScope.Route.Time)
      return showPage('time')
    else if ($scope.bb.moving_booking && (!$scope.bb.current_item.ready || !$scope.bb.current_item.move_done))
      return showPage('check_move')
    else if (!$scope.client.valid())
      return if setPageRoute($rootScope.Route.Client)
      return showPage('client')
    else if ($scope.bb.current_item.item_details && $scope.bb.current_item.item_details.hasQuestions && !$scope.bb.current_item.asked_questions)
      return if setPageRoute($rootScope.Route.Questions)
      return showPage('check_items')
    else if $scope.bb.moving_booking && $scope.bb.basket.itemsReady()
      return showPage('purchase')
    else if !$scope.bb.basket.readyToCheckout()
      return if setPageRoute($rootScope.Route.Summary)
      return showPage('basket_summary')
    else if ($scope.bb.usingBasket && (!$scope.bb.confirmCheckout || $scope.bb.company_settings.has_vouchers || $scope.bb.company.$has('coupon')))
      return if setPageRoute($rootScope.Route.Basket)
      return showPage('basket')
    else if ($scope.bb.basket.readyToCheckout() && $scope.bb.payment_status == null && !$scope.bb.basket.waiting_for_checkout)
      return if setPageRoute($rootScope.Route.Checkout)
      return showPage('checkout')
# else if ($scope.bb.total && $scope.bb.payment_status == "pending")
#   return showPage('payment')
    else if $scope.bb.payment_status == "complete"
      return if setPageRoute($rootScope.Route.Confirmation)
      return showPage('confirmation')

  return {
    clearPage: clearPage
    decideNextPage: decideNextPage
    hidePage: hidePage
    isLoadingPage: isLoadingPage
    jumpToPage: jumpToPage
    setLoadingPage: setLoadingPage
    setPageRoute: setPageRoute
    setScope: setScope
    showPage: showPage
  }

angular.module('BB').service 'widgetPage', WidgetPage