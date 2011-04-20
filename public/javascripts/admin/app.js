var Workbench = Backbone.Controller.extend({
  routes: {
    '!/': 'index'
  },
  index: function() {
  }
});

$(function() {
  // bugfix IE8 AJAX Cache
  if ($.browser.ie)  $.ajaxSetup({ cache: false });

  if (window.location.hash == '') window.location.hash = '#!/';

  window.Growl = new MiniGrowl();
  window.Pages = new App.Pages.Controller();
  window.Posts = new App.Posts.Controller();
  window.Menu = new App.Menu.Controller();
  window.Cards = new App.Card.Controller();
  new Workbench();
  Backbone.history.start();
});
