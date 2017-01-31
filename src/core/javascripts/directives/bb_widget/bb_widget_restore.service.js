(function(){
    'use strict';

    angular.module('BB').service('bbWidgetRestore', BBWidgetRestore);

    function BBWidgetRestore($localStorage){

        var $scope = null;

        function setScope($s){
            $scope = $s;
        }

        function attemptRestore() {
            var state = $localStorage.getObject('bb');

            if(state != null){
                restore(state);
            }
        }

        function restore(state) {
            if(state.companyId != null){
                restoreCompany(state.companyId);
            }

            if(state.serviceId != null){
                restoreService(state.serviceId);
            }
        }

        function restoreCompany(companyId) {
            console.log('restoreCompany', companyId);
        }

        function restoreService(serviceId) {
            console.log('restoreService', serviceId);
        }

        return {
            setScope: setScope,
            attemptRestore: attemptRestore
        }

    }

})();
