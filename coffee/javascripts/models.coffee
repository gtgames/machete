class Post extends Backbone.Model
  name: 'post'
  url: ->
    base = 'posts'
    if (@isNew())
      return base
    return base + (base.charAt(base.length - 1) == '/' ? '' : '/') + @id

class Posts extends Backbone.Collection
  model: Post
  url: '/post/'


class Page extends Backbone.Model
  name: 'page'
  url: ->
    base = 'pages'
    if (@isNew())
      return base
    return base + (base.charAt(base.length - 1) == '/' ? '' : '/') + @id

class Pages extends Backbone.Collection
  model: Page
  url: '/pages/'


class Menu extends Backbone.Model
  name: 'menu'
  url: ->
    base = 'menus'
    if (@isNew())
      return base
    return base + (base.charAt(base.length - 1) == '/' ? '' : '/') + @id

class Menus extends Backbone.Collection
  model: Menu
  url: '/menus/'


class Account extends Backbone.Model
  name: 'account'
  url: ->
    base = 'accounts'
    if (@isNew())
      return base
    return base + (base.charAt(base.length - 1) == '/' ? '' : '/') + @id

class Accounts extends Backbone.Collection
  model: Account
  url: '/accounts/'