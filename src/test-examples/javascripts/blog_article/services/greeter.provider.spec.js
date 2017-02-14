// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
describe('bbTe.blogArticle, BbTeBaGreeter provider', function () {
    let GreeterProviderObj = null;
    let Greeter = null;

    let beforeEachFn = function () {
        module('bbTe.blogArticle');

        module(function (BbTeBaGreeterProvider) {
            GreeterProviderObj = BbTeBaGreeterProvider;
        });

        inject(function ($injector) {
            Greeter = $injector.get('BbTeBaGreeter');
        });

    };

    beforeEach(beforeEachFn);

    it('can use provider to modify greeting', function () {

        let greeter = new Greeter;

        expect(greeter.greet('B'))
            .toBe('Hello B!');

        GreeterProviderObj.setGreeting('Hi');

        expect(greeter.greet('B'))
            .toBe('Hi B!');

    });

});
