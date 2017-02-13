angular.module('BBQueue').controller('bbQueues', function($scope, $log,
    AdminQueueService, ModalForm) {

  $scope.loading = true;

  return $scope.getQueues = function() {
    let params =
      {company: $scope.company};
    return AdminQueueService.query(params).then(function(queues) {
      $scope.queues = queues;
      return $scope.loading = false;
    }
    , function(err) {
      $log.error(err.data);
      return $scope.loading = false;
    });
  };
});

