//= require knockout
//= require knockout.mapping

var viewModel = {
  provinces: ko.observableArray(),
  geographies: ko.observableArray(),
  selectedProvince: ko.observable(),
  selectedVillage: ko.observable(),
  localities: ko.observableArray(),
  volunteers: ko.observableArray(),
  flash: ko.observable(),
  shownOnce: ko.observable(),
  currentPage: ko.observable(),
  errors: ko.observableArray(),
  items: ko.observableArray(),
  selectedItem: ko.observable(),
  myMessage: ko.observableArray([
    { name: "Bungle", type: "Bear" },
    { name: "George", type: "Hippo" },
    { name: "Zippy", type: "Unknown" }
]),
  tempItem: {
    id: ko.observable(),
    title: ko.observable(),
    body: ko.observable(),
    updated_at: ko.observable(),
    created_at: ko.observable()
  },
  
  setFlash: function(flash) {
    this.flash(flash);
    this.shownOnce(false);
  },
  checkFlash: function() {
    if (this.shownOnce() == true) {
      this.flash('');
    }
  },
  indexAction: function() {
    this.checkFlash();
    $.getJSON('/geographies', function(data) {
      var categories = [];
      $.each(data, function(index, value) {
          try {
            dato =  decodeURIComponent(escape(value["provincia"]));
          } catch (e) {
            dato = value["provincia"]
          }
          dato = dato.toUpperCase();
          if ($.inArray(dato, categories)==-1) {
            categories.push(dato);
        }
      })
      viewModel.geographies(data);
      viewModel.provinces(categories);
      viewModel.selectedProvince(categories[0]);
    });
  },
  indexVolunteersAction: function() {
    this.checkFlash();
    $.getJSON('/volunteers', function(data) {

      viewModel.volunteers(ko.mapping.fromJS(data));
    });
  },
  createAction: function(itemToCreate) {
    var json_data = ko.toJS(itemToCreate);
    $.ajax({
      type: 'POST',
      url: '/geographies',
      data: {
        assingment: json_data
      },
      dataType: "json",
      success: function(createdItem) {
        viewModel.errors([]);
        viewModel.setFlash('Post successfully created.');
      },
      error: function(msg) {
        viewModel.errors([msg.statusText]);
      }
    });
  },
  updateAction: function(itemToUpdate) {
    var json_data = ko.toJS(itemToUpdate);
    delete json_data.id;
    delete json_data.created_at;
    delete json_data.updated_at;

    $.ajax({
      type: 'PUT',
      url: '/posts/' + itemToUpdate.id() + '.json',
      scriptCharset: "utf-8" ,
      contentType: "application/x-www-form-urlencoded; charset=UTF-8",
      data: {
        post: json_data
      },
      dataType: "json",
      success: function(updatedItem) {
        viewModel.errors([]);
        viewModel.setFlash('Post successfully updated.');
        viewModel.showAction(updatedItem);
      },
      error: function(msg) {
        viewModel.errors(JSON.parse(msg.responseText));
      }
    });
  },
  destroyAction: function(itemToDestroy) {
    if (confirm('Are you sure?')) {
      $.ajax({
        type: "DELETE",
        url: '/posts/' + itemToDestroy.id + '.json',
        dataType: "json",
        success: function(){
          viewModel.errors([]);
          viewModel.setFlash('Post successfully deleted.');
          viewModel.indexAction();
        },
        error: function(msg) {
          viewModel.errors(JSON.parse(msg.responseText));
        }
      });
    }
  }
};

viewModel.localities = ko.computed(function() {
    return ko.utils.arrayFilter(viewModel.geographies(), function(geography) {
      try {
            dato =  decodeURIComponent(escape(geography["provincia"]));
          } catch (e) {
            dato = geography["provincia"]
          }

      return dato.toUpperCase() == viewModel.selectedProvince();
  });
});

var ready = function() {
  viewModel.indexAction();
  viewModel.indexVolunteersAction();
  ko.applyBindings(viewModel, document.getElementById("container"));
  $("#provinces option:first").attr('selected','selected');
  $("#localities option:first").attr('selected','selected');
};

$(document).ready(ready);
$(document).on('page:load', ready);
