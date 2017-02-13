// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBAdminEvents').directive('eventChainTable', function(BBModel, $log, ModalForm) {

  let controller = function($scope) {

    $scope.fields = ['id', 'name', 'description'];

    $scope.getEventChains = function() {
      let params =
        {company: $scope.company};
      return BBModel.Admin.EventChain.$query(params).then(event_chains => $scope.event_chains = event_chains);
    };

    $scope.newEventChain = () =>
      ModalForm.new({
        company: $scope.company,
        title: 'New Event Chain',
        new_rel: 'new_event_chain',
        post_rel: 'event_chains',
        success(event_chain) {
          return $scope.event_chains.push(event_chain);
        }
      })
    ;

    $scope.delete = function(id) {
      let event_chain = _.find($scope.event_chains, x => x.id === id);
      return event_chain.$del('self').then(() => $scope.event_chains = _.reject($scope.event_chains, x => x.id === id)
      , err => $log.error("Failed to delete event_chain"));
    };

    let editSuccess = function(updated) {
      updated.$flush('events');
      return $scope.event_chains = _.map($scope.event_chains, function(event_chain) {
        if (event_chain.id === updated.id) {
          return updated;
        } else {
          return event_chain;
        }
      });
    };

    return $scope.edit = function(id) {
      let event_chain = _.find($scope.event_chains, x => x.id === id);
      return event_chain.$get('events').then(collection =>
        collection.$get('events').then(function(events) {
          event_chain.events = events;
          return ModalForm.edit({
            model: event_chain,
            title: 'Edit Event Chain',
            success: editSuccess
          });
        })
      );
    };
  };

  let link = function(scope, element, attrs) {
    if (scope.company) {
      return scope.getEventChains();
    } else {
      return BBModel.Admin.Company.$query(attrs).then(function(company) {
        scope.company = company;
        return scope.getEventChains();
      });
    }
  };

  return {
    controller,
    link,
    templateUrl: 'event-chain-table/event_chain_table_main.html'
  };});

