angular.module('BB.Services').factory('AppService', $uibModalStack => {

        return {
            isModalOpen() {
                return !!$uibModalStack.getTop();
            }
        };
    }
);
