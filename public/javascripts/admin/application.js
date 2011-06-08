;(function($){
  $(document).ready(function(){
    /*$("input:focus").simpletip({
      position: 'top',
      onShow: function(){
      this.getParent().text('My content changes when my tooltip appears!');
      }
    });*/

    $('#advanced>div').toggle();
    $('#advanced').find('legend').click(function(e){
      $('#advanced>div').toggle();
    });

    $('.invalid').parent().find('label').css({
      color: 'red'
    });

    if ($('textarea[name*="[tags]"').length){
      //$('input[name*="[tag_list]"]').hide();
      $.getJSON('/base/tagblob.js', function(data){
        $('textarea[name*="[tags]"]').tagit({
          availableTags: data
        });
      });
    }
    // Async Upload iFrame based
    $('input[type=file]').jsUpload();
  });
})(jQuery);
