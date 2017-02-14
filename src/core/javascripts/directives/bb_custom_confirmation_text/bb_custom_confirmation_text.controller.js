// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Controllers').controller('CustomConfirmationText', function ($scope, $rootScope, CustomTextService, $q, LoadingService) {
    let loader = LoadingService.$loader($scope).notLoaded();

    $rootScope.connection_started.then(() => $scope.loadData()
        , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));

    /***
     * @ngdoc method
     * @name loadData
     * @methodOf BB.Directives:bbCustomBookingText
     * @description
     * Load data and display a text message
     */
    return $scope.loadData = () => {

        if ($scope.total) {

            return CustomTextService.confirmationText($scope.bb.company, $scope.total).then(function (msgs) {
                    $scope.messages = msgs;
                    return loader.setLoaded();
                }
                , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));

        } else if ($scope.loadingTotal) {

            return $scope.loadingTotal.then(total =>
                    CustomTextService.confirmationText($scope.bb.company, total).then(function (msgs) {
                            $scope.messages = msgs;
                            return loader.setLoaded();
                        }
                        , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'))

                , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));

        } else {
            return loader.setLoaded();
        }
    };
});
