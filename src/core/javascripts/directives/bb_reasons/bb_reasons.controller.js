(() => {

    angular
        .module('BB.Controllers')
        .controller('bbReasonsController', BBReasonsController);

    function BBReasonsController($scope, $rootScope, BBModel, ReasonService, LoadingService, CompanyStoreService) {

        this.init = () => {
            this.loader = LoadingService.$loader($scope);
            this.initReasons($scope.bb.company_id);
        }

        this.initReasons = (companyId) => {
            let options = {root: $scope.bb.api_url};

            BBModel.Company.$query(companyId, options).then((company) => {
                ReasonService.query(company).then((reasons) => {
                    this.companyReasons = reasons;
                    this.setCancelReasons();
                    this.setMoveReasons();
                }, (err) => {
                    console.log('Reasons are not configured for this company')
                    this.loader.setLoaded();
                });
            });
        }

        this.setCancelReasons = () => {
            // reason_type 3 === cancel reasons
            this.cancelReasons = _.filter(this.companyReasons, r => r.reason_type === 3);
            $rootScope.$broadcast('booking:cancelReasonsLoaded', this.cancelReasons);
        }

        this.setMoveReasons = () => {
             // reason_type 5 === move reasons
            this.moveReasons = _.filter(this.companyReasons, r => r.reason_type === 5);
            CompanyStoreService.hasMoveReasons = true;
            $rootScope.$broadcast('booking:moveReasonsLoaded', this.moveReasons);
        }

        this.init();
    }}
)();
