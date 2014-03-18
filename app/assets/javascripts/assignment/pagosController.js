var pagosController = angular.module('pagosController', []);

pagosController.controller('assignmentController', ['$scope', '$filter', 'pagosAgent', function($scope, $filter, pagosAgent){
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

}]);
