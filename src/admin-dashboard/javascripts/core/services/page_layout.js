// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/**
* @ngdoc service
* @name BBAdminDashboard.PageLayout
*
* @description
* This service exposes layout functionality variables
*
*/
angular.module('BBAdminDashboard').factory('PageLayout', [
  'AdminCoreOptions',
  function(AdminCoreOptions) {
    return {
      hideSideMenuControl    : this.hideSideMenuControl ? this.hideSideMenuControl : AdminCoreOptions.deactivate_sidenav,
      hideBoxedLayoutControl : this.hideBoxedLayoutControl ? this.hideBoxedLayoutControl : AdminCoreOptions.deactivate_boxed_layout,
      sideMenuOn             : this.sideMenuOn ? this.sideMenuOn : (AdminCoreOptions.sidenav_start_open && !AdminCoreOptions.deactivate_sidenav),
      boxed                  : this.boxed ? this.boxed :  AdminCoreOptions.boxed_layout_start
    };
  }
]);
