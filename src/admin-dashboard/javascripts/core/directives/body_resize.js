/**
 * @ngdoc directive
 * @name BBAdminDashboard.directive:bodyResize
 * @scope
 * @restrict A
 *
 * @description
 * Toggle side-menu based on window size
 *
 * @param {object}  field   A field object
*/
angular.module('BBAdminDashboard').directive('bodyResize', ['$window', '$timeout', 'AdminCoreOptions', 'PageLayout', ($window, $timeout, AdminCoreOptions, PageLayout) =>
  ({
    restrict: 'A',
    link(scope, element) {
      $timeout((function() {
        _sideMenuSetup(true);
      }), 0);
      angular.element($window).bind('resize', function() {
        _sideMenuSetup();
      });

      var _sideMenuSetup = function(firstLoad) {
        if (firstLoad == null) { firstLoad = false; }
        if (($window.innerWidth > 768) && (!firstLoad || AdminCoreOptions.sidenav_start_open) && !AdminCoreOptions.deactivate_sidenav) {
          PageLayout.sideMenuOn = true;
        } else {
          PageLayout.sideMenuOn = false;
        }
      };

    }
  })

]);
