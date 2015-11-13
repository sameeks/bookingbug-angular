angular.module('BBMember').directive 'memberForm', ($modal, $log, $rootScope, MemberLoginService,MemberBookingService, AlertService) ->
    template: """
<form sf-schema="schema" sf-form="form" sf-model="member"
  ng-submit="submit(member)" ng-hide="loading"></form>
    """
    scope:
      apiUrl: '@'
      member: '='
    link: (scope, element, attrs) ->

      $rootScope.bb ||= {}
      $rootScope.bb.api_url ||= attrs.apiUrl
      $rootScope.bb.api_url ||= "http://www.bookingbug.com"

    controller: ($scope) ->

      $scope.loading = true

      $scope.$watch 'member', (member) ->
        if member?
          member.$get('edit_member').then (member_schema) ->
            $scope.form = member_schema.form
            $scope.schema = member_schema.schema
            $scope.loading = false

      $scope.submit = (form) ->
        $scope.loading = true
        $scope.member.$put('self', {}, form).then (member) ->
          $scope.loading = false
          AlertService.raise('UPDATE_SUCCESS')
        , (err) ->
          $scope.loading = false
          AlertService.raise('UPDATE_FAILED')
