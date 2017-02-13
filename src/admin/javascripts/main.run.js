angular.module('BBAdmin.Services').run(function($q, $injector, BBModel) {
  'ngInject';

  let models = ['Booking', 'Slot', 'User', 'Administrator', 'Schedule', 'Address',
    'Resource', 'Person', 'Service', 'Login', 'EventChain', 'EventGroup',
    'Event', 'Clinic', 'Company', 'Client'];

  let afuncs = {};
  for (let model of Array.from(models)) {
    afuncs[model] = $injector.get(`Admin${model}Model`);
  }
  BBModel['Admin'] = afuncs;

});
