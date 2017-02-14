// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/**
 * @ngdoc service
 * @name BB.uib.runtimeUibModal
 *
 * @description
 * Returns an instance of $uibModalProvider that allows to set modal default options (on runtime)
 */
angular.module('BB.uib').provider('runtimeUibModal', function ($uibModalProvider) {
    'ngInject';

    let uibModalProvider = $uibModalProvider;
    this.setProvider = provider => uibModalProvider = provider;
    this.$get = () => uibModalProvider;
});
