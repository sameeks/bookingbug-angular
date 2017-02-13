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
