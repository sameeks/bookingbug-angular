/*
* @ngdoc overview
* @name BBAdminDashboard.publish-iframe.translations
*
* @description
* Translations for the admin publish-iframe module
*/
angular.module('BBAdminDashboard.publish-iframe.translations')
.config(['$translateProvider', $translateProvider=>
  $translateProvider.translations('en', {
    'ADMIN_DASHBOARD': {
      'SIDE_NAV': {
        'PUBLISH_IRAME_PAGE': {
          'PUBLISH'          : 'Publish',
          'PUBLISH_BUSINESS' : 'Publish business',
          'PUBLIC_SITE'      : 'Public site',
          'CUSTOMISE_WIDGETS': 'Customise widgets',
          'SINGLE_WIDGET'    : 'Single widget',
          'BOOK_NOW_BUTTONS' : '\'Book Now\' buttons',
          'OTHER_TOOLS'      : 'Other tools'
        }
      }
    }
  })

]);