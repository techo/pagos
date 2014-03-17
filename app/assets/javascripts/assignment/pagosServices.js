var pagosServices = angular.module('pagosServices', []);

pagosServices.factory('pagosAgent', ['$http', function($http){

return {
  getGeographies: function() {
        return $http.get('https://pilotes.ec:8080/api/v1/asentamiento?pais=10')}
  };

}]);
