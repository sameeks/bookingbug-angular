let QueueServerController = ($scope, BBModel, CheckSchema) => {

    $scope.getQueuers = function() {
        $scope.booking = null;
        return $scope.person.$get('queuers').then(function(response) {
            response.$get('queuers').then(function(collection) {
                let queuers = _.map(collection, (queuer) => new BBModel.Admin.Queuer(queuer));
                $scope.queuers = queuers;
                return (() => {
                    let result = [];
                    for (let queuer of Array.from(queuers)) {
                        let item;
                        if ((queuer.person_id === $scope.person.id) && (queuer.position === 0)) {
                            $scope.person.serving = queuer;
                            item = queuer.$get("booking").then(function(booking) {
                                $scope.booking = new BBModel.Admin.Booking(booking);
                                if ($scope.booking.$has('edit')) {
                                    return $scope.booking.$get('edit').then(function(schema) {
                                        $scope.form = _.reject(schema.form, x => x.type === 'submit');
                                        $scope.schema = CheckSchema(schema.schema);
                                        $scope.form_model = $scope.booking;
                                        return $scope.loading = false;
                                    });
                                }
                            });
                        }
                        result.push(item);
                    }
                    return queuers;
                })();
            });
        });
    };

    $scope.getQueuers = _.throttle($scope.getQueuers, 10000);

    $scope.newQueuerModal = () =>
        ModalForm.new({
            company: $scope.company,
            title: 'New Queuer',
            new_rel: 'new_queuer',
            post_rel: 'queuers',
            success(queuer) {
                return $scope.person.queuers.push(queuer);
            }
        })
      ;

    $scope.setAttendance = function(person, status, duration) {
        $scope.loading = true;
        return person.setAttendance(status, duration).then(person => $scope.loading = false
        , function(err) {
            $log.error(err.data);
            return $scope.loading = false;
        });
    };

    $scope.serveCustomer = function(queuer) {
        $scope.loading = true;
        return $scope.person.startServing(queuer).then(function() {
            $scope.loading = false;
            return $scope.getQueuers();
        });
    };

    $scope.serveNext = function() {
        $scope.loading = true;
        return $scope.person.startServing().then(function() {
            $scope.loading = false;
            return $scope.getQueuers();
        });
    };

    $scope.extendAppointment = function(mins) {
        $scope.loading = true;
        return $scope.person.serving.extendAppointment(mins).then(function() {
            $scope.loading = false;
            return $scope.getQueuers();
        });
    };

    $scope.finishServing = function() {
        $scope.loading = true;
        return $scope.person.finishServing().then(function() {
            $scope.loading = false;
            return $scope.getQueuers();
        });
    };


    $scope.updateAndFinishServing = () =>
              $scope.booking.$put('self', {}, $scope.booking)().then(() => $scope.finishServing());

    return $scope.returnToQueue = function(queue, position) {
        $scope.loading = true;
        return $scope.person.serving.$put('return_to_queue', {queue: queue.id, position}).then(function(result) {
            $scope.loading = false;
            return $scope.getQueuers();
        });
    };
}

angular.module('BBQueue.controllers').controller('bbQueueServer', QueueServerController);
