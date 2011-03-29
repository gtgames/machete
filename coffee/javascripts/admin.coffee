# extension to wrap arguments
maybeUnwrap: (args)->
  if @isWrapped(args)
    @set(this.unwrappedAttributes(args), { silent: true })
    @unset(@_name(), { silent: true })
    @_previousAttributes = _.clone(@attributes)


_.extend Backbone.Model.prototype, Backbone.RailsJSON,
  # This is called on all models coming in from a remote server.
  # Unwraps the given response from the default Rails format.
  parse: (resp)->
    @unwrappedAttributes(resp)
  # This is called just before a model is persisted to a remote server.
  # Wraps the model's attributes into a Rails-friendly format.
  toJSON: ->
    @wrappedAttributes()
  # A new default initializer which handles data directly from Rails as
  # well as unnested data.
  initialize: (args)->
    @maybeUnwrap(args)
## -

class App
  Views: {}
  Controllers: {}
  init: ->
    new App.Controllers.Workbench();
    Backbone.history.start();

$(document).ready ->
  App.init()
  