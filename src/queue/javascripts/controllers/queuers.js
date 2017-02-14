// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBQueue').controller('bbQueuers', function ($scope, $log,
                                                            AdminQueuerService, ModalForm, $interval) {

    $scope.loading = true;

    $scope.getQueuers = function () {
        let params =
            {company: $scope.company};
        return AdminQueuerService.query(params).then(function (queuers) {
                $scope.queuers = queuers;
                $scope.waiting_queuers = [];
                for (let queuer of Array.from(queuers)) {
                    queuer.remaining();
                    if (queuer.position > 0) {
                        $scope.waiting_queuers.push(queuer);
                    }
                }

                return $scope.loading = false;
            }
            , function (err) {
                $log.error(err.data);
                return $scope.loading = false;
            });
    };

    $scope.newQueuerModal = () =>
        ModalForm.new({
            company: $scope.company,
            title: 'New Queuer',
            new_rel: 'new_queuer',
            post_rel: 'queuers',
            success(queuer) {
                return $scope.queuers.push(queuer);
            }
        })
    ;


    // this is used to retrigger a scope check that will update service time
    return $interval(function () {
            if ($scope.queuers) {
                return Array.from($scope.queuers).map((queuer) =>
                    queuer.remaining());
            }
        }
        , 5000);
});

