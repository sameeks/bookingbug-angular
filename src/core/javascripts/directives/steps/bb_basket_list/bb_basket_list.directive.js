angular.module('BB.Directives').directive('bbBasketList', () => {
        return {
            restrict: 'AE',
            replace: true,
            scope: true,
            controller: 'BasketList'
        };
    }
);
