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
angular.module('BBMember').directive 'memberForm', ($modal, $log, $rootScope, MemberLoginService,MemberBookingService, AlertService) ->
    template: """
<form sf-schema="schema" name="memberForm" sf-form="form" sf-model="member"
  ng-submit="submit(memberForm, member)" ng-hide="loading"></form>
    """
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
