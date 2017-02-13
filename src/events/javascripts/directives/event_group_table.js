angular.module('BBAdminEvents').directive('eventGroupTable', function(BBModel, $log, ModalForm) {

  let controller = function($scope) {

    $scope.getEventGroups = function() {
      let params =
        {company: $scope.company};
      return BBModel.Admin.EventGroup.$query(params).then(function(event_groups) {
        $scope.event_groups_models = event_groups;
        return $scope.event_groups = _.map(event_groups, event_group => _.pick(event_group, 'id', 'name', 'mobile'));
      });
    };

    $scope.newEventGroup = () =>
      ModalForm.new({
        company: $scope.company,
        title: 'New Event Group',
        new_rel: 'new_event_group',
        post_rel: 'event_groups',
        success(event_group) {
          return $scope.event_groups.push(event_group);
        }
      })
    ;

    $scope.delete = function(id) {
      let event_group = _.find($scope.event_groups_models, p => p.id === id);
      return event_group.$del('self').then(() => $scope.event_groups = _.reject($scope.event_groups, p => p.id === id)
      , err => $log.error("Failed to delete event_group"));
    };

    return $scope.edit = function(id) {
      let event_group = _.find($scope.event_groups_models, p => p.id === id);
      return ModalForm.edit({
        model: event_group,
        title: 'Edit Event Group'
      });
    };
  };

  let link = function(scope, element, attrs) {
    if (scope.company) {
      return scope.getEventGroups();
    } else {
      return BBModel.Admin.Company.$query(attrs).then(function(company) {
        scope.company = company;
        return scope.getEventGroups();
      });
    }
  };

  return {
    controller,
    link,
    templateUrl: 'event-chain-table/event_group_table_main.html'
  };});

