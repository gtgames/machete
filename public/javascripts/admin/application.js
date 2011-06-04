(function($){
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
    //$('input[name*="[tag_list]"]').hide();
    //  $.get_json('/tagblob.json', function(data){
    $('textarea[name*="[tags]"]').tagit({availableTags:[]});
    //  });
  });
})(jQuery);
