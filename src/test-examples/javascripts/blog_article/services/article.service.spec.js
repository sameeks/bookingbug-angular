describe('bbTe.blogArticle, BbTeBaBlogArticle service', function () {
    let BlogArticle = null;

    let beforeEachFn = function () {
        module('bbTe.blogArticle');

        inject(function ($injector) {
            BlogArticle = $injector.get('BbTeBaBlogArticle');
        });
    };

    beforeEach(beforeEachFn);

    it('can instantiate using defaults', function () {

        let article = new BlogArticle;

        expect(article.title)
            .toBe('default title');

        expect(article.content)
            .toBe('default content');

    });

    it('can instantiate with custom title and content', function () {
        let article1 = new BlogArticle('some custom title', 'some custom content');

        expect(article1.title)
            .toMatch(/custom/);

        expect(article1.content)
            .toMatch(/custom/);

    });

    it('can can change title', function () {
        let article = new BlogArticle('aaa');

        article.setTitle('changed');

        expect(article.getTitle())
            .toBe('changed');

    });

});
