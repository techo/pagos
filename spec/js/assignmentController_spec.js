'use strict';

describe("Assigments Controllers", function(){
  var pagosAgent;
  var geographies = {"data":[{"idAsentamiento":"2387","asentamiento":"Quingeo","ciudad":"Cuenca","provincia":"Azuay"},{"idAsentamiento":"3198","asentamiento":"Collana","ciudad":"Ludo, Sigsig","provincia":"Azuay"}, {"idAsentamiento":"3198","asentamiento":"San Juan","ciudad":"Riobamba","provincia":"Chimborazo"}]};
  var provinces = ['Azuay', 'Chimborazo']

  beforeEach(module('pagosController'));

  beforeEach(module(function($provide){
    $provide.value('pagosAgent', pagosAgent);
  }));

  beforeEach(inject(function($q){
    pagosAgent = { getGeographies: function(){ 
      var deferred = $q.defer();
      deferred.resolve(geographies);
      return deferred.promise;
    }};
  }));

  describe("AssigmentController", function(){
    var scope, controller;

    beforeEach(inject(function($rootScope, $filter, $controller){
      scope = $rootScope.$new();
      controller = $controller('assignmentController', { '$scope': scope, '$filter': $filter, 'pagosAgent': pagosAgent })
      scope.$digest();
    }));

    it('should assign provinces from geographies', function(){
      expect(scope.provinces).toEqual(provinces)
    });

    it('should have a selected province', function(){
      expect(scope.selectedProvince).toBe(provinces[0]);
    });

    it('should filter geographies for selected province', function(){
      var expectedGeographies = [geographies.data[0], geographies.data[1]];

      expect(scope.geographies).toEqual(expectedGeographies);
    });

    it('should have a selected village by default', function(){
      scope.selectedProvince = provinces[1];
      scope.$digest();
      expect(scope.selectedVillage).toBe(geographies.data[2]);
    });

  });
});