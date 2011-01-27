head.ready(function() {
  var updater = new Request.JSON({
    url: '/media_browser/refresh/',
    onSuccess: function(item){
      var i = "<div class='icon {mimetype}'></div><div class='name'><a href='{url}'>{name}</a></div>"
      i = i.replace('{mimetype}', item.mimetype);
      i = i.replace('{url}', item.url);
      i = i.replace('{name}', item.url.split('/').getLast());
      var el = new Element('div.item', { html: i}).inject($('list'));
      console.log(el);
    }
  });
  
  var uploader = new qq.FileUploader({
    element: $('upload'),
    action: '/media_browser/create/',
    onComplete: function(id,fileName,response) {
      updater.get({id: response.id});
    },
    debug: true,
    messages: {
      typeError: "Questo file: {file} ha una estensione non valida. Le estensioni autorizzate sono: {extensions}.",
      sizeError: "{file} &egrave; troppo grande, il peso massimo &egrave; {sizeLimit}.",
      minSizeError: "{file} &egrave; troppo piccolo, il peso minimo &egrave; {minSizeLimit}.",
      emptyError: "{file} &egrave; vuoto.",
      onLeave: "Alcuni file sono in fase di upload, se lasciate la pagina ora gli upload verranno annullati."
    },
    showMessage: function(message) {
      alert(message);
    }
  });

  if (window.location.hash.length > 2)
    var item = $$("a[href=" + window.location.hash.replace('#', '') + "]")[0].getParent('.item').toggleClass("selected");

  function submit(){
    var URL = $$('.item.selected')[0].getElement('a').get('href');
    var win = tinyMCEPopup.getWindowArg("window");
    win.document.getElementById(tinyMCEPopup.getWindowArg("input")).value = URL;
    if (typeof(win.ImageDialog) != "undefined") {
      if (win.ImageDialog.getImageData)
        win.ImageDialog.getImageData();
      if (win.ImageDialog.showPreviewImage)
          win.ImageDialog.showPreviewImage(URL);
    }
    tinyMCEPopup.close();
  }
  $$('.item').addEvents({
    click: function(e) {
      $$('.item').removeClass('selected');
      this.toggleClass('selected');
    },
    dblclick: function(e) { submit(); }
  });
  $('submit').addEvent('click', function(){ submit(); });
});