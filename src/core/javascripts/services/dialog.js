// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Services').factory('Dialog', function ($uibModal, $log, $document) {

    let controller = function ($scope, $uibModalInstance, model, title, success, fail, body) {

        $scope.body = body;
        $scope.title = title;

        $scope.ok = () => $uibModalInstance.close(model);

        $scope.cancel = function () {
            event.preventDefault();
            event.stopPropagation();
            return $uibModalInstance.dismiss('cancel');
        };

        return $uibModalInstance.result.then(function () {
                if (success) {
                    return success(model);
                }
            }
            , function () {
                if (fail) {
                    return fail();
                }
            });
    };

    return {
        confirm(config) {
            let templateUrl;
            if (config.templateUrl) {
                ({templateUrl} = config);
            }
            if (!templateUrl) {
                templateUrl = 'dialog.html';
            }
            return $uibModal.open({
                templateUrl,
                controller,
                size: config.size || 'sm',
                resolve: {
                    model() {
                        return config.model;
                    },
                    title() {
                        return config.title;
                    },
                    success() {
                        return config.success;
                    },
                    fail() {
                        return config.fail;
                    },
                    body() {
                        return config.body;
                    }
                }
            });
        }
    };
});

