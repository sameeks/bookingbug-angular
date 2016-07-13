###
* @ngdoc directive
* @name BBMember.directive:memberForm
* @scope
* @restrict E
*
* @description
* Member form, validates & submits a form that represents a member/client
*
* @param {string}    apiUrl              Expexts to be bled through the scope (MUST FIX)
* @param {object}    member              Member object
* @param {function}  onSuccessSave       On save success callback
* @param {function}  onFailSave          On save fail callback
* @param {function}  onValidationError   On validation fail callback
*
###
angular.module('BBMember').directive 'memberForm', ($modal, $log, $rootScope,
  MemberLoginService, MemberBookingService, AlertService, PathSvc) ->

    templateUrl: (el, attrs) ->
      if attrs.bbCustomMemberForm?
        PathSvc.directivePartial "_member_form"
      else
        PathSvc.directivePartial "_member_schema_form"
    scope:
      apiUrl: '@'
      member: '='
      onSuccessSave: '='
      onFailSave: '='
      onValidationError: '='
    link: (scope, element, attrs) ->

      $rootScope.bb ||= {}
      $rootScope.bb.api_url ||= attrs.apiUrl
      $rootScope.bb.api_url ||= "http://www.bookingbug.com"

      if attrs.bbCustomMemberForm?
        scope.custom_member_form = true

    controller: ($scope) ->

      $scope.loading = true

      $scope.$watch 'member', (member) ->
        if member?
          if member.$has('edit_member')
            member.$get('edit_member').then (member_schema) ->
              $scope.form = member_schema.form
              $scope.schema = member_schema.schema
              $scope.loading = false
          else if member.$has('edit')
            member.$get('edit').then (member_schema) ->
              $scope.form = member_schema.form
              $scope.schema = member_schema.schema
              $scope.loading = false

      $scope.submit = (form, data) ->
        # Required for the fields to validate themselves
        $scope.$broadcast('schemaFormValidate')

        if (form.$valid)
          $scope.loading = true
          # --------------------------------------------------------------------
          # member_schema form does not bind the question answers in
          # custom form elements to the Client.questions array of objects
          # but rather to the Client.q array of objects, so for example:
          # Client.q.1.answer <= INSTEAD OF => Client.questions[0].answer
          # So in that case we need to update answers in questions to match
          # the answers in q, so that if a user changes a custom form field
          # the new answer and not the old one will be sent to the api
          # --------------------------------------------------------------------
          if !$scope.custom_member_form
            for item in data.questions
              item.answer = data.q[item.id].answer

          $scope.member.$put('self', {}, data).then (member) ->
            $scope.loading = false
            AlertService.raise('UPDATE_SUCCESS')

            if typeof $scope.onSuccessSave == 'function'
              $scope.onSuccessSave()
          , (err) ->
            $scope.loading = false
            AlertService.raise('UPDATE_FAILED')

            if typeof $scope.onFailSave == 'function'
              $scope.onFailSave()
        else
          if typeof $scope.onValidationError == 'function'
              $scope.onValidationError()
