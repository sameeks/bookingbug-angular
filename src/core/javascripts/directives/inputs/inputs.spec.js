// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
describe('cardSecurityCode', function () {
    let $compile = null;
    let $rootScope = null;
    let $scope = null;

    let setup = function () {
        module('BB');

        inject(function ($injector) {
            $compile = $injector.get('$compile');
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
        });

    };

    beforeEach(setup);

    it('should set maxlength to 4 for american express', function () {
        let scope = $rootScope.$new();
        let element = angular.element('<input type="number" card-security-code card-type="card_type"/>');
        $compile(element)(scope);
        scope.card_type = 'american_express';
        scope.$digest();
        return expect(element.attr('maxlength')).toBe('4');
    });

});
