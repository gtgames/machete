App.Posts.Model = Backbone.Model.extend({
  name: 'post',
  idAttribute: '_id',
  url: function() {
    return '/posts/edit/' + this.id;
  }
});

App.Posts.Collection = Backbone.Collection.extend({
  model: App.Posts.Model,
  url: '/posts/'
});

/*
  Views
*/
App.Posts.Index = Backbone.View.extend({
  el: '#main',
  events: {
    "click .button.delete": "destroy"
  },
  initialize: function(options) {
    _.bindAll(this, 'render', 'destroy');
    this.template = Handlebars.compile($("script[name=posts_list]").html());
    Posts.collection.bind('refresh', this.render);
  },
  render: function() {
    $(this.el).html(this.template({
      posts: Posts.collection.toJSON()
    }));
    return this;
  },
  destroy: function() {
    var target = $(evt.currentTarget);
    Pages.collection.get(target.attr('value')).destroy({
      success: function(collection, response) {
        Posts.collection.fetch();
        Growl.push('Documento eliminato.', 'success');
      },
      error: function(collection, response) {
        Posts.collection.fetch();
        Growl.push('Errore! Non &egrave; stato possibile eliminare il documento.', 'success');
      },
    });
    evt.preventDefault();
  }
});

App.Posts.Edit = Backbone.View.extend({
  el: '#main',
  events: {
    "click .button.delete": "destroy",
    "submit form.form": "save",
    "change input": "changed",
    "change select": "changed"
  },
  initialize: function(options) {
    this.model = options.model;
    _.bindAll(this, 'render', 'save', 'changed', 'destroy');
    this.template = Handlebars.compile($("script[name=posts_form]").html());
    this.render();
  },
  render: function() {
    $(this.el).html(this.template(this.model.toJSON()));
  },
  changed: function(evt) {
    var target = $(evt.currentTarget),
      data = {};
    data[target.attr('name')] = target.attr('value');
    this.model.set(data);
  },
  save: function(evt) {
    evt.preventDefault();
    this.model.save();
    Growl.push('Pagina salvata', 'success');
    return window.location.hash = '#!/posts';
  },
  destroy: function(event) {
    if ((this.model.isNew()) ? true : window.confirm("Sei sicuro di voler eliminare la pagina?")) {
      this.model.destroy();
      Growl.push('Pagina eliminata', 'success');
      return window.location.hash = '#!/posts';
    } else {
      return false;
    }
  }
});

/*
  Router
*/
App.Posts.Controller = Backbone.Controller.extend({
  routes: {
    '!/posts': 'index',
    '!/posts/new': 'add',
    '!/posts/:id': 'edit'
  },
  initialize: function() {
    _.bindAll(this, 'index', 'add', 'edit');
    this.collection = new App.Posts.Collection();
  },
  index: function() {
    this.view = new App.Posts.Index();
    this.collection.fetch({
      error: function(collection, response) {
        Growl.push('Errore raccogliendo i dati: ' + response, 'error');
      }
    });
  },
  add: function() {
    this.view = new App.Posts.Edit({
      model: new App.Posts.Model()
    });
  },
  edit: function(id) {
    model = this.collection.get(id);
    if (_.isUndefined(model)) {
      window.location.hash = '#!/posts';
      return this;
    }
    this.view = new App.Posts.Edit({
      model: model
    });
    return this;
  }
});
