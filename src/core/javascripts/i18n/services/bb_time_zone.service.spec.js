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

            $provide.factory('CompanyStoreService', function () {
                return {time_zone: 'America/New_York'};
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

    describe('when calling "determine"', () => {

        it('should use default timezone', () => {
            setBbi18nOptions({
                available_languages: ['en'],
                default_time_zone: 'Europe/London',
                use_browser_time_zone: false,
                use_company_time_zone: false
            });

            bbTimeZone.determineTimeZone();

            expect(bbTimeZone.getDisplayTimeZone()).toBe('Europe/London');
        });

        it('should use browser timezone', () => {
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

        it('should use company timezone', () => {
            setBbi18nOptions({
                available_languages: ['en'],
                default_time_zone: 'Europe/London',
                use_browser_time_zone: false,
                use_company_time_zone: true
            });
            bbTimeZone.determineTimeZone();
            expect(bbTimeZone.getDisplayTimeZone()).toBe('America/New_York');
        });

        it('should use browser timezone (use_browser_time_zone has precedence over use_company_time_zone)', () => {
            setBbi18nOptions({
                available_languages: ['en'],
                default_time_zone: 'Europe/London',
                use_browser_time_zone: true,
                use_company_time_zone: true
            });
            spyOn(moment.tz, 'guess').and.returnValue('Europe/Berlin');
            bbTimeZone.determineTimeZone();
            expect(bbTimeZone.getDisplayTimeZone()).toBe('Europe/Berlin');
        });
    });
});
