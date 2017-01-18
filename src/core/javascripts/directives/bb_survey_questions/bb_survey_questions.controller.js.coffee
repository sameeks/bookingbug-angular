'use strict'

angular.module('BB.Controllers').controller 'SurveyQuestions', ($scope, $rootScope,
  $location, BBModel, ValidatorService, $sessionStorage) ->

  $scope.completed = false
  $scope.login = {email: "", password: ""}
  $scope.login_error = false
  $scope.booking_ref = ""

  loader = LoadingService.$loader($scope).notLoaded()

  $rootScope.connection_started.then ->
    init()
  , (err) ->  loader.setLoadedAndShowError(err, 'Sorry, something went wrong')


  init = () =>
    if $scope.company
      if $scope.company.settings.requires_login
        $scope.checkIfLoggedIn()
        if $rootScope.member
          getBookingAndSurvey()
        else
          return
      else
        getBookingAndSurvey()

  ###**
  * @ngdoc method
  * @name checkIfLoggedIn
  * @methodOf BB.Directives:bbSurveyQuestions
  * @description
  * Check if logged in
  ###
  $scope.checkIfLoggedIn = () =>
    BBModel.Login.$checkLogin()

  ###**
  * @ngdoc method
  * @name loadSurvey
  * @methodOf BB.Directives:bbSurveyQuestions
  * @description
  * Load Survey in according of purchase parameter
  *
  * @param {array} purchase The purchase
  ###
  $scope.loadSurvey = (purchase) =>
    unless $scope.company
      $scope.purchase.$get('company').then (company) =>
        setPurchaseCompany(company)

    if $scope.purchase.$has('client')
      $scope.purchase.$get('client').then (client) =>
        $scope.setClient(new BBModel.Client(client))

    $scope.purchase.$getBookings().then (bookings) =>
      params = {}
      $scope.bookings = bookings
      for booking in $scope.bookings
        if booking.datetime
          booking.pretty_date = moment(booking.datetime).format("dddd, MMMM Do YYYY")
        if booking.address
          address = new BBModel.Address(booking.address)
          pretty_address = address.addressSingleLine()
          booking.pretty_address = pretty_address
        if $rootScope.user
          params.admin_only = true
        booking.$get("survey_questions", params).then (details) =>
          item_details = new BBModel.ItemDetails(details)
          booking.survey_questions = item_details.survey_questions
          booking.$getSurveyAnswers().then (answers) =>
            booking.survey_answers = answers
            for question in booking.survey_questions
              if booking.survey_answers
                for answer in booking.survey_answers
                  if (answer.question_text) == question.name && answer.value
                    question.answer = answer.value
            loader.setLoaded()
    , (err) ->
      loader.setLoaded()
      failMsg()

  ###**
  * @ngdoc method
  * @name submitSurveyLogin
  * @methodOf BB.Directives:bbSurveyQuestions
  * @description
  * Submit survey login in according of form parameter else display an error message
  *
  * @param {object} form The survey login form
  ###
  $scope.submitSurveyLogin = (form) =>
    return if !ValidatorService.validateForm(form)
    params =
      email: $scope.login.email
      password: $scope.login.password
      id: $scope.company_id
    BBModel.Login.$companyLogin($scope.company, {}, params).then (member) =>
      BBModel.Login.$setLogin(member)
      getBookingAndSurvey()
    , (err) ->
      showLoginError()
      loader.setLoadedAndShowError(err, 'Sorry, something went wrong')

  ###**
  * @ngdoc method
  * @name loadSurveyFromPurchaseID
  * @methodOf BB.Directives:bbSurveyQuestions
  * @description
  * Load survey from purchase id in according of id parameter else display an error message
  *
  * @param {object} id The id of purchase
  ###
  $scope.loadSurveyFromPurchaseID = (id) =>
    params = {purchase_id: id, url_root: $scope.bb.api_url}
    auth_token = $sessionStorage.getItem('auth_token')
    params.auth_token = auth_token if auth_token
    BBModel.Purchase.Total.$query(params).then (purchase) =>
      $scope.purchase = purchase
      $scope.total = $scope.purchase
      $scope.loadSurvey($scope.purchase)
    , (err) ->
      loader.setLoadedAndShowError(err, 'Sorry, something went wrong')

  ###**
  * @ngdoc method
  * @name loadSurveyFromBookingRef
  * @methodOf BB.Directives:bbSurveyQuestions
  * @description
  * Load survey from booking ref in according of id else display an error message
  *
  * @param {object} id The id of booking
  ###
  $scope.loadSurveyFromBookingRef = (id) =>
    params = {booking_ref: id, url_root: $scope.bb.api_url, raw: true}
    auth_token = $sessionStorage.getItem('auth_token')
    params.auth_token = auth_token if auth_token
    BBModel.Purchase.Total.$bookingRefQuery(params).then (purchase) =>
      $scope.purchase = purchase
      $scope.total = $scope.purchase
      $scope.loadSurvey($scope.purchase)
    , (err) ->
      showLoginError()
      loader.setLoadedAndShowError(err, 'Sorry, something went wrong')

  ###**
  * @ngdoc method
  * @name submitSurvey
  * @methodOf BB.Directives:bbSurveyQuestions
  * @description
  * Submit survey in according of form parameter
  *
  * @param {object} form The survey form
  ###
  $scope.submitSurvey = (form) =>
    return if !ValidatorService.validateForm(form)
    for booking in $scope.bookings
      booking.checkReady()
      if booking.ready
        loader.notLoaded()
        booking.client_id = $scope.client.id
        params = (booking)
        BBModel.Purchase.Booking.$addSurveyAnswersToBooking(params).then (booking) ->
          loader.setLoaded()
          $scope.completed = true
        , (err) ->
          loader.setLoaded()
      else
        $scope.decideNextPage(route)

  ###**
  * @ngdoc method
  * @name submitBookingRef
  * @methodOf BB.Directives:bbSurveyQuestions
  * @description
  * Submit booking in according of form parameter
  *
  * @param {object} form The submit booking form
  ###
  $scope.submitBookingRef = (form) =>
    return if !ValidatorService.validateForm(form)
    loader.notLoaded()
    params = {booking_ref: $scope.booking_ref, url_root: $scope.bb.api_url, raw: true}
    auth_token = $sessionStorage.getItem('auth_token')
    params.auth_token = auth_token if auth_token
    BBModel.Purchase.Total.$bookingRefQuery(params).then (purchase) =>
      $scope.purchase = purchase
      $scope.total = $scope.purchase
      $scope.loadSurvey($scope.purchase)
    , (err) ->
      showLoginError()
      loader.setLoadedAndShowError(err, 'Sorry, something went wrong')

  ###**
  * @ngdoc method
  * @name storeBookingCookie
  * @methodOf BB.Directives:bbSurveyQuestions
  * @description
  * Store booking cookie
  ###
  $scope.storeBookingCookie = () ->
    document.cookie = "bookingrefsc=" + $scope.booking_ref

  ###**
  * @ngdoc method
  * @name showLoginError
  * @methodOf BB.Directives:bbSurveyQuestions
  * @description
  * Show login error
  ###
  showLoginError = () =>
    $scope.login_error = true

  ###**
  * @ngdoc method
  * @name getMember
  * @methodOf BB.Directives:bbSurveyQuestions
  * @description
  * Get member
  ###
  getMember = () =>
    params = {member_id: $scope.member_id, company_id: $scope.company_id}
    BBModel.Login.$memberQuery(params).then (member) =>
      $scope.member = member

  ###**
  * @ngdoc method
  * @name setPurchaseCompany
  * @methodOf BB.Directives:bbSurveyQuestions
  * @description
  * Set purchase company in according of company parameter
  *
  * @param {object} company The company
  ###
  setPurchaseCompany = (company) ->
    $scope.bb.company_id = company.id
    $scope.bb.company = new BBModel.Company(company)
    $scope.company = $scope.bb.company
    $scope.bb.item_defaults.company = $scope.bb.company
    if company.settings
      $scope.bb.item_defaults.merge_resources = true if company.settings.merge_resources
      $scope.bb.item_defaults.merge_people    = true if company.settings.merge_people

  ###**
  * @ngdoc method
  * @name getBookingRef
  * @methodOf BB.Directives:bbSurveyQuestions
  * @description
  * Get booking references
  ###
  getBookingRef = () ->
    matches = /^.*(?:\?|&)booking_ref=(.*?)(?:&|$)/.exec($location.absUrl())
    booking_ref = matches[1] if matches
    booking_ref

  ###**
  * @ngdoc method
  * @name getPurchaseID
  * @methodOf BB.Directives:bbSurveyQuestions
  * @description
  * Get purchase Id
  ###
  getPurchaseID = () ->
    matches = /^.*(?:\?|&)id=(.*?)(?:&|$)/.exec($location.absUrl())
    purchase_id = matches[1] if matches
    purchase_id

  ###**
  * @ngdoc method
  * @name getBookingAndSurvey
  * @methodOf BB.Directives:bbSurveyQuestions
  * @description
  * Get booking and survey
  ###
  getBookingAndSurvey = () ->
    id = getBookingRef()
    if id
      $scope.loadSurveyFromBookingRef(id)
    else
      id = getPurchaseID()
      if id
        $scope.loadSurveyFromPurchaseID(id)
      else
        if $scope.bb.total
          $scope.loadSurveyFromPurchaseID($scope.bb.total.long_id)
        else
          return
