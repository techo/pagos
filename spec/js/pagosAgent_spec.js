'use strict';

describe('pagosServices', function(){

  beforeEach(module('pagosServices'));

  describe('pagosAgent', function(){
    var http, service;
    var PILOTES_GEOGRAPHIES = 'https://pilotes.ec:8080/api/v1/asentamiento?pais=10';
    var response = [{"idAsentamiento":"2387","asentamiento":"Quingeo","ciudad":"Cuenca","provincia":"Azuay"}];

    beforeEach(inject(function(_$httpBackend_, pagosAgent){
      console.log(pagosAgent);
      console.log('Hola mundo');
      http = _$httpBackend_;
      http.when(PILOTES_GEOGRAPHIES).respond(response);
      service = pagosAgent;
    }));


    it('should return geographies from rest service', function() {
      service.getGeographies().then(function(geographies){
        expect(geographies).toBe(response);
      });
    });
  });
});
