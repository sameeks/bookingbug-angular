angular.module('BBQueue').run(function (BBModel, $injector) {
    'ngInject';

    let models = ['Queuer', 'ClientQueue'];
    for (let model of Array.from(models)) {
        BBModel['Admin'][model] = $injector.get(`Admin${model}Model`);
    }
    BBModel['Admin']['Person'] = $injector.get("AdminQueuerPersonModel");

});
