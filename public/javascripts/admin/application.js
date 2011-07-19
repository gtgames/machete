;;(function($) {
  $(document).ready(function() {
    /*$("input:focus").simpletip({
      position: 'top',
      onShow: function(){
      this.getParent().text('My content changes when my tooltip appears!');
      }
      });*/

    $('#advanced>div').toggle();
    $('#advanced').find('legend').click(function(e) {
      $('#advanced>div').toggle();
    });

    $('.invalid').parent().find('label').css({
      color: 'red'
    });

    if ($('textarea[name*="[tags]"]').length) {
      //$('input[name*="[tag_list]"]').hide();
      $.getJSON('/base/tagblob.js', function(data) {
        $('textarea[name*="[tags]"]').tagit({
          availableTags: data
        });
      });
    }

    $('input[type=file]').each(function(i, el) {
      var myid = $(el).attr('id'),
      myname = $(el).attr('name'),
      input = $('<input type="hidden" value="">').appendTo($(el).parent()),
      div = $('<div class="upload_button">Upload</div>').appendTo($(el).parent());

    $(el).remove();
    div.attr('id', myid);
    input.attr('name', myname);

    var uploader = new qq.FileUploader({
      debug: true,
        element: div[0],
        action: '/base/upload',
        onComplete: function(id, name, resp) {
          if (resp.error) {
            var ul = $('<ul class="errors">');
            $.each(resp.error, function(el) {
              $('<li>').html(el).appendTo(ul);
            });
            ul.appendTo(div);
          } else {
            input.attr('value', resp.success)
          }
        }
    });
    });

    $.fn.slugify = function(target) {
      if (!this.length || ! $(target).length) return - 1;

      function string_to_slug(str) {
        str = str.replace(/^\s+|\s+$/g, ''); // trim
        str = str.toLowerCase();
        // remove accents, swap ñ for n, etc
        var from = "àáäâèéëêìíïîòóöôùúüûñç·/_,:;";
        var to = "aaaaeeeeiiiioooouuuunc------";
        for (var i = 0, l = from.length; i < l; i++) {
          str = str.replace(new RegExp(from.charAt(i), 'g'), to.charAt(i));
        }
        str = str.replace(/[^a-z0-9 -]/g, '') // remove invalid chars
          .replace(/\s+/g, '-') // collapse whitespace and replace by -
          .replace(/-+/g, '-'); // collapse dashes
        return str;
      }
      var that = this;
      this.userChanged = false;

      this.bind('change keyup blur', function(e) {
        if (!that.userChanged) {
          $(target).attr('value', string_to_slug($(this).attr('value')));
        }
      });
      $(target).change(function(e) {
        that.userChanged = true;
      });
    };

    var slug = $('input[name*="[slug"]'); //$('input[name*="slug"').filter(function() { return this.id.match(/_slug[\(a-z\)]*/); });
    if (slug.length) {
      $.each(slug, function() {
        var title = $(this).attr('name').replace(/slug/, 'title');
        $('input[name="' + title + '"]').slugify(this);
      });
    }

    if ($("#taxonomy_parent_id").length) {
      $.getJSON('/taxonomy/tree.js', function(tree) {
        $('input[name=_dummy]').optionTree(tree, {
          choose: "Scegli...",
          preselect: {
            '_dummy': "---"
          }
        }).change(function() {
          $('input[name="taxonomy[parent_id]"]').attr('value', this.value);
        });
      });
    }
    $('#site_link').attr('href', 'http://' + /(\w+)(.\w+)?$/.exec(location.hostname)[0] + '/');

    /*
       var table = $('table');
       if (table.length)
       table.dataTable({
       "sPaginationType": "full_numbers"
       });*/
    (function() {
      if ($('#hcard').length == 0) return;

      // Removes leading whitespaces
      function ltrim(value) {
        return value.replace(/\s*((\S+\s*)*)/, "$1");
      }
      // Removes ending whitespaces
      function rtrim(value) {
        return value.replace(/((\s*\S+)*)\s*/, "$1");
      }
      // Removes leading and ending whitespaces
      function trim(value) {
        return ltrim(rtrim(value));
      }
      function normalizeSpace(str) {
        if (str) {
          str = str.replace(/^\s*|\s*$/g, '');
          return str.replace(/\s+/g, ' ');
        }
      }
      var template = _.template('<div id="<%= id %>" class="vcard">'+
          '  <span class="given-name"><%= given_name %></span>'+
          '  <span class="additional-name"><%= additional_name %></span>'+
          '  <span class="family-name"><%= family_name %></span>'+
          '  <% if (photo.length > 3) {%><img src="<%= photo %>" alt="photo of <%= given_name %> <%= additional_name %> <%= family_name %>" class="photo"/><% } %>'+
          '  <div class="org"><%= org %></div>'+
          '  <a class="email" href="mailto:<%= email %>"><%= email %></a>'+
          '  <div class="street-address"><%= street_address %></div>'+
          '  <span class="locality"><%= city %></span>'+
          '  <span class="region"><%= region %></span>'+
          '  <span class="postal-code"><%= postal_code %></span>'+
          '  <span class="country-name"><%= country %></span>'+
          ' <% _.each(phone,function(tel){%> <div class="tel"><%= tel %></div> <% }); %>'+
          '</div>');
      $('form.card input').change(
          function(e) {
            e.preventDefault();

            var params = {
              given_name: $('#givenname').val(),
              additional_name: $('#additionalname').val(),
              family_name: $('#familyname').val(),
              org: $('#org').val(),
              email: $('#email').val(),
              street_address: $("#street").val(),
              city: $("#city").val(),
              region: $("#region").val(),
              postal_code: $("#postal").val(),
              country: $("#country").val(),
              phone: _.map($("#phone").val().split(','), function(e){
                return trim(e); }),
              photo: $("#photo").val()
            };
            params.id = _.map([
                params.given_name,
                params.additional_name,
                params.family_name
              ],
              function(el) {
                return el.replace(/\s+/g, '-' );
              }).join('-');

            $('#target').html(template(params));
            $('#hcard').val(template(params));
          });
    })();
  });
})(jQuery);

