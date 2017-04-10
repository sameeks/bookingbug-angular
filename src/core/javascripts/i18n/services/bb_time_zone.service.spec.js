describe('bbTimeZone service,', () => {

    let bbTimeZone = null;
    let moment = null;

    const setBbi18nOptions = (options = {}) => {
        module(function ($provide) {
            $provide.provider('bbi18nOptions', function () {
                this.$get = () => {
                    return Object.assign({
                        available_languages: ['en'],
                        default_time_zone: 'Europe/London',
                        use_browser_time_zone: false,
                        use_company_time_zone: false
                    }, options);
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

    beforeEach(() => {
        localStorage.clear();
    });

    describe('when calling "determine"', () => {

        afterEach(() => {
            localStorage.clear();
        });

        it('should use default timezone', () => {
            setBbi18nOptions();

            bbTimeZone.determineTimeZone();

            expect(bbTimeZone.getDisplayTimeZone()).toBe('Europe/London');
        });

        it('should use browser timezone', () => {
            setBbi18nOptions({
                use_browser_time_zone: true
            });

            spyOn(moment.tz, 'guess').and.returnValue('Europe/Berlin');
            bbTimeZone.determineTimeZone();

            expect(moment.tz.guess).toHaveBeenCalled();
            expect(bbTimeZone.getDisplayTimeZone()).toBe('Europe/Berlin');
        });

        it('should use company timezone', () => {
            setBbi18nOptions({
                use_company_time_zone: true
            });
            bbTimeZone.determineTimeZone();
            expect(bbTimeZone.getDisplayTimeZone()).toBe('America/New_York');
        });

        it('should use browser timezone (use_browser_time_zone has precedence over use_company_time_zone)', () => {

            setBbi18nOptions({
                use_browser_time_zone: true,
                use_company_time_zone: true
            });

            spyOn(moment.tz, 'guess').and.returnValue('Europe/Paris');

            bbTimeZone.determineTimeZone();

            expect(bbTimeZone.getDisplayTimeZone()).toBe('Europe/Paris');
        });

        it('should use time zone stored in browser local storage', () => {
            setBbi18nOptions({
                use_browser_time_zone: true,
                use_company_time_zone: true
            });

            bbTimeZone.setLocalStorage({displayTimeZone: 'Canada/Mountain'});
            bbTimeZone.determineTimeZone();

            expect(bbTimeZone.getDisplayTimeZone()).toBe('Canada/Mountain');
        });

        it('should use browser timezone (enforced by value in browser local storage)', () => {

            setBbi18nOptions({
                use_browser_time_zone: false,
                use_company_time_zone: false
            });

            spyOn(moment.tz, 'guess').and.returnValue('Europe/Paris');

            bbTimeZone.setLocalStorage({useBrowserTimeZone: true});
            bbTimeZone.determineTimeZone();

            expect(bbTimeZone.getDisplayTimeZone()).toBe('Europe/Paris');
        });


    });
});
