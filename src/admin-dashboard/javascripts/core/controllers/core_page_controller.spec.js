// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
describe('BBAdminDashboard, CorePageController', function () {
    let $controller = null;
    let $state = null;
    let company = null;

    let controllerInstance = null;
    let $scope = null;

    let companyMock = {
        timezone: 'Europe/London'
    };

    let beforeEachFn = function () {

        module('BBAdminDashboard');

        module(function ($provide) {
            $provide.value('company', companyMock);
        });

        inject(function ($injector) {
            $controller = $injector.get('$controller');
            $scope = $injector.get('$rootScope');
            $state = $injector.get('$state');
            company = $injector.get('company');
        });

        spyOn(moment.tz, 'setDefault');
        spyOn($state, 'includes');

        controllerInstance = $controller(
            'CorePageController', {
                '$scope': $scope,
                '$state': $state,
                'company': companyMock
            }
        );

        $scope.$apply();

    };

    beforeEach(beforeEachFn);

    it('defines "company" and "bb.company" properties on $scope', function () {
        expect($scope.company)
            .toBe(companyMock);

        expect($scope.bb.company)
            .toBe(companyMock);

    });

    it('uses company timezone globally', function () {
        expect(moment.tz.setDefault)
            .toHaveBeenCalledWith(company.timezone);
    });

    return it('defines isState function on $scope', function () {
        let testStateName = 'dashboard';

        $scope.isState(testStateName);

        expect($state.includes)
            .toHaveBeenCalledWith(testStateName);

    });
});
