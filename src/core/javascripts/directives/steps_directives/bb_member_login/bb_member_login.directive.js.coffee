'use strict'

angular.module('BB').directive 'bbMemberLogin', (PathSvc) ->
  restrict: 'A'
  controller: 'MemberLogin'
  templateUrl : (elem, attrs) ->
    if attrs.bbCustomLoginForm?
      PathSvc.directivePartial "_member_login_form"
    else
      PathSvc.directivePartial "_member_login_schema_form"
