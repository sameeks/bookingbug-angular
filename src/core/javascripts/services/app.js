// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Services').factory('AppService', $uibModalStack => {

        return {
            isModalOpen() {
                return !!$uibModalStack.getTop();
            }
        };
    }
);
