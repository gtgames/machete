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
    str = str.replace(/[^a-z0-9]/g, '').replace(/\s+/g, '-').replace(/-+/g, '-');
    return str;
  };

  $(document).onReady(function() {
    $('site_link').set('href', 'http://' + (/(\w+)(.\w+)?$/.exec(window.location.hostname)[0]) + '/');

    $$('.date').each(function(el){
      el.html(_date(el.html()).format('YYYY-MM-DD'));
    });
    $$('.date_hour').each(function(el){
      el.html(_date(el.html()).format('YYYY-MM-DD HH:mm'));
    });

    if($('advanced') !== null) {
      $$('#advanced>div').each('toggle');
      $$('#advanced>legend').first().on('click', function(e) {
        $$('#advanced>div').each('toggle');
      });
    }
    $$('.invalid').each(function(el) {
      el.parent().find('label').setStyles({ color: 'red' });
    });

    $$('input[name*="[tag_list]"]').each(function(el){
      el.setStyle({
        color: el.getStyle('background-color')
      });

      Xhr.load('/base/tagblob.js', {
        onSuccess: function(r) {
          new Tags(el, {
            vertical: false,
            tags: r.responseJSON
          });
        }
      });
    });

    $$('input[type=file]').each(function(el) {
      var myid = el.get('id'),
      myname = el.get('name');
      var input = new Element('input', {
        type: "hidden",
        name: myname
      }).insertTo(el.parent());
      var div = new Element('div', {
        "id": myid,
        "class": "upload_button",
        "html": "Upload"
      }).insertTo(el.parent());
      el.remove();

      var uploader = new qq.FileUploader({
        debug: true,
        element: div._, //html element
        action: '/base/upload',
        onComplete: function(id, name, resp) {
          if (resp.error) {
            var ul = new Element('ul', {
              "class": "errors"
            });
            resp.error.each(function(el) {
              ul.append(new Element('li', {
                html: el
              }));
            });
            div.append(ul);
          } else {
            input.set('value', resp.success);
          }
        }
      });
    });

    $$('input[name*="[slug"]').each(function(slug) {
      function slugify(el) {
        slug.set('value', to_slug(el.get('value')));
      }
      $$('input[name="' + slug.get('name').replace(/slug/, 'title') + '"]').each(function(el) {
        el.on({
          change: function() { slugify(el); },
          keyup: function() {  slugify(el); },
          blur: function() {   slugify(el); }
        });
      });
    });

    $$('input#event_from, input#event_to').each(function(el){
        var cal = new Calendar({
            format: "ISO",
            numberOfMonths: 1,
            timePeriod: 15,
            showTime: true,
            update: el
        }).on('change', function(){
            el.set('value', _date(this.getDate()).toISO());
        }).setDate( _date(el.get('value')).date ).insertTo(el.parent());
        el.set('type','hidden');
        el.parent().set({
          style:{
            'text-align': 'center',
            'width': '50%',
            'float': 'left'
          }
        });
    });

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

    /*(function() {
      if (!$$('textarea.text').length) return false;
      var rte_opts = {
        minimal: {
          toolbar: ["Bold Italic Underline Strike Ttext|Cut Copy Paste|Header Code Quote|Link Image|Source|Format"],
          tags: { Bold: 'b', Italic: 'i', Underline: 'u', Strike: 's', Quote: 'blockquote' }
        },
        full: {
          toolbar: [
            "Clear|Cut Copy Paste|Undo Redo|Bold Italic Underline Strike Ttext|Left Center Right Justify",
            "Code Quote|Link Image|Subscript Superscript|Dotlist Numlist|Indent Outdent",
            "Format|Fontsize|Forecolor Backcolor|Source"
          ],
          tags: { Bold: 'b', Italic: 'i', Underline: 'u', Strike: 's', Quote: 'blockquote' }
        }
      };
      $$('textarea.text').each(function(el) {
        new Rte(el, ( el.parent().find('label.editor').length )? rte_opts.full : rte_opts.minimal);
      });
    })();*/
    
    // Editor
    (function() {
      window.CKEDITOR_BASEPATH = '/js/ckeditor/';
      $$('textarea').each(function(e) {
        if (! e.parent().find('label').first().hasClass('editor')) {
          CKEDITOR.replace(e._, {
                  toolbar : [ //'Basic'
                      ['Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'SpellChecker']
                    , ['Undo', 'Redo', '-', 'Find', 'Replace', '-', 'SelectAll', 'RemoveFormat']
                    , ['Link', 'Unlink']
                    , ['Bold', 'Italic', 'Underline']
                    , ['ShowBlocks', 'Source', '-', 'Preview']
                    , ['Maximize']
                  ]
          });
        } else {
          CKEDITOR.replace(e._, {
            startupFocus: false
          , contentsCss: '/stylesheets/layout.css'
          , filebrowserBrowseUrl: '/multimedia/dialog/image'
          , filebrowserImageWindowWidth: '840'
          , filebrowserImageWindowHeight: '600'
          });
        }
      });
    })();

    (function() {
      if (! $('hcard')) return null;
      var template = _.template('<div id="<%= id %>" class="vcard">' +
                                '  <div>' +
                                '    <span class="given-name"><%= given_name %></span>' +
                                '    <span class="additional-name"><%= additional_name %></span>' +
                                '    <span class="family-name"><%= family_name %></span>' +
                                '    <% if (photo.length) {%><img src="<%= photo %>" alt="photo of <%= given_name %> <%= additional_name %> <%= family_name %>" class="photo"/><% } %>' +
                                '  </div>' +
                                '  <div class="org"><%= org %></div>' +
                                '  <div>' +
                                '    <a class="email" href="mailto:<%= email %>"><%= email %></a>' +
                                '    <span class="street-address"><%= street_address %><span>' +
                                '    <span class="locality"><%= city %></span>' +
                                '   (<span class="region"><%= region %></span>)' +
                                '    <span class="postal-code"><%= postal_code %></span>' +
                                '    <span class="country-name"><%= country %></span>' +
                                '  </div>' +
                                '  <% _.each(phone,function(tel){%> <span class="tel"><%= tel %></span> <% }); %>' +
                                '  <div><%= note%></div>' +
                                '</div>');
      function fillCard(e) {
        var params = {
          given_name: $('givenname').get("value")||'',
          additional_name: $('additionalname').get("value")||'',
          family_name: $('familyname').get("value")||'',
          org: $('org').get("value")||'',
          email: $('email').get("value")||'',
          street_address: $("street").get("value")||'',
          city: $("city").get("value")||'',
          region: $("region").get("value")||'',
          postal_code: $("postal").get("value")||'',
          country: $("country").get("value")||'',
          note: $("note").get("value")||'',
          phone: (function(){
            var val = $("phone").get("value");
            if (!val) return '';
            return _.map(val.split(','), function(e) {
              return e.trim();
            });
          })(),
          photo: $("photo").get("value")||''
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
      fillCard();
    })();

    
    (function() {
      if (! $('dropbox')) return;
      var id = 0
        , template = _.template( ''
          + '<tr id="<%= success %>"><td><input type="checkbox" checked></td>'
          + '<td><img src="<%= url %>"><td>'
          + '<td><%= data %></td>'
          + '<td><input name="import[photo][<%= id %>][media]" type="hidden" value="<%= success %>" />'
          + '    <button class="btn danger" type="button" data-id="<%= success %>">Delete!</button></td>'
          + '</tr>')
        , uploader = new qq.FileUploader({
          //  debug: true
            allowedExtensions: ['jpg', 'jpeg', 'png', 'gif']
          , element: $('dropbox')._
          , action: '/base/upload'
          , onComplete: function(id, name, resp) {
              if (resp.error) {
                var ul = new Element('ul', {
                  "class": "errors"
                });
                resp.error.each(function(el) {
                  ul.append(new Element('li', {
                    html: el
                  }));
                });
                div.append(ul);
              } else {
                id += 1;
                console.log(resp)
                $('__target').append(
                  template(
                    _.extend(resp, {
                      id: id++
                    })));
              }
            }
          });

      $('__target').delegate('click', 'button.danger', function (ev) {
        var self = this;
        var _id = this.get('data-id');
        var xhr = new Xhr('/multimedia/destroy/' + _id, {
          method: 'delete'
        , onSuccess: function() {
            $(_id).hide();
          }
        });
        xhr.send();
      });
    })();

  });

})(RightJS);

