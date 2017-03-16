'use strict';

describe('BBAdminDashboard, bbTimeZone', function () {

    let bbTimeZone = null;

    let beforeEachFn = function () {
        module('BBAdminDashboard');
    };

    beforeEach(beforeEachFn);

    let injectDependencies = function () {
        inject(function ($injector) {
            bbTimeZone = $injector.get('bbTimeZone');
        });
    };

    describe('mapTimezoneForDisplay method', function () {

        let beforeEach2LvlFn = function () {
            injectDependencies();
        };

        beforeEach(beforeEach2LvlFn);

        it('should return timezone object with display and value properties', function () {
            let timezone = {
                display: '(UTC +00:00) London (GMT)',
                value: 'Europe/London'
            };
            expect(bbTimeZone.mapTimezoneForDisplay('Europe/London')).toEqual(timezone);
        });

        it('should return timezone object with id and order properties', function () {
            let timezone = {
                display: '(UTC +07:00) Krasnoyarsk (+07)',
                value: 'Asia/Krasnoyarsk',
                id: 1,
                order: [7, '+07', 'KRASNOYARSK']
            };
            expect(bbTimeZone.mapTimezoneForDisplay('Asia/Krasnoyarsk', 1)).toEqual(timezone);
        });

    });
});
