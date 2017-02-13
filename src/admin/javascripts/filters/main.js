// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
let bbAdminFilters = angular.module('BBAdmin.Filters', []);


bbAdminFilters.filter('rag', () =>

  function(value, v1, v2) {
   if (value <= v1) {
      return "red";
    } else if (value <=v2) {
      return "amber";
    } else {
      return "green";
    }
 }
);


bbAdminFilters.filter('gar', () =>

  function(value, v1, v2) {
   if (value <= v1) {
      return "green";
    } else if (value <=v2) {
      return "amber";
    } else {
      return "red";
    }
 }
);


bbAdminFilters.filter('time', $window =>

  v => $window.sprintf("%02d:%02d",Math.floor(v / 60), v%60 )
);

