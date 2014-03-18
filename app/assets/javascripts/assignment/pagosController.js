var pagosController = angular.module('pagosController', []);

pagosController.controller('assignmentController', ['$scope', 'pagosAgent', function($scope, pagosAgent){
  pagosAgent.getGeographies().then(function(geographies){
    $scope.geographies = geographies.data;

    $scope.provinces = [];
    $scope.geographies.forEach(function(item){
      if ( $scope.provinces.indexOf(item.provincia) === -1  ){
        $scope.provinces.push(item.provincia)
      };
    });

    $scope.selectedProvince = $scope.provinces[0];
  });
}]);
