class App.Controllers.Worksbench extends Backbone.Controller
  routes:
    "":     "index"
    "help":  "help"

  index: ->
  help: ->
    


class App.Controllers.Menus extends Backbone.Controller
  routes:
    "menus/":     "index"
    "menus/:id":  "edit"
    "menus/new":  "new"
    "menus/tree":  "tree"

  index: ->
    new Request.JSON
      url: '/menus'
      onSuccess: (data)->
        @posts = _(data).map (i)->
          new Menu(i)
        new Views.Menu.Index
          menus: @menus
      onError: (error)->
        new Error message: "Error loading Menus: #{error}"
    .get()
  new: ->
    new Menu.Form model: new Menu
  edit: (id)->
    @menu = new Menu({id: id})
    @menu.fetch
      onSuccess: (model,resp)->
        new App.Views.Menu.Edit model: post
      onError: ->
        new Error message: 'Post not found'
        window.location.hash = '#/menus/'

class App.Controllers.Pages extends Backbone.Controller
  routes:
    "pages/":     "index"
    "pages/:id":  "edit"
    "pages/new":  "new"
    "pages/tree":  "tree"

  index: ->
    new Request.JSON
      url: '/pages'
      onSuccess: (data)->
        @posts = _(data).map (i)->
          new Menu(i)
        new Views.Menu.Index
          pages: @pages
      onError: (error)->
        new Error message: "Error loading Menus: #{error}"
    .get()
  new: ->
    new Views.Menu.Form model: new Post
  edit: (id)->
    @page = new Menu({id: id})
    @page.fetch
      success: (model,resp)->
        new App.Views.Menu.Edit model: post
      error: ->
        new Error message: 'Post not found'
        window.location.hash = '#/pages/'
