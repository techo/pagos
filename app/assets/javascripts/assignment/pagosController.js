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
        $scope.assignments = assigned_volunteers.data;
        updateVolunteerSelection();
      });
    });
  }

  function updateVolunteerSelection(){
    $scope.volunteers.forEach(function(volunteer){
      setSelectedVolunteer(volunteer);
    });
  }

  function setSelectedVolunteer(volunteer){
    volunteer.selected = false;
    $scope.assignments.forEach(function(assignment){
      if(assignment.volunteer_id == volunteer.id)
        volunteer.selected = true;
    })
  };

  function getAssignmentIdForVolunteer(volunteerId){
    var result = -1;
    var index = 0;
    var length = $scope.assignments.length;
    while(index < length && result == -1){
      if($scope.assignments[index].volunteer_id == volunteerId)
        result = $scope.assignments[index].id;
      index++;
    }
    return result;
  }

  $scope.saveAssignment = function(volunteer){
    var idAsentamiento = $scope.selectedVillage.idAsentamiento;
    if(volunteer.selected){
      volunteerAgent.saveVolunteerAssignment(volunteer.id, idAsentamiento);
      setupSelectedVillageWatch();
    }
    else{
      var assignmentId = getAssignmentIdForVolunteer(volunteer.id);
      volunteerAgent.removeVolunteerAssignment(assignmentId);
    }
  };
}]);
