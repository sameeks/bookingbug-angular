// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBAdminSettings').directive('adminTable', function($log,
  ModalForm, BBModel) {

  let controller = function($scope) {

    $scope.getAdministrators = function() {
      let params =
        {company: $scope.company};
      return BBModel.Admin.Administrator.$query(params).then(function(administrators) {
        $scope.admin_models = administrators;
        return $scope.administrators = _.map(administrators, administrator => _.pick(administrator, 'id', 'name', 'email', 'role'));
      });
    };

    $scope.newAdministrator = () =>
      ModalForm.new({
        company: $scope.company,
        title: 'New Administrator',
        new_rel: 'new_administrator',
        post_rel: 'administrators',
        success(administrator) {
          return $scope.administrators.push(administrator);
        }
      })
    ;

    return $scope.edit = function(id) {
      let admin = _.find($scope.admin_models, p => p.id === id);
      return ModalForm.edit({
        model: admin,
        title: 'Edit Administrator'
      });
    };
  };

  let link = function(scope, element, attrs) {
    if (scope.company) {
      return scope.getAdministrators();
    } else {
      return BBModel.Admin.Company.$query(attrs).then(function(company) {
        scope.company = company;
        return scope.getAdministrators();
      });
    }
  };

  return {
    controller,
    link,
    templateUrl: 'admin-table/admin_table_main.html'
  };});

