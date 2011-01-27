head.ready(function(){
  var domain = window.location.hostname.match(/(\w*\.\w*)$/)[1],
      mto = $('mailto');
  mto.set('href', 'mailto:info@' + domain);
  mto.set('text', 'info@' + domain);
});