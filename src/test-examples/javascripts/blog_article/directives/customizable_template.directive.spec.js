// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
describe('bbTe.blogArticle, bbTeBaCustomizableTemplate directive', function() {
  let $compile = null;
  let $httpBackend = null;
  let $scope = null;

  let directive = null;

  let directiveDefaultTemplatePath = '/templates/blog-article/display.html';
  let directiveDefaultHtml = '<bb-te-ba-customizable-template some-data="anyData"></bb-te-ba-customizable-template>';

  let directiveCustomizedTemplatePath = '/templates/blog-article/display-customized.html';
  let directiveCustomizedHtml = `<bb-te-ba-customizable-template template-url="${directiveCustomizedTemplatePath}"></bb-te-ba-customizable-template>`;

  let beforeEachFn = function() {
    module('bbTe.blogArticle');

    inject(function($injector) {
      $compile = $injector.get('$compile');
      $httpBackend = $injector.get('$httpBackend');
      $scope = $injector.get('$rootScope').$new();
    });

    $httpBackend.whenGET(directiveDefaultTemplatePath).respond(200, '<span>directive default content!</span>');
    $httpBackend.whenGET(directiveCustomizedTemplatePath).respond(200, '<span>directive customized content!</span>');

  };

  let afterEachFn = function() {
    $httpBackend.verifyNoOutstandingExpectation();
    return $httpBackend.verifyNoOutstandingRequest();
  };

  beforeEach(beforeEachFn);
  afterEach(afterEachFn);

  it('use default template', function() {
    directive = $compile(directiveDefaultHtml)($scope);

    $httpBackend.flush();

    expect(directive.html()).toContain('directive default content!');
  });

  it('use customized template', function() {
    directive = $compile(directiveCustomizedHtml)($scope);

    $httpBackend.flush();

    expect(directive.html()).toContain('directive customized content!');
  });

});


