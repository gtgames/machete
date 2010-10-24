$(window).addEvent('domready', function(){
  $$('textarea').each(function(e) {
    e.mooEditable({
      actions: 'bold italic underline strikethrough | insertunorderedlist insertorderedlist | indent outdent | urlimage createlink unlink | undo redo | toggleview'
    });
  });

  if ($('menu_weigth') != undefined) {
    var weight_input = $('menu_weigth'),
        slider = new Slider('weigth_slider', 'weigth_knob', {
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
});