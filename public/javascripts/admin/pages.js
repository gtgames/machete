App.Pages.Model = Backbone.Model.extend({
  name: 'page',
  idAttribute: '_id',
  url: function() {
    if (this.isNew())
      return '/pages/';
    else
      return '/pages/' + this.id;
  }
});

App.Pages.Collection = Backbone.Collection.extend({
  model: App.Pages.Model,
  url: '/pages'
});

/*
  Views
*/
App.Pages.Index = Backbone.View.extend({
  el: '#main',
  events: {
    "click a.delete": 'destroy'
  },
  initialize: function(opts) {
    _.bindAll(this, 'render');
    this.template = Handlebars.compile($("script[name=pages_list]").html());
    Pages.collection.bind('refresh', this.render);
    this.render();
  },
  render: function() {
    $(this.el).html(this.template({
      pages: Pages.collection.toJSON()
    }));
    return this;
  },
  destroy: function(evt){
    var target = $(evt.currentTarget);
    var record = Pages.collection.get(target.attr('data-id'));
    
    if (record){
      record.destroy({
        success: function(collection, response) {
          Pages.collection.fetch();
          Growl.push('Documento eliminato.', 'success');
        },
        error: function(collection, response) {
          Pages.collection.fetch();
          Growl.push('Errore! Non &egrave; stato possibile eliminare il documento.', 'success');
        }
      });
    }
    evt.preventDefault();
  }
});

App.Pages.Edit = Backbone.View.extend({
  el: '#main',
  tagName: "li",
  className: "document-row",
  events: {
    "click .button.delete": "destroy",
    "submit form.form":     "save",
    "change input":         "changed",
    "change select":        "changed"
  },
  initialize: function(options) {
    _.bindAll(this, 'render', 'destroy', 'changed', 'save');
    _.extend(this, options);
    this.template = Handlebars.compile($("script[name=pages_form]").html());
    this.render();
  },
  render: function() {
    $(this.el).html(
      this.template(this.model.toJSON())
    );
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
    return window.location.hash = '#!/pages';
  },
  destroy: function(event) {
    if ((this.model.isNew()) ? true : window.confirm("Sei sicuro di voler eliminare la pagina?")) {
      this.model.destroy();
      Growl.push('Pagina eliminata', 'success');
      return window.location.hash = '#!/pages';
    } else {
      return false;
    }
  }
});

/*
  Router
*/
App.Pages.Controller = Backbone.Controller.extend({
  routes: {
    '!/pages':              'index',
    '!/pages/new':          'add',
    '!/pages/:id':          'edit'
  },
  initialize: function() {
    _.bindAll(this, 'index', 'add', 'edit');
    this.collection = new App.Pages.Collection();
  },
  index: function() {
    this.view = new App.Pages.Index();
    this.collection.fetch({
      error: function(collection, response) {
        Growl.push('Errore raccogliendo i dati: ' + response, 'error');
      }
    });
  },
  add: function() {
    this.view = new App.Pages.Edit({
      model: new App.Pages.Model()
    });
  },
  edit: function(id) {
    if (_.size(id) == 0) return window.location.hash = '#!/pages';
    model = this.collection.get(id);
    if (_.isUndefined(model)){
      window.location.hash = '#!/pages';
      return this;
    }
    this.view = new App.Pages.Edit({
      model: model
    });
    return true;
  }
});
