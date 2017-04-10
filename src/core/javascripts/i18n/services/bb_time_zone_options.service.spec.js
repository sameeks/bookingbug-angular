'use strict';

describe('BB.i18n, bbTimeZoneOptions', function () {

    let bbTimeZoneOptions = null;

    let beforeEachFn = function () {
        module('BB');
        module('BB.i18n');
    };

    beforeEach(beforeEachFn);

    let injectDependencies = function () {
        inject(function ($injector) {
            bbTimeZoneOptions = $injector.get('bbTimeZoneOptions');
        });
    };

    xdescribe('mapTimeZoneForDisplay method', function () { //TODO to fix

        let beforeEach2LvlFn = function () {
            injectDependencies();
        };

        beforeEach(beforeEach2LvlFn);

        it('should return timezone object with display and value properties', function () {

            let timezone = {
                display: '(UTC +00:00) London (GMT)',
                value: 'Europe/London'
            };
            expect(bbTimeZoneOptions.mapTimeZoneForDisplay('Europe/London')).toEqual(timezone);
        });

        it('should return timezone object with id and order properties', function () {
            let timezone = {
                display: '(UTC +07:00) Krasnoyarsk (+07)',
                value: 'Asia/Krasnoyarsk',
                id: 1,
                order: [7, '+07', 'KRASNOYARSK']
            };
            expect(bbTimeZoneOptions.mapTimeZoneForDisplay('Asia/Krasnoyarsk', 1)).toEqual(timezone);
        });

    });
});
