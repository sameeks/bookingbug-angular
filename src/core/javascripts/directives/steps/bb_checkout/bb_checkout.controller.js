angular.module('BB.Controllers').controller('Checkout', function ($scope, $rootScope,
                                                                  $attrs, $q, $location, $window, $timeout, $bbug, FormDataStoreService,
                                                                  LoadingService, BBModel) {

    let loader = LoadingService.$loader($scope).notLoaded();

    $scope.options = $scope.$eval($attrs.bbCheckout) || {};

    // clear the form data store as we no longer need the data
    FormDataStoreService.destroy($scope);

    $rootScope.connection_started.then(() => {
            return $scope.checkout();
        }
    );

    $scope.checkout = function () {
        $scope.bb.basket.setClient($scope.client);
        if ($scope.options.no_notifications) {
            $scope.bb.no_notifications = $scope.options.no_notifications;
        }
        $scope.loadingTotal = BBModel.Basket.$checkout($scope.bb.company, $scope.bb.basket, {bb: $scope.bb});
        return $scope.loadingTotal.then(total => {
                $scope.total = total;

                // if no payment is required, route to the next step unless instructed otherwise
                if (!total.$has('new_payment')) {
                    $scope.$emit("checkout:success", total);
                    $scope.bb.total = $scope.total;
                    $scope.bb.payment_status = 'complete';
                    if (!$scope.options.disable_confirmation) {
                        $scope.skipThisStep();
                        $scope.decideNextPage();
                    } else {
                        // Reset ready for another booking
                        $scope.reset();
                    }
                }

                $scope.checkoutSuccess = true;
                return loader.setLoaded();
            }
            // currently just close the window and refresh the parent if we're in an admin popup
            , function (err) {
                loader.setLoadedAndShowError(err, 'Sorry, something went wrong');
                $scope.checkoutFailed = true;
                return $scope.$emit("checkout:fail", err);
            });
    };


    /***
     * @ngdoc method
     * @name print
     * @methodOf BB.Directives:bbCheckout
     * @description
     * Print booking details using print_purchase.html template
     *
     */
    // Deprecated - use window.print or $scope.printElement
    // Print booking details using print_purchase.html template
    $scope.print = () => {
        $window.open($scope.bb.partial_url + 'print_purchase.html?id=' + $scope.total.long_id, '_blank',
            'width=700,height=500,toolbar=0,menubar=0,location=0,status=1,scrollbars=1,resizable=1,left=0,top=0');
        return true;
    };

    /***
     * @ngdoc method
     * @name printElement
     * @methodOf BB.Directives:bbCheckout
     * @description
     * Print by creating popup containing the contents of the specified element
     *
     * @param {integer} id The id of the specified element
     * @param {string} stylesheet The stylesheet of popup
     */
    // Print by creating popup containing the contents of the specified element
    // TODO move print methods to a service
    return $scope.printElement = function (id, stylesheet) {
        let data = $bbug(`#${id}`).html();
        // window.open(URL,name,specs,replace)
        // IE8 fix: URL and name params are deliberately left as blank
        // http://stackoverflow.com/questions/710756/ie8-var-w-window-open-message-invalid-argument
        let mywindow = $window.open('', '', 'height=600,width=800');

        return $timeout(function () {
                mywindow.document.write('<html><head><title>Booking Confirmation</title>');

                if (stylesheet) {
                    mywindow.document.write(`<link rel="stylesheet" href="${stylesheet}" type="text/css" />`);
                }
                mywindow.document.write('</head><body>');
                mywindow.document.write(data);
                mywindow.document.write('</body></html>');
                //mywindow.document.close()

                return $timeout(function () {
                        mywindow.document.close();
                        // necessary for IE >= 10
                        mywindow.focus();
                        // necessary for IE >= 10
                        mywindow.print();
                        return mywindow.close();
                    }
                    , 100);
            }
            , 2000);
    };
});
