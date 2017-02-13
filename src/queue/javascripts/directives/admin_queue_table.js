angular.module('BBQueue').directive('bbAdminQueueTable', function(BBModel) {

  let link = function(scope, element, attrs) {
    if (!scope.fields) { scope.fields = ['ticket_number', 'first_name', 'last_name', 'email']; }
    if (scope.company) {
      return scope.getQueuers();
    } else {
      return BBModel.Admin.Company.$query(attrs).then(function(company) {
        scope.company = company;
        return scope.getQueuers();
      });
    }
  };

  return {
    link,
    controller: 'bbQueuers',
    templateUrl: 'queuer_table.html'
  };});
