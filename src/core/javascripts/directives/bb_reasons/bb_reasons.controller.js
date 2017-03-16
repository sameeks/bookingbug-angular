(() => {

    angular
        .module('BB.Controllers')
        .controller('bbReasonsController', BBReasonsController);

    function BBReasonsController($scope, $rootScope, BBModel, ReasonService, LoadingService, CompanyStoreService) {

        let init = () => {
            this.loader = LoadingService.$loader($scope);
            initReasons($scope.bb.company.id);
        }

        let initReasons = (companyId) => {
            let options = {root: $scope.bb.api_url};

            BBModel.Company.$query(companyId, options).then((company) => {
                ReasonService.query(company).then((reasons) => {
                    this.companyReasons = reasons;
                    setCancelReasons();
                    setMoveReasons();
                }, (err) => {
                    this.loader.setLoadedAndShowError(err, 'Sorry, something went wrong retrieving reasons');
                });
            });
        }


        let setCancelReasons = () => {
            // reason_type 3 === cancel reasons
            this.cancelReasons = _.filter(this.companyReasons, r => r.reason_type === 3);
            $scope.cancelReasons = this.cancelReasons;
            $rootScope.$broadcast("booking:cancelReasonsLoaded", this.cancelReasons);
        }

        let setMoveReasons = () => {
             // reason_type 5 === move reasons
            this.moveReasons = _.filter(this.companyReasons, r => r.reason_type === 5);
            CompanyStoreService.hasMoveReasons = true;
            $rootScope.$broadcast("booking:moveReasonsLoaded", this.moveReasons);
        }

        init();
    }}
)();
