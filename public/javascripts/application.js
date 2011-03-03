head.ready(function(){
  var domain = window.location.hostname.match(/(\w*\.\w*)$/)[1],
      mto = $('mailto');
  mto.set('href', 'mailto:info@' + domain);
  mto.set('text', 'info@' + domain);

  new Request.JSON({url: '/tags/json', onSuccess: function(tags){
    var sum = 0;
    tags.each(function(t){
      sum += t.size;
    });
    tags.each(function(t){
      new Element('a.tag', {
        href: '/tags/?t=' + t.tag.replace(/\s+/, '+'),
        style: "font-size:" + (t.size/(sum/tags.length))*100 + '%',
        text: t.tag
      }).inject($('tags'));
    });
  }}).get();
});