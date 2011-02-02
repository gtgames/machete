head.js("http://frenzart.com/js/cereabox/cereabox.js",function(){
  Asset.css("http://frenzart.com/js/cereabox/style/cerabox.css").inject(document.body);
  var box = new CeraBox({
    displayTitle:     true,
  	displayOverlay:   true,
  	clickToClose:     true,
  	fullSize:         true,
  	group:			      true,
  	errorLoadingMessage:	'Il contenuto non puo essere caricato!'
  });
  box.addItems('#photos a');
});