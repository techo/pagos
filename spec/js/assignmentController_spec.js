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

    beforeEach(inject(function($rootScope, $controller){
      scope = $rootScope.$new();
      controller = $controller('assignmentController', { '$scope': scope, 'pagosAgent': pagosAgent })
    }));

    it('should assign geographies to scope', function(){
      scope.$digest();
      expect(scope.geographies).toBe(geographies.data);
    });

    it('should assign provinces from geographies', function(){
      scope.$digest();
      expect(scope.provinces).toEqual(provinces)
    });

    it('should have a selected province', function(){
      scope.$digest();
      expect(scope.selectedProvince).toBe(provinces[0]);
    });

  });
});
