angular.module('BBQueue.services').factory('AdminQueueLoading', () => {
    let loadingServerInProgress = false;
    return {
        getLoadingServerInProgress: function () {
            return loadingServerInProgress;
        },
        setLoadingServerInProgress: function (bool) {
            loadingServerInProgress = bool;
        }
    }
});