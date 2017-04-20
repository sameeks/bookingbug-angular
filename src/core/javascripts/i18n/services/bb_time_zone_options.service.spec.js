describe('bbTimeZoneOptions service', () => {

    let bbTimeZoneOptions = null;
    let bbCustomTimeZones = null;
    let bbTimeZone = null;
    let options = null;
    let $log = null;

    beforeEach(() => {
        module('BB');
        module('BB.i18n');
    });

    beforeEach(() => {
        inject(($injector) => {
            bbTimeZoneOptions = $injector.get('bbTimeZoneOptions');
            bbTimeZone = $injector.get('bbTimeZone');
            bbCustomTimeZones = $injector.get('bbCustomTimeZones');
            $log = $injector.get('$log');
        });
    });

    const setCustomTzOptions = (opts) => {

        options = {
            timeZones: [],
            displayFormat: null,
            useMomentNames: false,
            filters: {}
        };

        return Object.assign({}, options, opts);

    };

    describe('composeTimeZoneList()', function () {

        describe('loading timezone', function () {
            it('should load custom timezone keys', function () {

                options = setCustomTzOptions({
                    useMomentNames: false
                });

                const timeZones = bbTimeZoneOptions.fn.loadTimeZoneKeys(options).timeZones;
                expect(timeZones).toEqual(Object.keys(bbCustomTimeZones.GROUPED_TIME_ZONES));

            });

            it('should load moment timezone keys', function () {

                options = setCustomTzOptions({
                    useMomentNames: true
                });

                const momentTimeZones = ['Africa/Abidjan', 'Africa/Accra', 'Africa/Addis_Ababa', 'Africa/Algiers', 'Africa/Asmara'];
                spyOn(moment.tz, 'names').and.returnValue(momentTimeZones);

                const timeZones = bbTimeZoneOptions.fn.loadTimeZoneKeys(options).timeZones;

                expect(moment.tz.names).toHaveBeenCalled();
                expect(timeZones).toEqual(momentTimeZones);

            });

            it('should clean moment timezone keys', function () {

                options = setCustomTzOptions({
                    useMomentNames: true
                });

                const momentTimeZones = ['PST8PDT', 'NZ-CHAT', 'Asia/Tokyo', 'Etc/GMT', 'Etc/GMT+2', 'CET', 'Africa/Asmara'];
                spyOn(moment.tz, 'names').and.returnValue(momentTimeZones);

                const timeZones = bbTimeZoneOptions.fn.loadTimeZoneKeys(options).timeZones;

                expect(moment.tz.names).toHaveBeenCalled();
                expect(timeZones).toContain('Asia/Tokyo');
                expect(timeZones).toContain('Africa/Asmara');
                expect(timeZones.length).toEqual(2);

            });

            it('should find correct key when using custom timezones', function () {

                options = setCustomTzOptions({
                    timeZones: Object.keys(bbCustomTimeZones.GROUPED_TIME_ZONES),
                    useMomentNames: false,
                    filters: {
                        limitTimeZonesBy: ['Osaka', 'Berlin', 'New York'],
                        excludeTimeZonesBy: ['Sydney', 'Sofia']
                    }
                });

                const findFilters = bbTimeZoneOptions.fn.findFilterKeysInCustomList(options);
                const limitTimeZonesBy = findFilters.filters.limitTimeZonesBy;
                const excludeTimeZonesBy = findFilters.filters.excludeTimeZonesBy;

                expect(limitTimeZonesBy).toEqual(['Asia/Tokyo', 'Europe/Amsterdam', 'America/New_York']);
                expect(excludeTimeZonesBy).toEqual(['Australia/Canberra', 'Europe/Helsinki']);

            });

            it('should add browserTimeZone if missing from timezone list', function () {

                options = setCustomTzOptions({
                    timeZones: ['Australia/Canberra', 'Europe/Helsinki'],
                    useMomentNames: true
                });

                spyOn(moment.tz, 'guess').and.returnValue('Europe/Berlin');

                const timeZones = bbTimeZoneOptions.fn.ensureBrowserTimeZoneExists(options).timeZones;

                expect(moment.tz.guess).toHaveBeenCalled();
                expect(timeZones).toContain('Europe/Berlin');

            });

            it('should add company timezone if missing from timezone list', function () {

                options = setCustomTzOptions({
                    timeZones: ['Australia/Canberra', 'Europe/Helsinki'],
                    useMomentNames: true
                });

                spyOn(bbTimeZone, 'getCompanyTimeZone').and.returnValue('Europe/Berlin');

                const timeZones = bbTimeZoneOptions.fn.ensureCompanyTimeZoneExists(options).timeZones;

                expect(bbTimeZone.getCompanyTimeZone).toHaveBeenCalled();
                expect(timeZones).toContain('Europe/Berlin');

            });

            it('should add display timezone if missing from timezone list', function () {

                options = setCustomTzOptions({
                    timeZones: ['Australia/Canberra', 'Europe/Helsinki'],
                    useMomentNames: true
                });

                spyOn(bbTimeZone, 'getDisplayTimeZone').and.returnValue('Europe/Berlin');

                const timeZones = bbTimeZoneOptions.fn.ensureDisplayTimeZoneExists(options).timeZones;

                expect(bbTimeZone.getDisplayTimeZone).toHaveBeenCalled();
                expect(timeZones).toContain('Europe/Berlin');

            });

        });

        describe('filtering timezone list', function () {

            it('should throw if filter is not array', function () {

                options = setCustomTzOptions({
                    timeZones: moment.tz.names(),
                    useMomentNames: true,
                    filters: {
                        limitTimeZonesBy: 'Barbados'
                    }
                });

                bbTimeZoneOptions.fn.filterTimeZones(options);

                expect($log.error.logs[0]).toEqual([ 'must be an Array:', 'Barbados:string' ]);

            });

            it('should limit moment timezones', function () {

                options = setCustomTzOptions({
                    timeZones: moment.tz.names(),
                    useMomentNames: true,
                    filters: {
                        limitTimeZonesBy: ['Barbados']
                    }
                });

                const timeZones = bbTimeZoneOptions.fn.filterTimeZones(options).timeZones;
                expect(timeZones.length).toEqual(1);
                expect(timeZones[0]).toEqual('America/Barbados');

            });

            it('should limit custom timezones', function () {

                options = setCustomTzOptions({
                    timeZones: Object.keys(bbCustomTimeZones.GROUPED_TIME_ZONES),
                    useMomentNames: false,
                    filters: {
                        limitTimeZonesBy: ['New_York', 'Dubai', 'Amsterdam']
                    }
                });

                const timeZones = bbTimeZoneOptions.fn.filterTimeZones(options).timeZones;
                expect(timeZones.length).toEqual(3);
                expect(timeZones).toEqual(['America/New_York', 'Asia/Dubai', 'Europe/Amsterdam']);

            });

            it('should reject specified moment timezones', function () {

                options = setCustomTzOptions({
                    timeZones: moment.tz.names(),
                    useMomentNames: true,
                    filters: {
                        excludeTimeZonesBy: ['Canada', 'London', 'Berlin', 'New York']
                    }
                });

                const timeZones = bbTimeZoneOptions.fn.rejectTimeZones(options).timeZones;

                expect(timeZones).not.toContain('Canada/Atlantic');
                expect(timeZones).not.toContain('Canada/East-Saskatchewan');
                expect(timeZones).not.toContain('Europe/London');
                expect(timeZones).not.toContain('Europe/Berlin');
                expect(timeZones).not.toContain('Amercia/New_York');

            });

            it('should reject specified custom timezones', function () {

                options = setCustomTzOptions({
                    timeZones: Object.keys(bbCustomTimeZones.GROUPED_TIME_ZONES),
                    useMomentNames: false,
                    filters: {
                        excludeTimeZonesBy: ['Tokyo', 'Athens', 'Istanbul']
                    }
                });

                const timeZones = bbTimeZoneOptions.fn.rejectTimeZones(options).timeZones;

                expect(timeZones.length).toEqual(Object.keys(bbCustomTimeZones.GROUPED_TIME_ZONES).length - options.filters.excludeTimeZonesBy.length);
                expect(timeZones).not.toContain('Asia/Tokyo');
                expect(timeZones).not.toContain('Europe/Athens');
                expect(timeZones).not.toContain('Europe/Istanbul');

            });

            it('should only include specified standard time timezones', function () {

                options = setCustomTzOptions({
                    timeZones: moment.tz.names(),
                    useMomentNames: true,
                    isDST: false,
                    filters: {
                        limitTimeZonesBy: ['Canada'],
                        daylightTimeZones: ['Canada/Newfoundland', 'Canada/Atlantic', 'Canada/Eastern', 'Canada/Central', 'Canada/Mountain', 'Canada/Pacific', 'Canada/Yukon'],
                        standardTimeZones: ['Canada/Newfoundland', 'Canada/Atlantic', 'Canada/Eastern', 'Canada/Central', 'Canada/East-Saskatchewan', 'Canada/Saskatchewan', 'Canada/Mountain', 'Canada/Pacific']
                    }
                });

                const timeZones = bbTimeZoneOptions.fn.filterDayLightOrStandardTimeZones(options).timeZones;
                expect(timeZones.length).toEqual(options.filters.standardTimeZones.length);
                expect(timeZones).not.toContain('Canada/Yukon');

            });

            it('should only include specified daylight saving time timezones', function () {

                options = setCustomTzOptions({
                    timeZones: moment.tz.names(),
                    useMomentNames: true,
                    isDST: true,
                    filters: {
                        limitTimeZonesBy: ['Canada'],
                        daylightTimeZones: ['Canada/Newfoundland', 'Canada/Atlantic', 'Canada/Eastern', 'Canada/Central', 'Canada/Mountain', 'Canada/Pacific', 'Canada/Yukon'],
                        standardTimeZones: ['Canada/Newfoundland', 'Canada/Atlantic', 'Canada/Eastern', 'Canada/Central', 'Canada/East-Saskatchewan', 'Canada/Saskatchewan', 'Canada/Mountain', 'Canada/Pacific']
                    }
                });

                const timeZones = bbTimeZoneOptions.fn.filterDayLightOrStandardTimeZones(options).timeZones;
                expect(timeZones.length).toEqual(options.filters.daylightTimeZones.length);
                expect(timeZones).not.toContain('Canada/East-Saskatchewan');
                expect(timeZones).not.toContain('Canada/Saskatchewan');

            });

        });

        describe('mapping timezone model', function () {

            it('should preserve timezone object if already mapped', function () {

                options = setCustomTzOptions({
                    timeZones: [
                        { id: 1, dislay: '(GMT+08:00) Chongqing', value: 'Asia/Chongqing', order: [8, 'CST', 'Chongqing']},
                        { id: 0, display: '(GMT+09:00) Choibalsan', value: 'Asia/Choibalsan', order: [9, 'CHOST', 'Choibalsan'] },
                        'Asia/Colombo'
                    ],
                    useMomentNames: true
                });

                const timeZones = bbTimeZoneOptions.fn.mapTimeZonesModel(options).timeZones;

                expect(timeZones[0]).toEqual(options.timeZones[0]);
                expect(timeZones[1]).toEqual(options.timeZones[1]);

            });

            it('should map timezones with id, value, display and order properties', function () {

                options = setCustomTzOptions({
                    timeZones: ['Asia/Choibalsan', 'Asia/Chongqing', 'Asia/Chungking', 'Asia/Colombo'],
                    useMomentNames: true
                });

                const timeZones = bbTimeZoneOptions.fn.mapTimeZonesModel(options).timeZones;

                expect(timeZones[0].id).toBeDefined();
                expect(timeZones[1].value).toBeDefined();
                expect(timeZones[2].display).toBeDefined();
                expect(timeZones[3].order).toBeDefined();

            });

            it('should format display value according to displayFormat', function () {

                options = setCustomTzOptions({
                    timeZones: [ 'Asia/Chongqing' ],
                    displayFormat: '(GMT offset-hours) location (tz-code)',
                    useMomentNames: true
                });

                const timeZones = bbTimeZoneOptions.fn.mapTimeZonesModel(options).timeZones;

                expect(timeZones[0].display).toEqual('(GMT +08:00) Chongqing (CST)');

            });

            it('should format display value according to default displayFormat', function () {

                options = setCustomTzOptions({
                    timeZones: [ 'Asia/Chongqing' ],
                    displayFormat: undefined,
                    useMomentNames: true
                });

                const timeZones = bbTimeZoneOptions.fn.mapTimeZonesModel(options).timeZones;

                expect(timeZones[0].display).toEqual('(GMT+08:00) Chongqing');

            });


            it('should map custom timezone location to custom translation keys', function () {

                options = setCustomTzOptions({
                    timeZones: [ 'America/New_York' ],
                    useMomentNames: false
                });

                const timeZones = bbTimeZoneOptions.fn.mapTimeZonesModel(options).timeZones;

                expect(timeZones[0].display).toEqual('(GMT-04:00) Eastern Time (US and Canada)');

            });

            it('should map moment timezone location to moment translation keys', function () {

                options = setCustomTzOptions({
                    timeZones: [ 'America/New_York' ],
                    useMomentNames: true
                });

                const timeZones = bbTimeZoneOptions.fn.mapTimeZonesModel(options).timeZones;

                expect(timeZones[0].display).toEqual(`(GMT${moment.tz('America/New_York').format('Z')}) New York`);

            });

            it('should map moment timezone code to translation key', function () {

                options = setCustomTzOptions({
                    timeZones: [ 'Brazil/DeNoronha' ],
                    displayFormat: '(tz-code) location',
                    useMomentNames: true
                });

                const timeZones = bbTimeZoneOptions.fn.mapTimeZonesModel(options).timeZones;

                expect(timeZones[0].display).toEqual(`(${moment.tz('Brazil/DeNoronha').format('zz')}) DeNoronha`);

            });

        });

        describe('tidy up', function () {

            it('should remove duplicate timezones in list', function () {

                options = setCustomTzOptions({
                    timeZones: [
                        { id: 0, dislay: '(GMT+08:00) Chongqing', value: 'Asia/Chongqing', order: [8, 'CST', 'Chongqing']},
                        { id: 1, display: '(GMT+09:00) Choibalsan', value: 'Asia/Choibalsan', order: [9, 'CHOST', 'Choibalsan'] },
                        { id: 2, dislay: '(GMT+08:00) Chongqing', value: 'Asia/Chongqing', order: [8, 'CST', 'Chongqing']}
                    ]
                });

                const timeZones = bbTimeZoneOptions.fn.removeDuplicates(options).timeZones;

                expect(timeZones.length).toEqual(2);

            });

            it('should order timezones according to order property', function () {

                options = setCustomTzOptions({
                    timeZones: [
                        { 'id': 486, 'display': '(GMT+14:00) Kiritimati', 'value': 'Pacific/Kiritimati', 'order': [ 14, '+14', 'Kiritimati' ]},
                        { 'id': 444, 'display': '(GMT+01:00) GB-Eire', 'value': 'GB-Eire', 'order': [ 1, 'BST', 'GB_Eire' ]},
                        { 'id': 445, 'display': '(GMT+00:00) Greenwich', 'value': 'Greenwich', 'order': [ 0, 'GMT', 'Greenwich' ]},
                        { 'id': 446, 'display': '(GMT+08:00) Hongkong', 'value': 'Hongkong', 'order': [ 8, 'HKT', 'Hongkong' ]},
                        { 'id': 484, 'display': '(GMT-10:00) Honolulu', 'value': 'Pacific/Honolulu', 'order': [ -10, 'HST', 'Honolulu' ]},
                        { 'id': 485, 'display': '(GMT-10:00) Johnston', 'value': 'Pacific/Johnston', 'order': [ -10, 'HST', 'Johnston' ]}
                    ]
                });

                const timeZones = bbTimeZoneOptions.fn.orderTimeZones(options).timeZones;

                expect(timeZones[0].value).toEqual('Pacific/Honolulu');
                expect(timeZones[5].value).toEqual('Pacific/Kiritimati');

            });


        });

    });
});
