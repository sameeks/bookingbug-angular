describe('bbTe.blogArticle, BbTeBaListController', function () {
    let $controller = null;
    let $rootScope = null;

    let $scope = null;

    let setup = function () {
        module('bbTe.blogArticle');

        inject(function ($injector) {
            $controller = $injector.get('$controller');
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
        });

    };

    beforeEach(setup);

    return it('initialise controller', function () {
        $controller(
            'BbTeBaListController',
            {'$scope': $scope}
        );

    });
});


