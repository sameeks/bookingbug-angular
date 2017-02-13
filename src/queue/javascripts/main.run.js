// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBQueue').run(function() {
  'ngInject';

  let models = ['Queuer', 'ClientQueue'];
  for (let model of Array.from(models)) {
    BBModel['Admin'][model] = $injector.get(`Admin${model}Model`);
  }
  BBModel['Admin']['Person'] = $injector.get("AdminQueuerPersonModel");

});