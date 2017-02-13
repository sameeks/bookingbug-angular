let provider = function($logProvider) {
  'ngInject';

  let companyName = 'Default Company';

  this.getCompanyName = () => companyName;

  this.setCompanyName = function(name) {
    companyName = name;
  };

  this.$get = function() {
    'ngInject';

    let introduceEmployee = employeeName => employeeName + ' works at ' + companyName;

    return {
      introduceEmployee
    };
  };

};

angular
.module('bbTe.blogArticle')
.provider('bbTeBaSample', provider);
