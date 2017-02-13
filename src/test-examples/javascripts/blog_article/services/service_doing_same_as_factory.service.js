// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
  Conceptually:
    - service is just a constructor function that will be called with 'new'
    - factory returns an object so you can run some configuration code before or conditionally create an object or not
        which does not seem to be possible when creating a service directly,
        which is why most resources recommend to use factories over services, but the reasoning is inappreciable.

  Below is example proving that you can do the exact same thing with services as with factories.

  It turns out that it’s actually better to use services where possible, when it comes to migrating to ES6.
  The reason for that is simply that a service is a constructor function and a factory is not.
  Working with constructor functions in ES5 allows us to easily use ES6 classes when we migrate to ES6 in the future.

  @see http://blog.thoughtram.io/angular/2015/07/07/service-vs-factory-once-and-for-all.html

*/
let service = function($log) {
  'ngInject';
  /* do whatever you want inside init function */
  let init = function() {
    
  };

  let sayHello = name => `Hi ${name}!`;

  init();

  return {
    sayHello
  }; // it's important to return an object
};

angular
.module('bbTe.blogArticle')
.factory('bbTeBaServiceDoingSameAsFactory', service);
