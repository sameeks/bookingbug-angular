describe('bbTimeZone service,', () => {

    let bbTimeZone = null;
    let moment = null;

    const setBbi18nOptions = (options = {}) => {

        module(function ($provide) {

            $provide.provider('bbi18nOptions', function () {
                this.$get = () => {

                    return Immutable.fromJS({
                        available_languages: ['en'],
                        timeZone: {
                            default: 'Europe/London',
                            useMomentNames: true,
                            useBrowser: false,
                            useCompany: false
                        }
                    }).mergeDeep(options).toJS();
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
                timeZone: {
                    useBrowser: true,
                    useMomentNames: true
                }
            });

            spyOn(moment.tz, 'guess').and.returnValue('Europe/Berlin');
            bbTimeZone.determineTimeZone();

            expect(moment.tz.guess).toHaveBeenCalled();
            expect(bbTimeZone.getDisplayTimeZone()).toBe('Europe/Berlin');
        });

        it('should use company timezone', () => {
            setBbi18nOptions({
                timeZone: {
                    useCompany: true
                }
            });
            bbTimeZone.determineTimeZone();
            expect(bbTimeZone.getDisplayTimeZone()).toBe('America/New_York');
        });

        it('should use browser timezone (timeZone.useBrowser has precedence over timeZone.useCompany)', () => {

            setBbi18nOptions({
                timeZone: {
                    useBrowser: true,
                    useCompany: true
                }
            });

            spyOn(moment.tz, 'guess').and.returnValue('Europe/Paris');

            bbTimeZone.determineTimeZone();

            expect(bbTimeZone.getDisplayTimeZone()).toBe('Europe/Paris');
        });

        it('should use time zone stored in browser local storage', () => {
            setBbi18nOptions({
                timeZone: {
                    useBrowser: true,
                    useCompany: true
                }
            });

            bbTimeZone.setLocalStorage({displayTimeZone: 'Canada/Mountain'});
            bbTimeZone.determineTimeZone();

            expect(bbTimeZone.getDisplayTimeZone()).toBe('Canada/Mountain');
        });

        it('should use browser timezone (enforced by value in browser local storage)', () => {

            setBbi18nOptions({
                timeZone: {
                    useBrowser: false,
                    useCompany: false
                }
            });

            spyOn(moment.tz, 'guess').and.returnValue('Europe/Paris');

            bbTimeZone.setLocalStorage({useBrowserTimeZone: true});
            bbTimeZone.determineTimeZone();

            expect(bbTimeZone.getDisplayTimeZone()).toBe('Europe/Paris');
        });


    });
});
