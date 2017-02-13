// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
describe('bbTe.blogArticle, bbTeBaConceptualService service', function() {
  let conceptualService = null;

  let beforeEachFn = function() {
    module('bbTe.blogArticle');

    inject(function($injector) {
      conceptualService = $injector.get('bbTeBaConceptualService');
    });
  };

  beforeEach(beforeEachFn);

  it('can say hello', () =>
    expect(conceptualService.sayHello('test'))
    .toBe('Hi test!')
  );

});

return;
