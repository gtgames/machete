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
    // Editor
    head.js("http://frenzart.com/js/ckeditor/ckeditor.js", function(){
      window.CKEDITOR_BASEPATH = '/js/ckeditor/';
      $$('textarea').each(function(e){
        CKEDITOR.replace(e.get('name'), {
          lang: 'it',
          skin: 'v2',
          
          toolbar_Full: [
            ['Source', '-', 'Preview', '-'],
            ['Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'Print', 'SpellChecker'], //, 'Scayt' 
            ['Undo', 'Redo', '-', 'Find', 'Replace', '-', 'SelectAll', 'RemoveFormat'],
            '/',
            ['Bold', 'Italic', 'Underline', 'Strike', '-', 'Subscript', 'Superscript'],
            ['NumberedList', 'BulletedList', '-', 'Outdent', 'Indent', 'Blockquote'],
            ['JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock'],
            ['Link', 'Unlink', 'Anchor'],
            ['Image', 'Table', 'HorizontalRule', 'SpecialChar'],
            '/',
            ['Styles', 'Format', 'Templates'],
            ['Maximize', 'ShowBlocks']
          ],
          
          startupFocus: false,
          
          filebrowserBrowseUrl: '/media_browser/',
          filebrowserImageWindowWidth: '760',
          filebrowserImageWindowHeight: '480'
        });
      });
    });
  }
});