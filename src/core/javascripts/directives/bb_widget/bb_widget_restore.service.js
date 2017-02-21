(function(){
    'use strict';

    angular.module('BB').service('bbWidgetRestore', BBWidgetRestore);

    function BBWidgetRestore($localStorage, halClient, $q, BBModel){

        var $scope = null;
        var restorePromises = [];

        function setScope($s){
            $scope = $s;
        }

        function attemptRestore() {
            var state = $localStorage.getObject('bb');

            if(state != null){
                restore(state);
            }

            return $q.all(restorePromises)
        }

        function restore(state) {

            if(state.serviceId != null){
                restoreService(state.serviceId);
            }
        }

        function restoreService(serviceId) {

            var servicePromise = halClient.$get(
                $scope.bb.api_url + '/api/v1/' + $scope.bb.company.id + '/services/' + serviceId
            ); //TODO 1) admin ?? 2) item_defaults ??

            console.log('restoreService', serviceId);

            restorePromises.push(servicePromise);

            servicePromise.then(function(service){
                $scope.bb.current_item.service = new BBModel.Service(service);

            });

        }

        return {
            setScope: setScope,
            attemptRestore: attemptRestore
        }

    }

})();
