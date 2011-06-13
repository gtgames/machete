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

    function string_to_slug(str) {
      str = str.replace(/^\s+|\s+$/g, ''); // trim
      str = str.toLowerCase();
      // remove accents, swap ñ for n, etc
      var from = "àáäâèéëêìíïîòóöôùúüûñç·/_,:;";
      var to   = "aaaaeeeeiiiioooouuuunc------";
      for (var i=0, l=from.length ; i<l ; i++) {
        str = str.replace(new RegExp(from.charAt(i), 'g'), to.charAt(i));
      }
      str = str.replace(/[^a-z0-9 -]/g, '') // remove invalid chars
        .replace(/\s+/g, '-') // collapse whitespace and replace by -
        .replace(/-+/g, '-'); // collapse dashes
      return str;
    }
    var that = this;
    this.userChanged = false;

    this.bind('change keyup blur', function(e){
      if (!that.userChanged) {
        $(target).attr(
          'value',
          string_to_slug($(this).attr('value'))
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


  if($("#taxonomy_parent_id").length){
    $.getJSON('/taxonomy/tree.js', function(tree) {
      $('input[name=_dummy]').optionTree(tree, {
        choose: "Scegli...",
        preselect: {'_dummy': "---"}
      }).change(function(){ $('input[name="taxonomy[parent_id]"]').attr('value', this.value); });
    });
  }

})(jQuery);

