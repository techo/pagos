'use strict';

describe("Assigments Controllers", function(){
  var pagosAgent;
  var geographies = {'geografia': 'pepe'};

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
      controller = $controller('AssignmentController', { '$scope': scope, 'pagosAgent': pagosAgent })
    }));

    it('should assign geographies to scope', function(){
      scope.$apply();
      expect(scope.geographies).toBe(geographies);
    });

  });
});
