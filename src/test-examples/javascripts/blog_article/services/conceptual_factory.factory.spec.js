describe('bbTe.blogArticle, bbTeBaConceptualFactory factory', function() {
  let conceptualFactory = null;

  let beforeEachFn = function() {
    module('bbTe.blogArticle');

    inject(function($injector) {
      conceptualFactory = $injector.get('bbTeBaConceptualFactory');
    });
  };

  beforeEach(beforeEachFn);

  it('can say hello', () =>

    expect(conceptualFactory.sayHello('test'))
    .toBe('Hi test!')
  );
});

return;
