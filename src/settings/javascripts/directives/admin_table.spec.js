// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
describe('BBAdminSettings, adminTable directive', function () {
    let $rootScope = null;
    let $scope = null;

    let setup = function () {
        module('BBAdminBooking');
        module('BBAdminSettings');

        inject(function ($injector) {
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
        });

    };

    beforeEach(setup);

    it('dummy test', () =>
        expect(true)
            .toBe(true)
    );

});
