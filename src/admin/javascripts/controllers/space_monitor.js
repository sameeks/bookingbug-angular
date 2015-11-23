'use strict';


function SpaceMonitorCtrl($scope,  $location) {
  


  $scope.$on("Add_Space", function(event, message){
     $scope.$apply();
   });




}

SpaceMonitorCtrl.$inject = ['$scope', '$location', 'CompanyService'];
