var pagosServices = angular.module('pagosServices', []);

pagosServices.controller('AssignmentController', ['$scope', 'pagosAgent', function($scope, pagosAgent){
  pagosAgent.getGeographies().then(function(geographies){
    $scope.geographies = geographies;
  });
}]);
