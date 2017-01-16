
'use strict'

angular.module('BB.Controllers').controller 'PayForm', ($scope, $location) ->

  $scope.controller = "public.controllers.PayForm"

  ###**
  * @ngdoc method
  * @name setTotal
  * @methodOf BB.Directives:bbPayForm
  * @description
  * Set total price
  *
  * @param {array} total The total price
  ###
  $scope.setTotal = (total) ->
    $scope.total = total

  ###**
  * @ngdoc method
  * @name setCard
  * @methodOf BB.Directives:bbPayForm
  * @description
  * Set card used to payment
  *
  * @param {array} card The card used to payment
  ###
  $scope.setCard = (card) ->
    $scope.card = card

  ###**
  * @ngdoc method
  * @name sendSubmittingEvent
  * @methodOf BB.Directives:bbPayForm
  * @description
  * Send submitting event
  ###
  sendSubmittingEvent = () =>
    referrer = $location.protocol() + "://" + $location.host()
    if $location.port()
      referrer += ":" + $location.port()
    target_origin = $scope.referrer

    payload = JSON.stringify({
      'type': 'submitting',
      'message': referrer
    })
    parent.postMessage(payload, target_origin)

  ###**
  * @ngdoc method
  * @name submitPaymentForm
  * @methodOf BB.Directives:bbPayForm
  * @description
  * Submit payment form
  ###
  submitPaymentForm = () =>
    payment_form = angular.element.find('form')
    payment_form[0].submit()

  ###**
  * @ngdoc method
  * @name submitAndSendMessage
  * @methodOf BB.Directives:bbPayForm
  * @description
  * Submit and send message in according of event paramenter
  *
  * @param {object} event The event
  ###
  $scope.submitAndSendMessage = (event) =>
    event.preventDefault()
    event.stopPropagation()
    payment_form = $scope.$eval('payment_form')
    if payment_form.$invalid
      payment_form.submitted = true
      return false
    else
      sendSubmittingEvent()
      submitPaymentForm()
