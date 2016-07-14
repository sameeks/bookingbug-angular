'use strict'

###**
* @ngdoc directive
* @name BB.Directives:bbSummary
* @restrict AE
* @scope true
*
* @description
* Loads a summary of the booking
*
*
####


angular.module('BB.Directives').directive 'bbSummary', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'Summary'

angular.module('BB.Controllers').controller 'Summary', ($scope, $rootScope, LoadingService, BBModel, $q) ->

  $scope.controller = "public.controllers.Summary"


  $rootScope.connection_started.then =>
    $scope.item  = $scope.bb.current_item
    $scope.items = $scope.bb.basket.timeItems()


  ###**
  * @ngdoc method
  * @name confirm
  * @methodOf BB.Directives:bbSummary
  * @description
  * Submits the client and BasketItem to the API
  ###
  $scope.confirm = () =>

    loader = LoadingService.$loader($scope).notLoaded()

    promises = [
      BBModel.Client.$create_or_update($scope.bb.company, $scope.client),
    ]

    if $scope.bb.current_item.service
      promises.push($scope.addItemToBasket())

    $q.all(promises).then (result) ->
      client = result[0]
      $scope.setClient(client)

      if client.waitingQuestions
        client.gotQuestions.then () ->
          $scope.client_details = client.client_details

      loader.setLoaded()
      $scope.decideNextPage()

    , (err) -> loader.setLoadedAndShowError(err, 'Sorry, something went wrong')

