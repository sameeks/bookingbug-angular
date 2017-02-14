// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
describe('bbTe.blogArticle, bbTeBaServiceDoingSameAsFactory service', function () {
    let bbTeBaServiceDoingSameAsFactory = null;

    let beforeEachFn = function () {
        module('bbTe.blogArticle');

        inject(function ($injector) {
            bbTeBaServiceDoingSameAsFactory = $injector.get('bbTeBaServiceDoingSameAsFactory');
        });
    };

    beforeEach(beforeEachFn);

    it('can say hello', () =>

        expect(bbTeBaServiceDoingSameAsFactory.sayHello('test'))
            .toBe('Hi test!')
    );

});
