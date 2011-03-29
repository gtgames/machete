###
 Posts
###

class View.Posts.Index extends Backbone.View
  initialize: ->
    @ac = @options.documents;
    @render()
    
  render: ->
    new Request.HTML
      url: '/posts/tpl'
      onSuccess: (data)->
        $('main').set('html', Mustache.to_html(data, {
          title: model.
        }))
    .get kind:'index'

class View.Posts.Edit extends Backbone.View
  initialize: ->
    @ac = this.options.documents;
    @render()

  render: ->
    new Request.HTML
      url: '/posts/tpl'
      onSuccess: (data)->
        $('main').set('html', Mustache.to_html(data, view))
    .get kind:'form'

###
 Pages
###

class App.View.Pages.Index extends Backbone.View
  initialize: ->
    @posts = @options.posts;
    @render()
  render: ->
    @template = Mustache.to_html $('pages_index'),
      title:''
    $('main').set 'html', @template

class App.View.Pages.Edit extends Backbone.View
  initialize: ->
    @render()
  render: ->
    @template = Mustache.to_html $('pages_index'),
      title:''
    $('main').set 'html', @template

###
 Menus
###

class App.View.Menu.Index extends Backbone.View
  initialize: ->
    @render()
  render: ->
    @template = Mustache.to_html $('menu_index'), {}
    $('main').set 'html', @template

class App.View.Menu.Edit extends Backbone.View
  initialize: ->
    @render()
  render: ->
    @template = Mustache.to_html $('menu_form'), {}
    $('main').set 'html', @template

class App.View.Menu.Tree extends Backbone.View
  initialize: ->
    @render()
  render: ->
    @template = Mustache.to_html $('menu_tree'), {}
    $('main').set 'html', @template

###
  Media
###

class App.View.Media.Index extends Backbone.View
  initialize: ->
    @render()
  render: ->
    @template = Mustache.to_html $('media_index'), {}
    $('main').set 'html', @template

class App.View.Media.Edit extends Backbone.View
  initialize: ->
    @render()
  render: ->
    @template = Mustache.to_html $('media_form'), {}
    $('main').set 'html', @template
