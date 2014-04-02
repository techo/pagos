'use strict';

describe('pagosServices', function(){

  beforeEach(module('pagosServices'));

  describe('pagosAgent', function(){
    var http, service;
    var scope;
    var PILOTES_GEOGRAPHIES = '/geographies';
    var response = {data: [{"idAsentamiento":"2387","asentamiento":"Quingeo","ciudad":"Cuenca","provincia":"Azuay"}]};

    beforeEach(inject(function(_$httpBackend_, pagosAgent, $rootScope){
      http = _$httpBackend_;
      http.whenGET(PILOTES_GEOGRAPHIES).respond(response);
      service = pagosAgent;
      scope = $rootScope.$new();
    }));

    it('should return geographies from rest service', function() {
      service.getGeographies().then(function(geographies){
        expect(geographies).toBe(response);
      });
      scope.$digest();
    });
  });
});
