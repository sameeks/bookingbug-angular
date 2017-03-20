(() => {

    angular
        .module('BB.Directives')
        .directive('bbReasons', BBReasons);


    function BBReasons() {
        let directive = {
            controller: 'bbReasonsController',
            controllerAs: '$bbReasonsCtrl'
        }

        return directive;
    }


})();
