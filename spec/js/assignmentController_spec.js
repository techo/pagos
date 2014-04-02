'use strict';

describe("Assigments Controllers", function(){
  var pagosAgent, volunteerAgent;
  var geographies = {"data":[{"idAsentamiento":"2387","asentamiento":"Quingeo","ciudad":"Cuenca","provincia":"Azuay"},{"idAsentamiento":"3198","asentamiento":"Collana","ciudad":"Ludo, Sigsig","provincia":"Azuay"}, {"idAsentamiento":"3198","asentamiento":"San Juan","ciudad":"Riobamba","provincia":"Chimborazo"}]};
  var volunteers = {"data": [{"id":3,"email":"ana@ana.com","first_name":"ana","last_name":"ana","role":"voluntario"},{"id":2,"email":"pepe@gmail.com","first_name":"Pepe","last_name":"Pepe","role":"voluntario"}]};
  var provinces = ['Azuay', 'Chimborazo']
  var assigned =  {"data": [{"id":17,"volunteer_id":3,"geography_id":1},{"id":18,"volunteer_id":2,"geography_id":1}]};

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

    volunteerAgent = { 
      getVolunteers: function(){
        var deferred = $q.defer();
        deferred.resolve(volunteers);
        return deferred.promise;
      },
      getVolunteersAssignedToGeography: function(value){
        var deferred = $q.defer();
        deferred.resolve(assigned);
        return deferred.promise;
      },
      saveVolunteerAssignment: function(volunteerId, geographyId){
        var deferred = $q.defer();
        deferred.resolve({result: 'OK'});
        return deferred.promise;
      },
      removeVolunteerAssignment: function(assignmentId){
        var deferred = $q.defer();
        deferred.resolve({result: 'OK'});
        return deferred.promise;
      }};
  }));

  describe("AssigmentController", function(){
    var scope, controller;

    beforeEach(inject(function($rootScope, $filter, $controller){
      scope = $rootScope.$new();
      spyOn(volunteerAgent, 'saveVolunteerAssignment');
      spyOn(volunteerAgent, 'removeVolunteerAssignment');
      controller = $controller('assignmentController', { '$scope': scope,'pagosAgent': pagosAgent, 'volunteerAgent': volunteerAgent })
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

    it('should assign volunteers to the scope', function(){
      expect(scope.volunteers).toBe(volunteers.data);
    });

    describe('#setupSelectedVillageWatch', function(){
      it('should select volunteers that have been assigned to selected geography', function(){
        scope.selectedVillage = geographies.data[0];
        scope.$digest();
        assigned.data.forEach(function(assignment){
          scope.volunteers.forEach(function(volunteer){
            if (volunteer.id == assignment.volunteer_id)
              expect(volunteer.selected).toEqual(true);
          });
        });
      });

      it('should assignments to scope for selected geography', function(){
        scope.selectedVillage = geographies.data[0];
        scope.$digest();
        expect(scope.assignments).toBe(assigned.data);
      });
    });

    describe("assigmentSave", function(){
      it('if selected should assign a volunteer to selected village', function(){
        var volunteer = volunteers.data[0];
        volunteer.selected = true;
        scope.saveAssignment(volunteer);
        expect(volunteerAgent.saveVolunteerAssignment).toHaveBeenCalledWith(volunteer.id, geographies.data[0].idAsentamiento);
      });

      it('if unselected should assign a volunteer to selected village', function(){
        var volunteer = volunteers.data[0];
        volunteer.selected = false;
        var assignmentId = assigned.data[0].id;
        scope.saveAssignment(volunteer);
        expect(volunteerAgent.removeVolunteerAssignment).toHaveBeenCalledWith(assignmentId);
      });
    });
  });
});
