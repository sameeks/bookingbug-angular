describe('bbTe.blogArticle, bbTeBaSample provider', function() {
  let sampleProviderObj = null;
  let sample = null;

  let beforeEachFn = function() {
    module('bbTe.blogArticle');

    module(function(bbTeBaSampleProvider) {
      sampleProviderObj = bbTeBaSampleProvider;
    });

    inject(function($injector) {
      sample = $injector.get('bbTeBaSample');
    });

  };

  beforeEach(beforeEachFn);

  it('use default company name to introduce employee', function() {
    expect(sample.introduceEmployee('B'))
    .toBe('B works at Default Company');

  });

  it('use specific company name to introduce employee - by using provider method', function() {
    sampleProviderObj.setCompanyName('BookingBug');

    expect(sample.introduceEmployee('B'))
    .toBe('B works at BookingBug');

    expect(sample.introduceEmployee('C'))
    .toBe('C works at BookingBug');

  });


  it('use specific company name to introduce employee - by using provider method', function() {
    expect(sample.introduceEmployee('B'))
    .toBe('B works at Default Company');

  });

});
