// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.uib').run(function($document, runtimeUibModal) {
  'ngInject';

  let init = function() {
    setUibModalDefaults();
  };

  var setUibModalDefaults = function() {
    runtimeUibModal.options.appendTo = angular.element($document[0].getElementById('bb'));
  };

  init();
});
