head.ready(function(){
  /*$$('textarea').each(function(e) {
    e.mooEditable({
      actions: 'bold italic underline strikethrough | insertunorderedlist insertorderedlist | indent outdent | image | createlink unlink | undo redo | toggleview'
    });
  });*/
  
  if ($('menu_weight') != null) {
    var weight_input = $('menu_weight');
    var weight_slider = new Element('div#weight_slider').inject(weight_input.getParent());
    var weight_knob = new Element('div#weight_knob').inject(weight_slider);
    var slider = new Slider(weight_slider, weight_knob, {
          range: [0,20],
          snap: true,
          wheel: true,
          initialStep: weight_input.get('value'),
          onComplete: function(pos) {
              weight_input.set('value', pos);
              this.knob.set('text', pos);
            }
        });
    weight_input.setStyle('display', 'none');
    $('weigth_knob').set('text', weight_input.get('value'));
    slider.attach();
  }

  flash = $$('div.message');
  if (flash.lenght) {
    document.body.addEvent('hover', function(){
      setTimeout( function(){
          $$('.message').tween('opacity',1,0);
        }, 3000);
    });
  }
  
  if ($$('textarea').length > 0) {
    tinyMCE.init({
      mode : "textareas",
  		theme : "advanced",
  		plugins : "advhr,advimage,advlink,iespell,inlinepopups,insertdatetime,preview,media,searchreplace,contextmenu,paste,directionality,fullscreen,visualchars,nonbreaking,xhtmlxtras,template,wordcount,advlist",
  		
  		theme_advanced_buttons1 : "bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,formatselect",
  		theme_advanced_buttons2 : "cut,copy,paste,pastetext,pasteword,|,search,replace,|,bullist,numlist,|,outdent,indent,blockquote,|,undo,redo,|,link,unlink,anchor,image,cleanup,code,|,insertdate,inserttime,preview",
  		theme_advanced_buttons3 : "hr,removeformat,visualaid,|,sub,sup,|,iespell,media,advhr,|,print,|,ltr,rtl,|,fullscreen,|,cite,abbr,acronym,del,ins,attribs,|,visualchars",
  		theme_advanced_toolbar_location : "top",
  		theme_advanced_toolbar_align : "left",
  		theme_advanced_statusbar_location : "bottom",
  		theme_advanced_resizing : true,
  		
  		content_css : "stylesheets/style.css",
  		
  		external_link_list_url : "/tree/mce_list.js",
  		
  		style_formats : [
  			{title : 'Bold text', inline : 'strong'}
  		],
  		
      file_browser_callback : function (field_name, url, type, win) {

        var cmsURL = "/media_browser/?type=" + type;

        tinyMCE.activeEditor.windowManager.open({
            file: cmsURL,
            width: 780,  // Your dimensions may differ - toy around with them!
            height: 500,
            resizable: "yes",
            scrollbars: "yes",
            inline: "yes",
            close_previous: "no"
        }, {
            window: win,
            input: field_name,
            editor_id: tinyMCE.selectedInstance.editorId
        });
        return false;
        }
    });
  }
});