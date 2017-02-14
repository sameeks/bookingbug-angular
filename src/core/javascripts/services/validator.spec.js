// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
describe('ValidatorService', function () {
    let validatorService = null;

    beforeEach(function () {
        module('BB');

        return inject($injector => validatorService = $injector.get('ValidatorService'));
    });

    describe('getUKMobilePattern function called with "strict" arg set to true returns regex which', function () {
        let ukMobileRegex = null;

        beforeEach(() => ukMobileRegex = validatorService.getUKMobilePattern(true));

        describe('validates', function () {

            it('"07874319541"', () =>
                expect(ukMobileRegex.test('07874319541'))
                    .toBe(true)
            );

            it('"+447874319541"', () =>
                expect(ukMobileRegex.test('+447874319541'))
                    .toBe(true)
            );

            it('"+44 787 431 9541"', () =>
                expect(ukMobileRegex.test('+44 787 431 95 41'))
                    .toBe(true)
            );

            return it('"0 787 431 9541"', () =>
                expect(ukMobileRegex.test('0 787 431 9541'))
                    .toBe(true)
            );
        });

        return describe('invalidates', function () {
            it('"+44 (0) 787 431 9541"', () =>
                expect(ukMobileRegex.test('+44 (0) 787 431 95 41'))
                    .toBe(false)
            );

            it('" 0 787 431 9541"', () =>
                expect(ukMobileRegex.test(' 0 787 431 9541'))
                    .toBe(false)
            );

            return it('"0 787 431 9541 "', () =>
                expect(ukMobileRegex.test('0 787 431 9541 '))
                    .toBe(false)
            );
        });
    });

    return describe('getUKLandlinePattern function called with "strict" arg set to true returns regex which', function () {
        let ukLandlineRegex = null;

        beforeEach(() => ukLandlineRegex = validatorService.getUKLandlinePattern(true));

        describe('validates', function () {
            it('"+44 20 7946 0018"', () =>
                expect(ukLandlineRegex.test('+44 20 7946 0018'))
                    .toBe(true)
            );

            it('"0 20 7946 0018"', () =>
                expect(ukLandlineRegex.test('0 20 7946 0018'))
                    .toBe(true)
            );

            it('"01632 431091"', () =>
                expect(ukLandlineRegex.test('01632 431091'))
                    .toBe(true)
            );

            it('"+44 1632 431 091"', () =>
                expect(ukLandlineRegex.test('+44 1632 431 091'))
                    .toBe(true)
            );

            return it('"0113 496 7133"', () =>
                expect(ukLandlineRegex.test('0113 496 7133'))
                    .toBe(true)
            );
        });

        return describe('invalidates', function () {
            it('"+44 (0) 20 7946 0018"', () =>
                expect(ukLandlineRegex.test('+44 (0) 20 7946 0018'))
                    .toBe(false)
            );

            it('" 0 20 7946 0018"', () =>
                expect(ukLandlineRegex.test(' 0 20 7946 0018'))
                    .toBe(false)
            );

            it('"0 20 7946 0018 "', () =>
                expect(ukLandlineRegex.test('0 20 7946 0018 '))
                    .toBe(false)
            );

            return it('"+44 01632 431 091"', () =>
                expect(ukLandlineRegex.test('+44 01632 431 091'))
                    .toBe(false)
            );
        });
    });
});



