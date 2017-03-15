(() => {

    angular
        .module('BB.Controllers')
        .controller('bbMoveBookingController', MoveBooking);

        function MoveBooking($scope, $attrs, LoadingService, PurchaseBookingService, BBModel, WidgetModalService,
            $rootScope, AlertService, $translate, $timeout, ReasonService) {

            $rootScope.$on("purchase:loaded", (event, companyId) => {
                initReasons(companyId);
            });

            let init = () => {
                this.loader = LoadingService.$loader($scope);
                this.options = $scope.$eval($attrs.bbMoveBooking) || {};
            }

            this.initMove = function(booking, openInModal) {
                if(openInModal) {
                    openCalendarModal(booking);
                } else {
                    // check if booking is ready to be moved (datetime has been changed) - add method to basketItem model?
                    // update purchaseBooking
                    updateSingleBooking(booking);
                }

                // call different method when moving multiple bookings which POSTS to PurchaseService
            }

            let openCalendarModal = (booking) => {
                WidgetModalService.open({
                    company_id: booking.company_id,
                    template: 'main_view_booking',
                    total_id: booking.purchase_ref,
                    first_page: 'calendar'
                });
            }

            let updateSingleBooking = (booking) => {
                this.loader.notLoaded();

                if(!PurchaseBookingService.purchaseBookingIsMovable(booking)) {
                    this.loader.setLoaded();
                    AlertService.add('info', { msg: $translate.instant('PUBLIC_BOOKING.ITEM_DETAILS.MOVE_BOOKING_FAIL_ALERT')});

                    $timeout(() => {
                        AlertService.clear();
                    }, 5000);
                }

                else {

                    PurchaseBookingService.update(booking).then((purchaseBooking) => {
                        let booking = new BBModel.Purchase.Booking(purchaseBooking);
                        this.loader.setLoaded()

                        // update the $scope purchase to the newly updated purchaseBooking
                        $scope.bb.purchase = PurchaseBookingService.updatePurchaseBookingRef($scope.bb.purchase, booking);
                        resolveMove();
                    });
                }
            }

            let resolveMove = () => {
                $rootScope.$broadcast("booking:moved", $scope.bb.purchase);

                // isMemberDashboard property is defined when openCalendarModal method is called from memberBookings controller
                WidgetModalService.bookings = $scope.bb.purchase.bookings;

                // we dont want to close the modal when on the member or admin dashboard
                if(WidgetModalService.isMemberDashboard || $rootScope.user) {
                    $scope.decideNextPage('purchase');
                }
                else  {
                    WidgetModalService.close();
                }
            }

            let initReasons = (companyId) => {
                let options = {root: $scope.bb.api_url};

                BBModel.Company.$query(companyId, options).then((company) => {
                    if(company.$has("reasons")) {
                        getReasons(company).then((reasons) => {
                            setCancelReasons();
                            setMoveReasons();
                        });
                    }
                });

                this.cancelReasons = _.filter(this.companyReasons, r => r.reasonType === 3);
            }

            let getReasons = (company) => {
                ReasonService.query(company).then((reasons) => {
                    this.companyReasons = reasons;
                }, (err) => {
                    this.loader.setLoadedAndShowError(err, 'Sorry, something went wrong retrieving reasons');
                });
            }

            let setCancelReasons = () => {
                this.cancelReasons = _.filter(this.companyReasons, r => r.reason_type === 3);
                return this.cancelReasons;
            }

            let setMoveReasons = () => {
                this.moveReasons = _.filter(this.companyReasons, r => r.reason_type === 5);
                return this.moveReasons;
            }

            init();
        }
})();

