// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
describe('bbTe.blogArticle, bbTeBaArticleGateway service', function () {
    let endpoint = 'http://some.endpoint.com';

    let articleGateway = null;
    let textSanitizer = null;
    let $http = null;
    let $httpBackend = null;
    let $log = null;

    let articleMock = {
        id: 1,
        title: 'some title',
        content: ' sOmE Sample content of Article  '
    };

    let beforeEachFn = function () {
        module('bbTe.blogArticle');

        inject(function ($injector) {
            articleGateway = $injector.get('bbTeBaArticleGateway');
            textSanitizer = $injector.get('bbTeBaTextSanitizer');
            $http = $injector.get('$http');
            $httpBackend = $injector.get('$httpBackend');
            $log = $injector.get('$log');
        });

        spyOn(textSanitizer, 'sanitize')
            .and.callThrough();

    };

    beforeEach(beforeEachFn);

    describe('"getArticles" method', function () {
        let getArticlesEndpoint = endpoint + '/article';

        let articlesMock = [
            {content: '  somE Random Article'},
            {content: 'test'},
            {content: 'test'},
            {content: 'test'}
        ];

        let beforeEachFnLvl2 = function () {

        };

        beforeEach(beforeEachFnLvl2);

        it('load articles & resolves promise', function () {
            $httpBackend.expectGET(getArticlesEndpoint).respond(200, articlesMock);

            let articlesPromise = articleGateway.getArticles();
            let testArticles = null;

            articlesPromise
                .then(function (articles) {
                    testArticles = articles;
                });

            $httpBackend.flush();

            expect(testArticles.length)
                .toBe(4);

            expect(textSanitizer.sanitize)
                .toHaveBeenCalledTimes(4);

        });

        it('reject promise if server error occurred', function () {
            $httpBackend.expectGET(getArticlesEndpoint).respond(500);
            let articlesPromise = articleGateway.getArticles();

            let rejectionMsg = null;

            articlesPromise
                .catch(data => rejectionMsg = data);

            $httpBackend.flush();

            expect(rejectionMsg)
                .toMatch(/could not load articles/);

            expect(textSanitizer.sanitize)
                .not.toHaveBeenCalled;

        });

    });

    describe('"getArticle" method', function () {
        let articleId = 1;
        let getArticleEndpoint = endpoint + '/article/' + articleId;

        it('load article and resolves promise', function () {
            $httpBackend.expectGET(getArticleEndpoint).respond(200, articleMock);

            let expectedArticle = null;
            articleGateway.getArticle(1)
                .then(response => expectedArticle = response);

            $httpBackend.flush();

            expect(typeof expectedArticle)
                .toBe('object');

            expect(textSanitizer.sanitize)
                .toHaveBeenCalledTimes(1);

        });

        it('server fails and promise gets rejected', function () {
            $httpBackend.expectGET(getArticleEndpoint).respond(500);

            let expectedMsg = null;
            articleGateway.getArticle(1)
                .catch(msg => expectedMsg = msg);

            $httpBackend.flush();

            expect(expectedMsg)
                .toMatch(/could not load (.*) id:1/);

            expect(textSanitizer.sanitize)
                .not.toHaveBeenCalled();

        });
    });

    describe('"deleteArticle" method', function () {
        let articleId = 1;
        let getArticleEndpoint = endpoint + '/article/' + articleId;

        let beforeEachFnLvl2 = function () {
            spyOn($log, 'error');

        };

        beforeEach(beforeEachFnLvl2);

        it('delete article & resolves promise', function () {
            $httpBackend.expectDELETE(getArticleEndpoint).respond(200, 'OK');

            let isDeleted = null;
            articleGateway.deleteArticle(articleId)
                .then(response => isDeleted = response).catch(response => isDeleted = response);

            $httpBackend.flush();

            expect(isDeleted)
                .toBe(true);

            expect($log.error)
                .not.toHaveBeenCalled();

        });

        it('does not delete article if 500 returend from server', function () {
            $httpBackend.expectDELETE(getArticleEndpoint).respond(500, 'some reason of failure');

            let isDeleted = null;
            let promise = articleGateway.deleteArticle(articleId);

            promise
                .then(function (response) {
                    isDeleted = response;
                }).catch(function (response) {
                isDeleted = response;
            });

            $httpBackend.flush();

            expect(isDeleted)
                .toBe(false);

            expect($log.error)
                .toHaveBeenCalledWith(jasmine.stringMatching(/could not/), jasmine.stringMatching(/reaso/));

        });


        it('does not delete article if unexpected message returned', function () {
            $httpBackend.expectDELETE(getArticleEndpoint).respond(200, 'NOT OK');
            articleGateway.deleteArticle(articleId);
            $httpBackend.flush();

            expect($log.error)
                .toHaveBeenCalledWith(jasmine.stringMatching(/could not/), jasmine.stringMatching(/NOT/));

        });

    });

});


