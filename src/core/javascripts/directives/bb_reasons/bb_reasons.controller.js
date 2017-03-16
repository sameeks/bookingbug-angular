(() => {

    angular
        .module('BB.Controllers')
        .controller('bbReasonsController', BBReasonsController);

    function BBReasonsController($scope, $rootScope, BBModel, ReasonService, LoadingService) {

        let init = () => {
            this.loader = LoadingService.$loader($scope);
            initReasons($scope.company.id);
        }

        let initReasons = (companyId) => {
            let options = {root: $scope.bb.api_url};

            BBModel.Company.$query(companyId, options).then((company) => {
                getReasons(company);
            });
        }

        let getReasons = (company) => {
            ReasonService.query(company).then((reasons) => {
                $scope.companyReasons = reasons;
                setCancelReasons();
                setMoveReasons();
            }, (err) => {
                this.loader.setLoadedAndShowError(err, 'Sorry, something went wrong retrieving reasons');
            });
        }

        let setCancelReasons = () => {
            // reason_type 3 === cancel reasons
            $scope.cancelReasons = _.filter($scope.companyReasons, r => r.reason_type === 3);
            $rootScope.$broadcast("booking:cancelReasonsLoaded", $scope.cancelReasons);
        }

        let setMoveReasons = () => {
             // reason_type 5 === move reasons
            $scope.moveReasons = _.filter($scope.companyReasons, r => r.reason_type === 5);
            $rootScope.$broadcast("booking:moveReasonsLoaded", $scope.moveReasons);
        }

        init();
    }}
)();
