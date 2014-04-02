var pagosController = angular.module('pagosController', []);

pagosController.controller('assignmentController', ['$scope', '$filter', 'pagosAgent', 'volunteerAgent', function($scope, $filter, pagosAgent, volunteerAgent){
  pagosAgent.getGeographies().then(function(geographies){

    $scope.provinces = [];
    $scope.geographies = [];
    geographies.data.forEach(function(item){
      if ( $scope.provinces.indexOf(item.provincia) === -1 ){
        $scope.provinces.push(item.provincia)
      };
    });

    $scope.selectedProvince = $scope.provinces[0];

    $scope.$watch('selectedProvince', function(newValue, oldValue){
      $scope.geographies = $filter('filter')(geographies.data, {'provincia': newValue});
      $scope.selectedVillage = $scope.geographies[0];
    });
  });

  volunteerAgent.getVolunteers().then(function(volunteers) {
    volunteers.data.forEach(function(volunteer){
      setupSelectedVillageWatch();
    });

    $scope.volunteers = volunteers.data;
  });

  function setupSelectedVillageWatch(){
    $scope.$watch('selectedVillage', function(newValue, oldValue){
      volunteerAgent.getVolunteersAssignedToGeography(newValue.idAsentamiento)
      .then(function(assigned_volunteers){
        $scope.volunteers.forEach(function(volunteer){
          volunteer.selected = (assigned_volunteers.data.indexOf(volunteer.id) != -1);
        });
      });
    });
  }

  $scope.saveAssignment = function(volunteerId){
    idAsentamiento = $scope.selectedVillage.idAsentamiento;
    volunteerAgent.saveVolunteerAssignment(volunteerId, idAsentamiento);
  };
}]);
