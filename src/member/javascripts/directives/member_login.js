angular.module('BBMember').directive('loginMember', function($uibModal, $document, $log,
  $rootScope, MemberLoginService, $templateCache, $q, $sessionStorage, halClient
) {

  let loginMemberController = function($scope, $uibModalInstance, company_id) {
    $scope.title = 'Login';
    $scope.schema = {
      type: 'object',
      properties: {
        email: { type: 'string', title: 'Email' },
        password: { type: 'string', title: 'Password' }
      }
    };
    $scope.form = [{
      key: 'email',
      type: 'email',
      feedback: false,
      autofocus: true
    },{
      key: 'password',
      type: 'password',
      feedback: false
    }];
    $scope.login_form = {};

    $scope.submit = function(form) {
      let options =
        {company_id};
      return MemberLoginService.login(form, options).then(function(member) {
        member.email = form.email;
        member.password = form.password;
        return $uibModalInstance.close(member);
      }
      , err => $uibModalInstance.dismiss(err));
    };

    return $scope.cancel = () => $uibModalInstance.dismiss('cancel');
  };


  let pickCompanyController = function($scope, $uibModalInstance, companies) {
    let c;
    $scope.title = 'Pick Company';
    $scope.schema = {
      type: 'object',
      properties: {
        company_id: { type: 'integer', title: 'Company' }
      }
    };
    $scope.schema.properties.company_id.enum = ((() => {
      let result = [];
      for (c of Array.from(companies)) {         result.push(c.id);
      }
      return result;
    })());
    $scope.form = [{
      key: 'company_id',
      type: 'select',
      titleMap: ((() => {
        let result1 = [];
        for (c of Array.from(companies)) {           result1.push({value: c.id, name: c.name});
        }
        return result1;
      })()),
      autofocus: true
    }];
    $scope.pick_company_form = {};

    $scope.submit = form => $uibModalInstance.close(form.company_id);

    return $scope.cancel = () => $uibModalInstance.dismiss('cancel');
  };


  let link = function(scope, element, attrs) {
    if (!$rootScope.bb) { $rootScope.bb = {}; }
    if (!$rootScope.bb.api_url) { $rootScope.bb.api_url = scope.apiUrl; }
    if (!$rootScope.bb.api_url) { $rootScope.bb.api_url = "http://www.bookingbug.com"; }

    var loginModal = function() {
      let modalInstance = $uibModal.open({
        templateUrl: 'login_modal_form.html',
        controller: loginMemberController,
        resolve: {
          company_id() { return scope.companyId; }
        }
      });
      return modalInstance.result.then(function(result) {
        scope.memberEmail = result.email;
        scope.memberPassword = result.password;
        if (result.$has('members')) {
          return result.$get('members').then(function(members) {
            scope.members = members;
            return $q.all(Array.from(members).map((m) => m.$get('company'))).then(companies => pickCompanyModal(companies));
          });
        } else {
          return scope.member = result;
        }
      }
      , () => loginModal());
    };

    var pickCompanyModal = function(companies) {
      let modalInstance = $uibModal.open({
        templateUrl: 'pick_company_modal_form.html',
        controller: pickCompanyController,
        resolve: {
          companies() { return companies; }
        }
      });
      return modalInstance.result.then(function(company_id) {
        scope.companyId = company_id;
        return tryLogin();
      }
      , () => pickCompanyModal());
    };

    var tryLogin = function() {
      let login_form = {
        email: scope.memberEmail,
        password: scope.memberPassword
      };
      let options =
        {company_id: scope.companyId};
      return MemberLoginService.login(login_form, options).then(function(result) {
        if (result.$has('members')) {
          return result.$get('members').then(function(members) {
            scope.members = members;
            return $q.all(Array.from(members).map((m) => m.$get('company'))).then(companies => pickCompanyModal(companies));
          });
        } else {
          return scope.member = result;
        }
      }
      , err => loginModal());
    };


    if (scope.memberEmail && scope.memberPassword) {
      return tryLogin();
    } else if ($sessionStorage.getItem("login")) {
      let session_member = $sessionStorage.getItem("login");
      session_member = halClient.createResource(session_member);
      return scope.member = session_member;
    } else {
      return loginModal();
    }
  };

  return {
    link,
    scope: {
      memberEmail: '@',
      memberPassword: '@',
      companyId: '@',
      apiUrl: '@',
      member: '='
    },
    transclude: true,
    template: `\
<div ng-show='member' ng-transclude></div>\
`
  };});

