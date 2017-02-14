// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
describe('bbTe.blogArticle, bbTeBaTextSanitizer service', function () {
    let articleSanitizer = null;

    let sampleText = ' SomE Sample text, SomE Sample text    ';
    let expected = null;

    let setup = function () {
        module('bbTe.blogArticle');

        inject(function ($injector) {
            articleSanitizer = $injector.get('bbTeBaTextSanitizer');

        });

        expected = articleSanitizer.sanitize(sampleText);

    };

    beforeEach(setup);

    it('remove trailing whitespaces', function () {

        expect(expected[0])
            .not.toBe(' ');

    });

    it('returns only 10 characters', function () {

        expect(expected.length)
            .toBe(10);

    });

    return it('lowercase the text', function () {

        expect(expected)
            .toBe(expected.toLowerCase());

    });
});



