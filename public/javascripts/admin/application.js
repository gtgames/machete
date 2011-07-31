;;
(function(RightJS) {
  var R = RightJS,
  $ = RightJS.$,
  $$ = RightJS.$$,
  $E = RightJS.$E,
  Xhr = RightJS.Xhr,
  Object = RightJS.Object;

  var to_slug = function(str) {
    str = str.replace(/^\s+|\s+$/g, '').toLowerCase();

    // remove accents, swap ñ for n, etc
    var from = "àáäâèéëêìíïîòóöôùúüûñç·/_,:;";
    var to = "aaaaeeeeiiiioooouuuunc------";
    for (var i = 0, l = from.length; i < l; i++) {
      str = str.replace(new RegExp(from.charAt(i), 'g'), to.charAt(i));
    }
    str = str.replace(/[^a-z0-9 -]/g, '').replace(/\s+/g, '-').replace(/-+/g, '-');
    return str;
  }

  $(document).onReady(function() {
    $('site_link').set('href', 'http://' + /(\w+)(.\w+)?$/.exec(location.hostname)[0] + '/');

    if ($('advanced')) {
      $$('#advanced>div').each('toggle');
      $$('#advanced>legend').first().on('click', function(e) {
        $$('#advanced>div').each('toggle');
      });
    }

    $$('.invalid').each(function() {
      this.parent().find('label').setStyle({
        color: 'red'
      });
    });

    if ($$('input[name*="[tag_list]"]').length) {
      var el = $$('input[name*="[tag_list]"]').first();
      el.setStyle({
        color: el.getStyle('background-color')
      });

      Xhr.load('/base/tagblob.js', {
        onSuccess: function(r) {
          new Tags(el, {
            vertical: true,
            tags: r.responseJSON
          });
        }
      });
    }

    $$('input[type=file]').each(function(el) {
      var myid = el.get('id'),
      myname = $(el).get('name');
      var input = new Element('input', {
        type: "hidden",
        value: myname
      });
      var div = new Element('div', {
        id: myid,
        class: "upload_button",
        html: "Upload"
      });
      el.parent().append(input, div)
      el.remove();

      var uploader = new qq.FileUploader({
        debug: true,
        element: div._,
        //html element
        action: '/base/upload',
        onComplete: function(id, name, resp) {
          if (resp.error) {
            var ul = new Element('ul', {
              class: "errors"
            });
            resp.error.each(function(el) {
              ul.append(new Element('li', {
                html: el
              }));
            });
            div.append(ul);
          } else {
            input.set('value', resp.success)
          }
        }
      });
    });

    var slugs = $$('input[name*="[slug"]'); //$('input[name*="slug"').filter(function() { return this.id.match(/_slug[\(a-z\)]*/); });
if (slugs.length) {
  slugs.each(function(slug) {
    function slugify(el) {
      slug.set('value', to_slug(el.get('value')))
    }
    $$('input[name="' + slug.get('name').replace(/slug/, 'title') + '"]').each(function(el) {
      el.on({
        change: function() { slugify(el) },
        keyup: function() {  slugify(el) },
        blur: function() {   slugify(el) }
      });
    });
  });
}

if ($('multimedia_file-uploader')) {
  new qq.FileUploader({
    element: document.getElementById('multimedia_file-uploader'),
    action: '/base/upload',
    onComplete: function(idx, name, data){
      var tpl = _.template('<tr><td><img src="<%= url %>"></td><td><%= name %><td>'+
                           '<form class="button_to trash" method="post" action="/multimedia/destroy/<%= id %>">'+
                           '<input value="delete" name="_method" type="hidden"><input value="Delete" type="submit"></form></td></tr>');
      $$('tbody').first().append(tpl({ url: data.url,
                                     name: data.data.name,
                                     id: data.data._id })
                                );
    }
  });
}

(function() {
  /* Simple RT Editor from RightJS */
  if (!$$('textarea.text').length) return false;
  var rte_opts = {
    minimal: {
      toolbar: 'small',
      tags: {
        Bold: 'b',
        Italic: 'i',
        Underline: 'u',
        Strike: 's',
        Quote: 'blockquote',
      },

    },
    full: {}
  }
  $$('textarea.text').each(function(el) {
    new Rte(el, {});
  });
})();

(function() {
  if (! $('hcard')) return;
  var template = _.template('<div id="<%= id %>" class="vcard">' +
                            '  <span class="given-name"><%= given_name %></span>' +
                            '  <span class="additional-name"><%= additional_name %></span>' +
                            '  <span class="family-name"><%= family_name %></span>' +
                            '  <% if (photo.length) {%><img src="<%= photo %>" alt="photo of <%= given_name %> <%= additional_name %> <%= family_name %>" class="photo"/><% } %>' +
                            '  <div class="org"><%= org %></div>' +
                            '  <a class="email" href="mailto:<%= email %>"><%= email %></a>' +
                            '  <span class="street-address"><%= street_address %><span>' +
                            '  <span class="locality"><%= city %></span>' +
                            '  <span class="region"><%= region %></span>' +
                            '  <span class="postal-code"><%= postal_code %></span>' +
                            '  <span class="country-name"><%= country %></span>' +
                            ' <% _.each(phone,function(tel){%> <span class="tel"><%= tel %></span> <% }); %>' +
                            '</div>');
  function fillCard(e) {
    var params = {
      given_name: $('givenname').get("value"),
      additional_name: $('additionalname').get("value"),
      family_name: $('familyname').get("value"),
      org: $('org').get("value"),
      email: $('email').get("value"),
      street_address: $("street").get("value"),
      city: $("city").get("value"),
      region: $("region").get("value"),
      postal_code: $("postal").get("value"),
      country: $("country").get("value"),
      phone: _.map($("phone").get("value").split(','), function(e) {
        return e.trim();
      }),
      photo: $("photo").get("value")
    };
    params.id = _.map([params.given_name, params.additional_name, params.family_name], function(el) {
      if (el) return el.replace(/\s+/g, '-');
      return null;
    }).join('-');

    $('target').html(template(params));
    $('hcard').set('value', template(params));
  }
  $$('form.card input').each(function(el) {
    el.on('change', fillCard);
    el.on('blur', fillCard);
    el.on('keyup', fillCard);
  });
  $$('form.card').each(function(el) {
    el.on('submit', fillCard);
  });
})();
  });

  var BrowserDialog = new Class(Dialog, {
    image: '',
    thumb_size: '400x',
    thumb: function(){
      var e = this.image.match(/\.([a-z]+)$/i);
      if (e !== null) {
        e = e[1];
      } else {
        e = 'png'
      }
      return this.image.replace(/\.[a-z]+$/i, '_' + this.thumb_size + '.' + e );
    },

    preview: function(url) {
      if (url === undefined) { return false; }
      $('filebrowser_preview').html('');
      this.image = url;
      var dialog = this;
      this.expand();

      $('filebrowser_list').morph({
        height: '140px',
        position: 'absolute',
        bottom: '0',
        overflow: 'auto'
      });
      var imagePreview = new Element('img', {
        style: {
          display: 'block',
          margin: '0 auto',
        }
      }).set('src', this.thumb()).insertTo( $E('div', {
        style: {
          width: '99%',
          height: (this.find('div.rui-dialog-body').first().size().y - 200) + 'px',
          overflow: 'auto'
        }
      }).insertTo( $('filebrowser_preview')) ); // imagePreview

      var thumbSelect = new Selectable({
        options: {
          '100xx100': "Small",
          '300xx300': "Normal",
          '400x':     "Medium",
          '900xx700': "Huge"
        },
        multiple: false,
        selected: 1
      }).insertTo(
        $E('div',{ style: { width: '180px', margin: '0 auto' } }).insertTo($('filebrowser_preview'))
      ).on('select', function(){
        dialog.thumb_size = this.getValue();
        imagePreview.set('src', dialog.thumb() );
      });
    }

  });

  Rte.Tools.Image = new Class(Rte.Tool, {
    command: 'insertimage',
    attr: 'src',

    element: function() {
      var image = this.rte.selection.element();
      return image !== null && image.tagName === "IMG" ? image: null;
    },

    // the url-attribute 'src', 'href', etc.
    exec: function(url) {
      if (url === undefined ) {
        // handle it!
        this.prompt();
      } else {
        this.dialog.hide();
        this.dialog = null;
        if (url) {
          this[this.element() ? 'url': 'create'](url);
        } else {
          this.rte.editor.removeElement(this.element());
        }
      }
    },

    active: function() {
      return this.element() !== null;
    },

    prompt: function() {
      var that = this;
      this.dialog = new BrowserDialog({
        closeable: true,
        expandable:  true,
        title: 'Inserisci Immagine',
        url: '/multimedia/dialog/image'
      }).on({
        load: function(e){
          var dialog = this;
          $$('#filebrowser_list img').each(function(img){
            img.on('click', function(e){
              dialog.preview(this.get('data-link'));
            });
          });
        },
        ok: function(e){
          that.exec(this.thumb().replace(/admin\./, ''));
        }
      });
    },

    // protected
    url: function(url) {
      if (this.element()) {
        if (url !== undefined) {
          this.element()[this.attr] = url;
        } else {
          return this.element()[this.attr];
        }
      }
    },

    create: function(url) {
      this.rte.selection.exec(this.command, url);
    }
  });

})(RightJS);

