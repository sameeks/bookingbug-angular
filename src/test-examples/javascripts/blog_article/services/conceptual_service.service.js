let service = function ($log) {
    'ngInject';

    this.sayHello = name => `Hi ${name}!`;
    // it's important in this example that this function doesn't return anything as in fact it's a constructor function
};

angular
    .module('bbTe.blogArticle')
    .service('bbTeBaConceptualService', service);
