angular.module('BBQueue').controller('bbQueueServers', function ($scope, $log,
                                                                 ModalForm, BBModel) {

    $scope.loading = true;

    $scope.getServers = () =>
        BBModel.Admin.Person.$query({company: $scope.company}).then(function (people) {
                $scope.all_people = people;
                $scope.servers = [];
                for (let person of Array.from($scope.all_people)) {
                    if (!person.queuing_disabled) {
                        $scope.servers.push(person);
                    }
                }
                $scope.loading = false;
                return $scope.updateQueuers();
            }
            , function (err) {
                $log.error(err.data);
                return $scope.loading = false;
            })
    ;


    $scope.setAttendance = function (person, status, estimated_duration) {
        $scope.loading = true;
        return person.setAttendance(status, estimated_duration).then(person => $scope.loading = false
            , function (err) {
                $log.error(err.data);
                return $scope.loading = false;
            });
    };

    // update all servers to make sure each one is shows as serving the right person
    $scope.$watch('queuers', (newValue, oldValue) => {
            return $scope.updateQueuers();
        }
    );

    $scope.updateQueuers = function () {
        if ($scope.queuers && $scope.servers) {
            let shash = {};
            for (let server of Array.from($scope.servers)) {
                server.serving = null;
                shash[server.self] = server;
            }
            return (() => {
                let result = [];
                for (let queuer of Array.from($scope.queuers)) {
                    let item;
                    if (queuer.$href('person') && shash[queuer.$href('person')] && (queuer.position === 0)) {
                        // currently being seen
                        item = shash[queuer.$href('person')].serving = queuer;
                    }
                    result.push(item);
                }
                return result;
            })();
        }
    };

    $scope.startServingQueuer = (person, queuer) =>
        queuer.startServing(person).then(() => $scope.getQueuers())
    ;

    $scope.finishServingQueuer = function (person) {
        person.finishServing();
        return $scope.getQueuers();
    };


    $scope.dropCallback = function (event, ui, queuer, $index) {
        console.log("dropcall");
        $scope.$apply(() => $scope.selectQueuer(null));
        return false;
    };

    $scope.dragStart = function (event, ui, queuer) {
        $scope.$apply(function () {
            $scope.selectDragQueuer(queuer);
            return $scope.selectQueuer(queuer);
        });
        console.log("start", queuer);
        return false;
    };

    return $scope.dragStop = function (event, ui) {
        console.log("stop", event, ui);
        $scope.$apply(() => $scope.selectQueuer(null));
        return false;
    };
});

