// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
let factory = function ($log) {
    'ngInject';

    let init = function () {

    };

    let sayHello = name => `Hi ${name}!`;

    init();

    return {
        sayHello
    }; // it's important to return an object
};

angular
    .module('bbTe.blogArticle')
    .factory('bbTeBaConceptualFactory', factory);
