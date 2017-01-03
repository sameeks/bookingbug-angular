'use strict'

CompanyListBase = ($scope, $rootScope, $q, $attrs, LoadingService) ->

  $scope.controller = "public.controllers.CompanyList"
  loader = LoadingService.$loader($scope).notLoaded()

  options = $scope.$eval $attrs.bbCompanies

  $rootScope.connection_started.then =>
    if $scope.bb.company.companies
      $scope.init($scope.bb.company)
      $rootScope.parent_id = $scope.bb.company.id
    else if $rootScope.parent_id
      $scope.initWidget({company_id:$rootScope.parent_id, first_page: $scope.bb.current_page})
      return
    else
      $scope.init($scope.bb.company)
  , (err) -> loader.setLoadedAndShowError(err, 'Sorry, something went wrong')

  $scope.init = (comp) =>

    $scope.companies = $scope.bb.company.companies
    if !$scope.companies || $scope.companies.length == 0
      $scope.companies = [$scope.bb.company]

    if $scope.companies.length == 1
      $scope.skipThisStep()
      $scope.selectItem($scope.companies[0])
    else
      if options and options.hide_not_live_stores
        $scope.items = $scope.companies.filter (c) -> c.live
      else
        $scope.items = $scope.companies
    loader.setLoaded()

  $scope.selectItem = (item, route) =>

    # if company id is passed in, set the company id to this number
    if angular.isNumber(item)
      company_id = item
    else
      company_id = item.id

    loader.notLoaded()
    prms = {company_id: company_id}
    $scope.initWidget(prms)

  # TODO move this into a mothercare js file
  $scope.splitString = (company) ->
    arr    = company.name.split(' ')
    result = if arr[2] then arr[2] else ""

angular.module('BB.Controllers').controller 'CompanyList', CompanyListBase
