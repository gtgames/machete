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

    if ($('textarea[name*="[tags]"]').length){
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

  $.fn.slugify = function(target){
    if (!this.length || !$(target).length) return -1;

    var that = this;
    this.userChanged = false;

    this.bind('change keyup blur', function(e){
      if (!that.userChanged) {
        $(target).attr(
          'value',
          $(this).attr('value').toLowerCase().replace(/[^a-z0-9-]+/g, '-').replace(/[-]+/g, '-').replace(/^-|-$/g, '')
        );
      }
    });
    $(target).change(function(e){
      that.userChanged = true;
    });
  };

  var slug = $('input[name*="[slug"]'); //$('input[name*="slug"').filter(function() { return this.id.match(/_slug[\(a-z\)]*/); });
  if (slug.length) {
    $.each(slug, function(){
      var title = $(this).attr('name').replace(/slug/, 'title');
      $('input[name="'+title+'"]').slugify(this);
    });
  }

})(jQuery);

