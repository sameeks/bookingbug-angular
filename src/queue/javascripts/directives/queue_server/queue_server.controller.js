let QueueServerController = ($scope) => {

    $scope.getQueuers = function() {
        $scope.booking = null;
        return $scope.person.getQueuers().then(function(queuers) {
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
                                    $scope.schema = checkSchema(schema.schema);
                                    $scope.form_model = $scope.booking;
                                    return $scope.loading = false;
                                });
                            }
                        });
                    }
                    result.push(item);
                }
                return result;
            })();
        });
    };

    // THIS IS CRUFTY AND SHOULD BE REMOVE WITH AN API UPDATE THAT TIDIES UP THE SCEMA RESPONE
    // fix the issues we have with the the sub client and question blocks being in doted notation, and not in child objects
    var checkSchema = function(schema) {
        for (let k in schema.properties) {
            let v = schema.properties[k];
            let vals = k.split(".");
            if ((vals[0] === "questions") && (vals.length > 1)) {
                if (!schema.properties.questions) {
                    schema.properties.questions = {type: "object", properties: {} };
                }
                if (!schema.properties.questions.properties[vals[1]]) {
                    schema.properties.questions.properties[vals[1]] = {type: "object", properties: {answer: v} };
                }
            }
            if ((vals[0] === "client") && (vals.length > 2)) {
                if (!schema.properties.client) {
                    schema.properties.client = {type: "object", properties: {q: {type: "object", properties: {}}} };
                }
                if  (schema.properties.client.properties) {
                    if (!schema.properties.client.properties.q.properties[vals[2]]) {
                        schema.properties.client.properties.q.properties[vals[2]] = {type: "object", properties: {answer: v} };
                    }
                }
            }
        }
        return schema;
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
