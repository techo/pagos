//= require knockout
//= require knockout.mapping

var viewModel = {
  provinces: ko.observableArray(),
  geographies: ko.observableArray(),
  selectedProvince: ko.observable(),
  selectedVillage: ko.observable(),
  localities: ko.observableArray(),
  volunteers: ko.observable(),
  flash: ko.observable(),
  shownOnce: ko.observable(),
  errors: ko.observableArray(),
    
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
      var mapping = {
        create: function (options) {
          var innerModel = ko.mapping.fromJS(options.data);
          innerModel.assigned = ko.observable(false);
          return innerModel;
        }
      };
      viewModel.volunteers(ko.mapping.fromJS(data, mapping)());
    })},

  createAction: function(volunteer) {
    var json_data =
      {
      volunteer_id: volunteer.id,
      village_id:viewModel.selectedVillage()
    };
    $.ajax({
      type: 'POST',
      url: '/assignments',
      data: {
        data: json_data
      },
      dataType: "json",
      success: function(createdItem) {
        viewModel.volunteers( viewModel.volunteers().sort(viewModel.assignedComparator) );
        viewModel.errors([]);
        viewModel.setFlash('Post successfully created.');
      },
      error: function(msg) {
        viewModel.errors([msg.statusText]);
      }
    });
  },

  showAction: function(itemToShow) {
    $.ajax({
      type: 'GET',
      url: '/assignments/' + itemToShow,
      scriptCharset: "utf-8" ,
      contentType: "application/x-www-form-urlencoded; charset=UTF-8",
      dataType: "json",
        success: function(volunteers) {
          ko.utils.arrayForEach(viewModel.volunteers(), function(volunteer) {
            indice = volunteers.indexOf(parseInt(volunteer.id()));
            isAssignedUser = indice>=0;
            volunteer.assigned(isAssignedUser);
          })
          viewModel.volunteers( viewModel.volunteers().sort(viewModel.assignedComparator) );
          viewModel.errors([]);
          viewModel.setFlash('Post successfully updated.');
        },
        error: function(msg) {
          viewModel.errors(JSON.parse(msg.responseText));
        }
      });
    },

  assignedComparator: function(left, right) {
    var nameLeft=left.first_name().toLowerCase(), nameRight=right.first_name().toLowerCase();
    var nameorder = nameLeft === nameRight ? 0 : (nameLeft < nameRight ? -1 : 1);
    
    if(
        (left.assigned() && right.assigned()) || 
        (!left.assigned() && !right.assigned())
    ) {
        return nameorder;
    } else if(left.assigned()) {
        return -1;
    } else {
        return 1;
    }
  }
};

viewModel.selectedVillage.subscribe(function(newValue) {
  viewModel.showAction(newValue);
});

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

(function($, window, document) {
  viewModel.indexAction();
  viewModel.indexVolunteersAction();
  ko.applyBindings(viewModel, document.getElementById("container"));
 }(window.jQuery, window, document));

