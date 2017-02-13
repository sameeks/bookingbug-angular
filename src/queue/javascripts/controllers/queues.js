// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
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

