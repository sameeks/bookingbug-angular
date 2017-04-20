angular.module('BBQueue.services').factory('adminQueueLoading', () => {
    let loadingServerInProgress = false;
    return {
        isLoadingServerInProgress: function () {
            return loadingServerInProgress;
        },
        setLoadingServerInProgress: function (bool) {
            loadingServerInProgress = bool;
        }
    }
});