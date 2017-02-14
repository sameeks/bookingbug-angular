// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Controllers').controller('Summary', function ($scope, $rootScope, LoadingService, BBModel, $q) {

    $rootScope.connection_started.then(() => {
            $scope.item = $scope.bb.current_item;
            return $scope.items = $scope.bb.basket.timeItems();
        }
    );


    /***
     * @ngdoc method
     * @name confirm
     * @methodOf BB.Directives:bbSummary
     * @description
     * Submits the client and BasketItem to the API
     */
    return $scope.confirm = () => {

        let loader = LoadingService.$loader($scope).notLoaded();

        let promises = [
            BBModel.Client.$create_or_update($scope.bb.company, $scope.client),
        ];

        if ($scope.bb.current_item.service) {
            promises.push($scope.addItemToBasket());
        }

        return $q.all(promises).then(function (result) {
                let client = result[0];
                $scope.setClient(client);

                if (client.waitingQuestions) {
                    client.gotQuestions.then(() => $scope.client_details = client.client_details);
                }

                loader.setLoaded();
                return $scope.decideNextPage();
            }

            , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));
    };
});
