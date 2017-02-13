// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
let controller = function($scope) {
  'ngInject';

  /*jshint validthis: true */
  let vm = this;

  let init = function() {
    vm.someTextValue = 'random text';
    vm.someNumber = 7;
    vm.someData = $scope.someData;
    vm.prepareMessage = prepareMessage;

  };

  var prepareMessage = msg => trimMessage(msg) + '!';

  var trimMessage = msg => msg.trim();

  init();

};

angular
.module('bbTe.blogArticle')
.controller('BbTeBaControllerAsController', controller);
