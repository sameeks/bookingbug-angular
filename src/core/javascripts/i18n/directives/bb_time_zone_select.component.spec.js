fdescribe('bbTimeZoneSelect component', () => {

    // let bbTimeZoneUtils = null;
    // let bbCustomTimeZones = null;
    // let options = null;
    // let $log = null;
    let parentScope = null;
    let element = null;

    beforeEach(() => {
        module('BB');
        module('BB.i18n');
    });

    function findIn(element, selector) {
        return angular.element(element[0].querySelector(selector));
    }

    beforeEach(inject(($compile, $rootScope) => {

        parentScope = $rootScope.$new();
        parentScope.format = '(GMT offset-hours) location (tz-code)';
        parentScope.hideToggle = false;

        element = angular.element('<bb-time-zone-select hide-toggle="true"></bb-time-zone-select>');
        $compile(element)(parentScope);

        parentScope.$digest();

    }));

    it('displays initial value of some attr', () => {

        const hideToggle = findIn(element, '.toggle-container');
        // console.info(angular.element(element)[0]);
        expect(hideToggle).toEqual('SOME_VALUE');

    });

    // beforeEach(() => {
    //     inject(($injector) => {
    //         bbTimeZoneUtils = $injector.get('bbTimeZoneUtils');
    //         bbCustomTimeZones = $injector.get('bbCustomTimeZones');
    //         $log = $injector.get('$log');
    //     });
    // });

});
