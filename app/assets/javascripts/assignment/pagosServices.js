var pagosServices = angular.module('pagosServices', []);

pagosServices.factory('pagosAgent', ['$http', function($http){

return {
  getGeographies: function() {
    return $http.get('/geographies')}
  };

}]);
