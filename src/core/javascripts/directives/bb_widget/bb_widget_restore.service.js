(function () {
    'use strict';

    angular.module('BB').service('bbWidgetRestore', BBWidgetRestore);

    function BBWidgetRestore($localStorage, halClient, $q, BBModel) {

        let $scope = null;
        let restorePromises = [];

        function setScope($s) {
            $scope = $s;
        }

        function attemptRestore() {
            var state = $localStorage.getObject('bb');

            if (state != null) {
                restore(state);
            }

            return $q.all(restorePromises)
        }

        function restore(state) {
            restoreService(state.serviceId);
            restorePerson(state.personId);
            restoreResource(state.resourceId);
            restoreCalendar(state.dateTime);
        }

        function restorePerson(personId) {
            if (personId == null) return;

            let personPromise = halClient.$get(
                `${$scope.bb.api_url}/api/v1/${$scope.bb.company.id}/people/${personId}`
            );

            restorePromises.push(personPromise);

            personPromise.then((person) => {
                console.info('person restored:', person.id);
                $scope.bb.current_item.person = new BBModel.Person(person);
                $scope.bb.current_item.setPerson($scope.bb.current_item.person);
            });
        }

        function restoreService(serviceId) {

            if (serviceId == null) return;

            let servicePromise = halClient.$get(
                `${$scope.bb.api_url}/api/v1/${$scope.bb.company.id}/services/${serviceId}`
            );

            restorePromises.push(servicePromise);

            servicePromise.then((service) => {
                console.info('service restored:', service.id);
                $scope.bb.current_item.service = new BBModel.Service(service);

                $scope.bb.current_item.setPrice($scope.bb.current_item.service.price);
                $scope.bb.current_item.setDuration($scope.bb.current_item.service.duration);
            });
        }

        function restoreResource(resourceId) {

            if (resourceId == null) return;

            let resourcePromise = halClient.$get(
                `${$scope.bb.api_url}/api/v1/${$scope.bb.company.id}/resources/${resourceId}`
            );

            restorePromises.push(resourcePromise);

            resourcePromise.then((resource) => {
                console.info('resource restored:', resource.id);
                $scope.bb.current_item.resource = new BBModel.Resource(resource);
            });
        }

        function restoreCalendar(dateTime) {

            if(dateTime == null) return;

            $scope.bb.current_item.setSlot({
                datetime: moment(dateTime)
            });
        }

        return {
            setScope: setScope,
            attemptRestore: attemptRestore
        }

    }

})();
