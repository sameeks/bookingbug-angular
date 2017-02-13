angular.module('BBAdmin.Directives').directive('bbAdminLogin', () =>

  ({
    restrict: 'AE',
    replace: true,
    scope: {
      onSuccess: '=',
      onCancel: '=',
      onError: '=',
      bb: '='
    },
    controller: 'AdminLogin',
    template: '<div ng-include="login_template"></div>'
  })
);


angular.module('BBAdmin.Controllers').controller('AdminLogin', function($scope,
  $rootScope, $q, $sessionStorage, BBModel) {

  $scope.login_data = {
    host: $sessionStorage.getItem('host'),
    email: null,
    password: null,
    selected_admin: null
  };

  $scope.login_template = 'login/admin_login.html';

  $scope.login = function() {
    $scope.alert = "";
    let params = {
      email: $scope.login_data.email,
      password: $scope.login_data.password
    };
    return BBModel.Admin.Login.$login(params).then(function(user) {
      if (user.company_id != null) {
        $scope.user = user;
        if ($scope.onSuccess) { return $scope.onSuccess(); }
      } else {
        return user.$getAdministrators().then(function(administrators) {
          $scope.administrators = administrators;
          return $scope.pickCompany();
        });
      }
    }
    , err => $scope.alert = "Sorry, either your email or password was incorrect");
  };

  $scope.pickCompany = () => $scope.login_template = 'login/admin_pick_company.html';

  return $scope.selectedCompany = function() {
    $scope.alert = "";
    let params = {
      email: $scope.login_data.email,
      password: $scope.login_data.password
    };
    return $scope.login_data.selected_admin.$post('login', {}, params).then(login =>
      $scope.login_data.selected_admin.$getCompany().then(function(company) {
        $scope.bb.company = company;
        BBModel.Admin.Login.$setLogin($scope.login_data.selected_admin);
        return $scope.onSuccess(company);
      })
    );
  };
});

