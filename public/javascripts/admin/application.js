$(document).ready(function(){
  /*$("input:focus").simpletip({
    position: 'top',
    onShow: function(){
      this.getParent().text('My content changes when my tooltip appears!');
    }
  });*/
  
  $('#advanced').find('legend').click(function(e){
    $('#advanced>fieldset').toggle();
  });
  
  $('.invalid').parent().find('label').css({
    color: 'red'
  });
  //$('input[name*="[tag_list]"]').hide();
  $('textarea[name*="[tags]"]').tagit({availableTags:[]});
});