'use strict';

describe('pagosServices', function(){

  beforeEach(module('pagosServices'));

  describe('volunteerAgent', function(){
    var http, service, scope;
    var PILOTES_VOLUNTEERS = '/volunteers';
    var PILOTES_ASSIGNMENTS = '/assignments/';
    var volunteers_response = [{"id":3,"email":"ana@ana.com","first_name":"ana","last_name":"ana","role":"voluntario"},{"id":2,"email":"pepe@gmail.com","first_name":"Pepe","last_name":"Pepe","role":"voluntario"}];
    var assigned_response = [1,2,3];
    var geographyId = 124;

    beforeEach(inject(function(_$httpBackend_, volunteerAgent, $rootScope){
      http = _$httpBackend_;
      http.whenGET(PILOTES_VOLUNTEERS).respond(volunteers_response);
      var url = PILOTES_ASSIGNMENTS + geographyId;
      http.whenGET(url).respond(assigned_response);
      service = volunteerAgent;
      scope = $rootScope.$new();
      scope.$digest();
    }));

    describe('#getVolunteers', function(){
      it('should return all volunteers from rest service', function(){
        service.getVolunteers().then(function(volunteers){
          expect(volunteers).toBe(volunteers_response);
        });
      });
    });

    describe('#getVolunteersAssignedToGeography', function(){
      it('should return all assigned volunteers ids for selected geography', function(){
        service.getVolunteersAssignedToGeography().then(function(assigments){
          expect(assigments).toBe(assigned_response);
        });
      });
    });

    describe('#saveVolunteerAssignment', function(){
      it('should save volunteer assigment to geography', function(){
        var volunteerId = 1;
        var data = {data: {volunteer_id: volunteerId, village_id: geographyId}};
        http.expectPOST(PILOTES_ASSIGNMENTS, data).respond(201,'');
        service.saveVolunteerAssignment(volunteerId, geographyId);
        http.flush();
      });
    });
  });
});

