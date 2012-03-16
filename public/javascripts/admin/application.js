"use strict";
!function ($) {

  $.ender({
    loadcss: (function(){
      return (!!document.createStyleSheet)
        ? document.createStyleSheet
        : function (path) {
            var styles = "@import url(' " + path + " ');"
              , newSS  = document.createElement('link')
              ;
            newSS.rel='stylesheet';
            newSS.href='data:text/css,'+escape(styles);
            document.getElementsByTagName("head")[0].appendChild(newSS);
          }
        ;
    })()
  });

  String.prototype.to_slug = function() {
    var str = this.replace(/^\s+|\s+$/g, '').toLowerCase();

    // remove accents, swap ñ for n, etc
    var from = "àáäâèéëêìíïîòóöôùúüûñç·/_,:;"
      , to = "aaaaeeeeiiiioooouuuunc------";
    for (var i = 0, l = from.length; i < l; i++) {
      str = str.replace(new RegExp(from.charAt(i), 'g'), to.charAt(i));
    }
    str = str.replace(/[^a-z0-9]/g, '').replace(/\s+/g, '-').replace(/-+/g, '-');
    return str;
  };

  $.domReady(function () {

    // Set site link to the right location
    $('#site_link').attr('href', 'http://' + (/(\w+)(.\w+)?$/.exec(window.location.hostname)[0]) + '/');

    /**
     * Dates
     */
    $('.date').each(function(el){
      el.html(moment(el.html()).format('YYYY-MM-DD'));
    });
    $('.date_hour').each(function(el){
      el.html(_date(el.html()).format('YYYY-MM-DD HH:mm'));
    });

    /**
     * Invalid attributes
     */
    $('.invalid').parent().find('label').each(function(el) { el.style({ color: 'red' }); });

    /**
     * Advanced options
     */
    $('#advanced').each(function(el){
      $('#advanced>div').toggle();
      $('#advanced>legend').bind('click', function(e) {
        $('#advanced>div').toggle();
      });
    });

    /**
     * Tags
     */
    $('input[name*="[tag_list]"]').each(function(el){
      var el = $(el)
        , tagger = ui.Tagger(el.attr('name'), el.val().split(','));
      el.parent().append(tagger.el);
      el.remove();
    });

    /**
     * Uploader
     */
    $('input[type=file]').each(function(el) {
      var el = $(el)
        , myid = el.attr('id')
        , myname = el.get('name')
        , input = $('<input type="hidden">')
            .appendTo(el.parent())
        , div = $('<div>')
            .attr({
              "id": myid
            , "class": "upload_button"
            , "html": "Upload"
            }).appentTo(el.parent());

      el.remove();

      var uploader = new qq.FileUploader({
        debug: true,
        element: div[0], //html element
        action: '/base/upload',
        onComplete: function(id, name, resp) {
          if (resp.error) {
            var ul = $('ul').attr("class", "errors");

            resp.error.each(function(el) {
              ul.append($('li').html(el));
            });
            div.append(ul);
          } else {
            input.val(resp.success);
          }
        }
      });
    });


    $('input[name*="[slug"]').each(function(el) {
      var el = $(el);
      $('input[name="' + el.attr('name').replace(/slug/, 'title') + '"]')
        .bind('keyup,blur', function(ev){
          el.val('value', to_slug(tar.get('value')));
        });
    });


    (function() {
      window.CKEDITOR_BASEPATH = '/js/ckeditor/';
      $('textarea').each(function(e) {
        if (! $(e).parent().find('label').first().hasClass('editor')) {
          CKEDITOR.replace(e, {
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
          CKEDITOR.replace(e, {
            startupFocus: false
          //, contentsCss: '/stylesheets/layout.css' // BROKEN!
          , filebrowserBrowseUrl: '/multimedia/dialog/file'
          , filebrowserImageBrowseUrl: '/multimedia/dialog/image'
          , filebrowserUploadUrl: '/base/upload'
          , filebrowserWindowWidth: '600'
          , filebrowserWindowHeight: '600'
          });
        }
      });
    })();


  });

}(window.ender);


!(function(RightJS) {
  if (! RightJS) return null;

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
          $('tbody').append(
            tpl({
              url: data.url
            , name: data.data.name
            , id: data.data._id
            })
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

})(window.RightJS);
