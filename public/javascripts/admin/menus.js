App.Menu.Model = Backbone.Model.extend({
  name: 'link',
  url: '/links/'
});

App.Menu.Collection = Backbone.Collection.extend({
  model: App.Menu.Model,
  url: '/links/'
});

/*
  Views
*/
App.Menu.Index = Backbone.View.extend({
  el: '#main'
});

App.Menu.Edit = Backbone.View.extend({
  events: {
    "submit form": "save"
  },
  el: 'li'
});

/*
  Controller
*/
App.Menu.Controller = Backbone.Controller.extend({
  routes: {
    '!/menu': 'index',
    '!/menu/new': 'add',
    '!/menu/:id$': 'edit'
  },
  index: function() {
    this.view = (new App.Menu.Index({
      collection: (new App.Menu.Collection).fetch()
    }));
  },
  add: function() {
    this.view = (new App.Menu.Edit)({
      model: new App.Menu.Model
    });
  },
  edit: function(id) {
    this.view = (new App.Menu.Edit)({
      model: (new App.Menu.Model).fetch(id)
    });
  }
});
