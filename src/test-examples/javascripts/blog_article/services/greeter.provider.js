// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
let provider = function ($logProvider) {
    'ngInject';

    let greeting = 'Hello';

    this.setGreeting = function (newGreeting) {
        greeting = newGreeting;
    };

    this.$get = function ($log) {
        'ngInject';

        class Greeter {
            constructor() {

            }

            greet(employeeName) {
                return greeting + ' ' + employeeName + '!';
            }
        }

        return Greeter;
    };

};

angular
    .module('bbTe.blogArticle')
    .provider('BbTeBaGreeter', provider);
