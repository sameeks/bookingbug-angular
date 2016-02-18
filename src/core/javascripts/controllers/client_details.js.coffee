###**
* @ngdoc directive
* @name BB.Directives:bbClientDetails
* @restrict AE
* @scope true
*
* @description
* Loads a list of client details for the currently in scope company
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @property {array} questions Questions of the client
* @property {integer} company_id The company id of the client company
* @property {object} validator The validator service - see {@link BB.Services:Validator Validator Service}
* @property {object} alert The alert service - see {@link BB.Services:Alert Alert Service}
* @example
*  <example module="BB">
*    <file name="index.html">
*   <div bb-api-url='https://uk.bookingbug.com'>
*   <div  bb-widget='{company_id:21}'>
*     <div bb-client-details>
*        <p>company_id: {{client_details.company_id}}</p>
*        <p>offer_login: {{client_details.offer_login}}</p>
*        <p>ask_address: {{client_details.ask_address}}</p>
*        <p>no_phone: {{client_details.no_phone}}</p>
*      </div>
*     </div>
*     </div>
*   </file>
*  </example>
*
####


angular.module('BB.Directives').directive 'bbClientDetails', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'ClientDetails'

angular.module('BB.Controllers').controller 'ClientDetails',
($scope, $attrs, $rootScope, LoginService, ValidatorService, AlertService, BBModel) ->

  $scope.controller = "public.controllers.ClientDetails"
  $scope.notLoaded $scope
  $scope.validator = ValidatorService
  $scope.existing_member = false
  $scope.login_error = false


  options = $scope.$eval($attrs.bbClientDetails) or {}
  $scope.suppress_client_create = $attrs.bbSuppressCreate? or options.suppress_client_create

  $rootScope.connection_started.then =>

    if !$scope.client.valid() && LoginService.isLoggedIn()
      # make sure we set the client to the currently logged in member
      # we should also just check the logged in member is a member of the company they are currently booking with
      $scope.setClient(new BBModel.Client(LoginService.member()._data))

    if LoginService.isLoggedIn() && LoginService.member().$has("child_clients") && LoginService.member()
      LoginService.member().$getChildClients().then (children) =>
        $scope.bb.parent_client = new BBModel.Client(LoginService.member()._data)
        $scope.bb.child_clients = children
        $scope.bb.basket.parent_client_id = $scope.bb.parent_client.id

    if $scope.client.client_details
      $scope.client_details = $scope.client.client_details
      BBModel.Question.$checkConditionalQuestions($scope.client_details.questions) if $scope.client_details.questions
      $scope.setLoaded $scope
    else
      BBModel.ClientDetails.$query($scope.bb.company).then (details) =>
        $scope.client_details = details
        $scope.client.pre_fill_answers($scope.client_details) if $scope.client
        BBModel.Question.$checkConditionalQuestions($scope.client_details.questions) if $scope.client_details.questions
        $scope.setLoaded $scope
      , (err) ->  $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')

  , (err) ->  $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')


  $rootScope.$watch 'member', (oldmem, newmem) =>
    if !$scope.client.valid() && LoginService.isLoggedIn()
      $scope.setClient(new BBModel.Client(LoginService.member()._data))

  ###**
  * @ngdoc method
  * @name validateClient
  * @methodOf BB.Directives:bbClientDetails
  * @description
  * Validate the client
  *
  * @param {object} client_form The client form
  * @param {string=} route A specific route to load
  ###
  $scope.validateClient = (client_form, route) =>
    $scope.notLoaded $scope
    $scope.existing_member = false

    # we need to validate teh client information has been correctly entered here
    if $scope.bb && $scope.bb.parent_client
      $scope.client.parent_client_id = $scope.bb.parent_client.id
    $scope.client.setClientDetails($scope.client_details)

    BBModel.Client.$create_or_update($scope.bb.company, $scope.client).then (client) =>
      $scope.setLoaded $scope
      $scope.setClient(client)
      $scope.client.setValid(true) if $scope.bb.isAdmin
      $scope.existing_member = false
      $scope.decideNextPage(route)
    , (err) -> handleError(err)

  ###**
  * @ngdoc method
  * @name clientLogin
  * @methodOf BB.Directives:bbClientDetails
  * @description
  * Client login
  ###
  $scope.clientLogin = () =>
    $scope.login_error = false
    if $scope.login
      LoginService.companyLogin($scope.bb.company, {}, {email: $scope.login.email, password: $scope.login.password}).then (client) =>
        $scope.setClient(new BBModel.Client(client))
        $scope.login_error = false
        $scope.decideNextPage()
      , (err) ->
        $scope.login_error = true
        $scope.setLoaded $scope
        AlertService.raise('LOGIN_FAILED');

  ###**
  * @ngdoc method
  * @name setReady
  * @methodOf BB.Directives:bbClientDetails
  * @description
  * Set this page section as ready - see {@link BB.Directives:bbPage Page Control}
  ###
  $scope.setReady = () =>
    $scope.client.setClientDetails($scope.client_details)

    if !$scope.suppress_client_create

      prom = BBModel.Client.$create_or_update($scope.bb.company, $scope.client)
      prom.then (client) =>
        $scope.setLoaded $scope
        $scope.setClient(client)
        if client.waitingQuestions
          client.gotQuestions.then () ->
            $scope.client_details = client.client_details
      , (err) -> handleError(err)
      return prom

    else

      return true

  ###**
  * @ngdoc method
  * @name clientSearch
  * @methodOf BB.Directives:bbClientDetails
  * @description
  * Client search
  ###
  $scope.clientSearch = () ->
    if $scope.client? && $scope.client.email? && $scope.client.email != ""
      $scope.notLoaded $scope
      BBModel.Client.$query_by_email($scope.bb.company, $scope.client.email).then (client) ->
        if client?
          $scope.setClient(client)
          $scope.client = client
        $scope.setLoaded $scope
      , (err) ->
        $scope.setLoaded $scope
    else
      $scope.setClient({})
      $scope.client = {}

  ###**
  * @ngdoc method
  * @name switchNumber
  * @methodOf BB.Directives:bbClientDetails
  * @description
  * Switch number
  *
  * @param {array} to Switch number to mobile
  ###
  $scope.switchNumber = (to) ->
    $scope.no_mobile = !$scope.no_mobile
    if to == 'mobile'
      $scope.bb.basket.setSettings({send_sms_reminder: true})
      $scope.client.phone = null
    else
      $scope.bb.basket.setSettings({send_sms_reminder: false})
      $scope.client.mobile = null

  ###**
  * @ngdoc method
  * @name getQuestion
  * @methodOf BB.Directives:bbClientDetails
  * @description
  * Get question by id
  *
  * @param {integer} id The id question
  ###
  $scope.getQuestion = (id) ->
    for question in $scope.client_details.questions
      return question if question.id == id

    return null

  ###**
  * @ngdoc method
  * @name useClient
  * @methodOf BB.Directives:bbClientDetails
  * @description
  * Use client by client
  *
  * @param {array} client The client
  ###
  $scope.useClient = (client) ->
    $scope.setClient(client)

  ###**
  * @ngdoc method
  * @name recalc_question
  * @methodOf BB.Directives:bbClientDetails
  * @description
  * Recalculate question
  ###
  $scope.recalc_question = () ->
    BBModel.Question.$checkConditionalQuestions($scope.client_details.questions) if $scope.client_details.questions

  handleError = (error) ->
    if error.data.error == "Please Login"
      $scope.existing_member = true
      AlertService.raise('ALREADY_REGISTERED')
    else if error.data.error == "Invalid Password"
      AlertService.raise('PASSWORD_INVALID')
    $scope.setLoaded $scope
