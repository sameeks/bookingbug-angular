(() => {

    angular
        .module('BB.Controllers')
        .controller('bbReasonsController', BBReasonsController);

    function BBReasonsController($scope, $rootScope, BBModel, ReasonService, LoadingService) {

        $rootScope.$on("purchase:loaded", (event, companyId) => {
            initReasons(companyId);
        });

        let init = () => {
            this.loader = LoadingService.$loader($scope);
        }

        let initReasons = (companyId) => {
            let options = {root: $scope.bb.api_url};

            BBModel.Company.$query(companyId, options).then((company) => {
                getReasons(company).then((reasons) => {
                    setCancelReasons();
                    setMoveReasons();
                });
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
            cancelReasons = _.filter(this.companyReasons, r => r.reason_type === 3);
            $rootScope.$broadcast("booking:cancelReasonsLoaded", cancelReasons);
        }

        let setMoveReasons = () => {
            moveReasons = _.filter(this.companyReasons, r => r.reason_type === 5);
            $rootScope.$broadcast("booking:moveReasonsLoaded", moveReasons);
        }

        init();
    }}
)();
