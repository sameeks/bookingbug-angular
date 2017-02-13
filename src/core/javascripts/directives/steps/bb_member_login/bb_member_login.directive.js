angular.module('BB').directive('bbMemberLogin', PathSvc =>
  ({
    restrict: 'A',
    controller: 'MemberLogin',
    templateUrl(elem, attrs) {
      if (attrs.bbCustomLoginForm != null) {
        return PathSvc.directivePartial("_member_login_form");
      } else {
        return PathSvc.directivePartial("_member_login_schema_form");
      }
    }
  })
);
