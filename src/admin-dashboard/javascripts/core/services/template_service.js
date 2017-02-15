// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/**
 * @ngdoc service
 * @name BBAdminDashboard.TemplateService
 *
 * @description
 * Checks if a custom version of the requested template exists in the templateCache,
 * otherwise returns the default version (which should be compiled with the module)
 */
angular.module('BBAdminDashboard').factory('TemplateService', ($templateCache, $exceptionHandler) => {
        return {
            get(template){
                if ($templateCache.get(template) != null) {
                    return $templateCache.get(template);
                } else if ($templateCache.get(`/default${template}`) != null) {
                    return $templateCache.get(`/default${template}`);
                } else {
                    return $exceptionHandler(new Error(`Template "${template}" not found`), '', true);
                }
            }
        };
    }
);
