'use strict'


###**
* @ngdoc directive
* @name BB.Directives:bbCustomBookingText
* @restrict AE
* @scope true
*
* @description
*
* Loads a list of custom booking text for the currently in scope company
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @property {string} messages The messages text
* @property {string} setLoaded Loading set of custom text
* @property {object} setLoadedAndShowError Set loaded and show error
####


angular.module('BB.Directives').directive 'bbCustomBookingText', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'CustomBookingText'


angular.module('BB.Controllers').controller 'CustomBookingText', (
  $scope, $rootScope, $q, CustomTextService, LoadingService) ->

  $scope.controller = "public.controllers.CustomBookingText"
  loader = LoadingService.$loader($scope).notLoaded()

  $rootScope.connection_started.then =>
    CustomTextService.BookingText($scope.bb.company, $scope.bb.current_item).then (msgs) =>
      $scope.messages = msgs
      loader.setLoaded()
    , (err) -> loader.setLoadedAndShowError(err, 'Sorry, something went wrong')
  , (err) -> loader.setLoadedAndShowError(err, 'Sorry, something went wrong')



angular.module('BB.Directives').directive 'bbCustomConfirmationText', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'CustomConfirmationText'


angular.module('BB.Controllers').controller 'CustomConfirmationText', ($scope, $rootScope, CustomTextService, $q, PageControllerService, LoadingService) ->
  $scope.controller = "public.controllers.CustomConfirmationText"
  loader = LoadingService.$loader($scope).notLoaded()

  $rootScope.connection_started.then ->
    $scope.loadData()
  , (err) -> loader.setLoadedAndShowError(err, 'Sorry, something went wrong')

  ###**
  * @ngdoc method
  * @name loadData
  * @methodOf BB.Directives:bbCustomBookingText
  * @description
  * Load data and display a text message
  ###
  $scope.loadData = () =>

    if $scope.total

      CustomTextService.confirmationText($scope.bb.company, $scope.total).then (msgs) ->
        $scope.messages = msgs
        loader.setLoaded()
      , (err) -> loader.setLoadedAndShowError(err, 'Sorry, something went wrong')

    else if $scope.loadingTotal

      $scope.loadingTotal.then (total) ->
        CustomTextService.confirmationText($scope.bb.company, total).then (msgs) ->
          $scope.messages = msgs
          loader.setLoaded()
        , (err) -> loader.setLoadedAndShowError(err, 'Sorry, something went wrong')
      , (err) -> loader.setLoadedAndShowError(err, 'Sorry, something went wrong')

    else
      loader.setLoaded()
