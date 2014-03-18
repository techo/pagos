var pagosController = angular.module('pagosController', []);

pagosController.controller('assignmentController', ['$scope', 'pagosAgent', function($scope, pagosAgent){
  pagosAgent.getGeographies().then(function(geographies){
    $scope.geographies = geographies.data;
  });
}]);
