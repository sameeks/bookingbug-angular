describe('bbTe.blogArticle, bbTeBaDefaults directive', function () {
    let $compile = null;
    let $httpBackend = null;
    let $rootScope = null;

    let compiled = null;

    let directiveTemplatePath = '/templates/blog-article/defaults.html';
    let directiveHtmlAttribute = '<span bb-te-ba-defaults></span>';
    let directiveHtmlElement = '<bb-te-ba-defaults></bb-te-ba-defaults>';
    let directiveHtmlClass = '<span class="bb-te-ba-defaults"></span>';
    let directiveHtmlComment = '<!-- directive: bb-te-ba-defaults  -->';

    let htmlScopeTest = '<div class="app-level"><span bb-te-ba-defaults></span></div>';

    let beforeEachFn = function () {
        module('bbTe.blogArticle');

        inject(function ($injector) {
            $compile = $injector.get('$compile');
            $httpBackend = $injector.get('$httpBackend');
            $rootScope = $injector.get('$rootScope');
        });

        $httpBackend.whenGET(directiveTemplatePath).respond(200, '<span>some content!</span>');

    };

    let afterEachFn = function () {
        $httpBackend.verifyNoOutstandingExpectation();
        return $httpBackend.verifyNoOutstandingRequest();
    };

    beforeEach(beforeEachFn);
    afterEach(afterEachFn);

    describe('"restrict" property', function () {
        it('can be declared as an attribute by default', function () {
            compiled = $compile(directiveHtmlAttribute)($rootScope);

            expect(() => $httpBackend.flush()).not.toThrow();

            expect(compiled.html()).toContain('some content!');
        });

        it('can be declared as an element by default', function () {
            compiled = $compile(directiveHtmlElement)($rootScope);

            expect(() => $httpBackend.flush()).not.toThrow();
        });

        it('cannot be declared using a class', function () {
            compiled = $compile(directiveHtmlClass)($rootScope);

            expect(() => $httpBackend.flush()).toThrow();
        });

        it('cannot be declared using a comment', function () {
            compiled = $compile(directiveHtmlComment)($rootScope);

            expect(() => $httpBackend.flush()).toThrow();
        });

    });

    describe('"scope" property is set by default to false which means surrounding scope', function () {

        let surroundingScope = null;
        let directiveScope = null;

        let beforeEachLvl2 = function () {
            $rootScope.appLevelParam = 'anything';
            compiled = $compile(htmlScopeTest)($rootScope);
            $httpBackend.flush();

            surroundingScope = compiled.scope();
            return directiveScope = compiled.find('span').scope();
        };

        beforeEach(beforeEachLvl2);

        it('changes on parent scope are visible in directive', function () {

            surroundingScope.appLevelParam = 'aaa';

            expect(surroundingScope.appLevelParam)
                .toBe(directiveScope.appLevelParam);

        });

        it('directive.scope() returns surrounding scope so any changes on directive scope are actually changes on surrounding scope', function () {

            directiveScope.appLevelParam = 'aaa';

            expect(surroundingScope.appLevelParam)
                .toBe(directiveScope.appLevelParam);

        });

        it('does not create child scope or isolated scope', function () {

            let directive = compiled.find('span');

            expect(directive.hasClass('ng-scope'))
                .toBe(false);

            expect(directive.isolateScope())
                .toBeUndefined();

            expect(directive.hasClass('ng-scope-isolated'))
                .toBe(false);

        });
    });

});


