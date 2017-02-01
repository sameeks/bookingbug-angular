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
            if(state.companyId != null && state.companyId != $scope.bb.company.id){
                restoreCompany(state.companyId);
            }

            if(state.serviceId != null){
                restoreService(state.serviceId);
            }
        }

        function restoreCompany(companyId) {

            var prms = {
                company_id: companyId,
                item_defaults: $scope.bb.item_defaults
            };

            console.log('restoreCompany', companyId);

            $scope.initWidget(prms);
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
