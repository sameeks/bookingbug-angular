'use strict'

###*
* @ngdoc service
* @name BBAdminDashboard.PageLayout
*
* @description
* This service exposes layout functionality variables
*
###
angular.module('BBAdminDashboard').factory 'PageLayout', [
  'AdminCoreOptions',
  (AdminCoreOptions) ->
    {
      hideSideMenuControl    : if @hideSideMenuControl then @hideSideMenuControl else AdminCoreOptions.deactivate_sidenav,
      hideBoxedLayoutControl : if @hideBoxedLayoutControl then @hideBoxedLayoutControl else AdminCoreOptions.deactivate_boxed_layout,
      sideMenuOn             : if @sideMenuOn then @sideMenuOn else (AdminCoreOptions.sidenav_start_open && !AdminCoreOptions.deactivate_sidenav),
      boxed                  : if @boxed then @boxed else  AdminCoreOptions.boxed_layout_start
    }
]
