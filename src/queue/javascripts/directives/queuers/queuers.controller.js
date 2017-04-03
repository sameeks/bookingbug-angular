let QueuersController = ($scope, $log, AdminQueuerService, AdminQueueService, ModalForm, $interval,
    $q, BBModel) => {

    $scope.loading = true;

    $scope.getQueuers = function() {
        if ($scope.waiting_for_queuers) {
            return;
        }
        $scope.waiting_for_queuers = true;
        let params = {company: $scope.company};

        let proms = [];
        let queuer_prom = AdminQueuerService.query(params);
        proms.push(queuer_prom);
        queuer_prom.then(queuers =>
            $scope.new_queuers = queuers
        , function(err) {
            $scope.waiting_for_queuers = false;
            $log.error(err.data);
            return $scope.loading = false;
        });

        let queue_prom = AdminQueueService.query(params);
        proms.push(queue_prom);
        queue_prom.then(queues => $scope.new_queues = queues);

        let queuingAndAppointments = true;
        if (queuingAndAppointments) { // we should add a flag it to see fi the are doing queueing and booking together so this can be optimised
            let bookings_prom = $scope.getAppointments(null, null, null, null, null, true);
            proms.push(bookings_prom);
            bookings_prom.then(bookings => $scope.bookings = bookings);
        } else {
            $scope.bookings = [];
        }

        return $q.all(proms).then(function() {
            $scope.queuers = $scope.new_queuers;
            $scope.queues = $scope.new_queues;
            $scope.waiting_queuers = [];
            for (var queuer of Array.from($scope.queuers)) {
                queuer.remaining();
                if (queuer.position > 0) {
                    $scope.waiting_queuers.push({type: "Q", data: queuer, position: queuer.position});
                }
            }

            for (let booking of Array.from($scope.bookings)) {
                if ((booking.status === 4) && !booking.hasStatus('being_seen') && !booking.hasStatus('no_show')) {
                    if (booking.settings.queue_position) {
                        $scope.waiting_queuers.push({type: "B", data: booking, position: booking.settings.queue_position});
                    } else {
                        $scope.waiting_queuers.push({type: "B", data: booking, position: 100});
                    }
                }
            }

            $scope.waiting_queuers = _.sortBy($scope.waiting_queuers, x => x.position);
            $scope.waiting_for_queuers = false;

            for (let q of Array.from($scope.queues)) {
                q.waiting_queuers = [];
                for (queuer of Array.from($scope.waiting_queuers)) {
                    if (((queuer.type === "Q") && (queuer.data.client_queue_id === q.id)) || (queuer.type === "B")) {
                        q.waiting_queuers.push(queuer);
                    }
                }
                q.waiting_queuers = _.sortBy(q.waiting_queuers, x => x.position);
            }

            return $scope.loading = false;
        }, function(err) {
            $scope.waiting_for_queuers = false;
            $log.error(err.data);
            return $scope.loading = false;
        });
    };


    $scope.getAppointments = function(currentPage, filterBy, filterByFields, orderBy,
        orderByReverse, skipCache) {

        if (skipCache == null) {
            skipCache = true;
        }
        if (filterByFields && (filterByFields.name != null)) {
            filterByFields.name = filterByFields.name.replace(/\s/g, '');
        }
        if (filterByFields && (filterByFields.mobile != null)) {
            let { mobile } = filterByFields;
            if (mobile.indexOf('0') === 0) {
                filterByFields.mobile = mobile.substring(1);
            }
        }
        let defer = $q.defer();
        let params = {
            company: $scope.company,
            date: moment().format('YYYY-MM-DD'),
            url: $scope.bb.api_url
        };

        if (skipCache) {
            params.skip_cache = true;
        }
        if (filterBy) {
            params.filter_by = filterBy;
        }
        if (filterByFields) {
            params.filter_by_fields = filterByFields;
        }
        if (orderBy) {
            params.order_by = orderBy;
        }
        if (orderByReverse) {
            params.order_by_reverse = orderByReverse;
        }

        BBModel.Admin.Booking.$query(params).then(res => {
            let bookings = [];
            for (let item of Array.from(res.items)) {
                if (item.status !== 3) { // not blocked
                    bookings.push(item);
                }
            }
            return defer.resolve((bookings));
        }, err => defer.reject(err));
        return defer.promise;
    };

    $scope.setStatus = (booking, status) => {
        let clone = _.clone(booking);
        clone.current_multi_status = status;
        return booking.$update(clone).then(res => {
            $scope.getQueuers()
        }, (err) => {
            AlertService.danger({msg: 'Something went wrong'});
        });
    };

    $scope.newQueuerModal = () => {
        ModalForm.new({
            company: $scope.company,
            title: 'New Queuer',
            new_rel: 'new_queuer',
            post_rel: 'queuers',
            success(queuer) {
                return $scope.queuers.push(queuer);
            }
        });
    }

    $scope.getQueuers();

    // this is used to retrigger a scope check that will update service time
    return $interval(function() {
        if ($scope.queuers) {
            return Array.from($scope.queuers).map((queuer) => queuer.remaining());
        }
    }, 5000);
}

angular.module('BBQueue.controllers').controller('bbQueuers', QueuersController);
