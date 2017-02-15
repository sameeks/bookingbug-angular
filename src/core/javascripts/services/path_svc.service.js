let service = function ($sce, AppConfig) {
    'ngInject';

    /*
     @param {String} fileName
     @returns {Object}
     */
    let directivePartial = function (fileName) {
        if (AppConfig.partial_url) {
            let partialUrl = AppConfig.partial_url;
            return $sce.trustAsResourceUrl(`${partialUrl}/${fileName}.html`);
        } else {
            return $sce.trustAsResourceUrl(`${fileName}.html`);
        }
    };

    return {
        directivePartial
    };
};

angular.module('BB.Services').service('PathSvc', service);
