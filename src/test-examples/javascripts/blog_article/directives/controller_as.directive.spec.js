describe('bbTe.blogArticle, bbTeBaControllerAs directive', function() {
  let $compile = null;
  let $httpBackend = null;
  let $rootScope = null;

  let compiled = null;

  let directiveDefaultTemplatePath = '/templates/blog-article/bindsToController.html';
  let directiveDefaultHtml = '<bb-te-ba-controller-as some-data="anyData"></bb-te-ba-controller-as>';

  let beforeEachFn = function() {
    module('bbTe.blogArticle');

    inject(function($injector) {
      $compile = $injector.get('$compile');
      $httpBackend = $injector.get('$httpBackend');
      $rootScope = $injector.get('$rootScope');
    });

    $httpBackend.whenGET(directiveDefaultTemplatePath).respond(200, '<span>test</span>');

  };

  let afterEachFn = function() {
    $httpBackend.verifyNoOutstandingExpectation();
    return $httpBackend.verifyNoOutstandingRequest();
  };

  beforeEach(beforeEachFn);
  afterEach(afterEachFn);

  it('expose "vm" object on isolated scope', function() {

    $rootScope.anyData = {foo: 'bar'};

    compiled = $compile(directiveDefaultHtml)($rootScope);
    $httpBackend.flush();
    let isolatedScope = compiled.isolateScope();

    expect(isolatedScope.vm.someTextValue)
    .toBe('random text');

    expect(isolatedScope.vm.someNumber)
    .toBe(7);

    expect(isolatedScope.vm.someData)
    .toBe($rootScope.anyData);

    expect(isolatedScope.vm.prepareMessage(' test'))
    .toBe('test!');

  });

});


