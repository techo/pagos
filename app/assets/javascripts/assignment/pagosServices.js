var pagosServices = angular.module('pagosServices', []);

pagosServices.factory('pagosAgent', ['$http', function($http){

  return {
    getGeographies: function() {
      return $http.get('/geographies')
    }
  };
}]);

pagosServices.factory('volunteerAgent', ['$http', function($http){
  return {
    getVolunteers: function() {
      return $http.get('/volunteers')
    },
    getVolunteersAssignedToGeography: function(geographyId){
      return $http.get('/assignments/' + geographyId);
    },
    saveVolunteerAssignment: function(volunteerId, geographyId){
      var data =  {data: {volunteer_id: volunteerId, village_id: geographyId}};
      return $http.post('/assignments/', data);
    },
    removeVolunteerAssignment: function(volunteerId, geographyId){
      var params =  {data: {volunteer_id: volunteerId, village_id: geographyId}};
      return $http.delete('/assignments/', params);
    }
  }
}]);
