fdescribe('bbTimeZone service,', () => {

    let bbTimeZone = null;
    let moment = null;

    const setBbi18nOptions = (options) => {
        module(function ($provide) {
            $provide.provider('bbi18nOptions', function () {
                this.$get = () => {
                    return options;
                };
            });

        });

        inject(($injector) => {
            bbTimeZone = $injector.get('bbTimeZone');
            moment = $injector.get('moment');
        });
    };

    beforeEach(() => {
        module('BB');
        module('BB.i18n');
    });

    it('can set default timezone', () => {
        setBbi18nOptions({
            available_languages: ['en'],
            default_time_zone: 'Europe/London',
            use_browser_time_zone: false,
            use_company_time_zone: false
        });
        expect(bbTimeZone.getDisplayTimeZone()).toBe('Europe/London');
    });

    it('can set rely on browser timezone, using moment.tz.guess', () => {
        setBbi18nOptions({
            available_languages: ['en'],
            default_time_zone: 'Europe/London',
            use_browser_time_zone: true,
            use_company_time_zone: false
        });

        spyOn(moment.tz, 'guess').and.returnValue('Europe/Berlin');
        bbTimeZone.determineTimeZone();

        expect(moment.tz.guess).toHaveBeenCalled();
        expect(bbTimeZone.getDisplayTimeZone()).toBe('Europe/Berlin');
    });

});
