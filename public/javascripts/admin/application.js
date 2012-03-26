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
     * Image Modal boxes
     */
    $('table').delegate('a[rel="image"]', 'click', function(e){
      e.preventDefault();
      var img = new Image();
      img.onload = function(){
        var diag = ui.dialog($('<p>').append(img)[0])
          .closable()
          .overlay();
        setTimeout(_.bind(diag.show, diag), 10);
      }
      img.src = e.currentTarget.href;
    });

    /**
     * Dates
     */
    $('.date').each(function(el){
      el = $(el);
      el.html(moment(el.text()).format('YYYY-MM-DD'));
    });
    $('.date_hour').each(function(el){
      el = $(el);
      el.html(_date(el.text()).format('YYYY-MM-DD HH:mm'));
    });

    /**
     * Invalid attributes
     */
    $('.invalid').parent().find('label').each(function(el) { $(el).style({ color: 'red' }); });

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
        , tagger = ui.Tagger(el.attr('name').replace("tag_list", "tags"), el.val().split(','));
      el.parent().append(tagger.el);
      el.remove();
    });

    /**
     * Uploader
     */
    $('input[type=file]').each(function(el) {
      var el = $(el)
        , myid = el.attr('id')
        , input = $('<input type="hidden" name="' + el.attr('name') + '">')
            .appendTo(el.parent())
        , div = $('<div>')
            .attr({
              "id": myid
            , "class": "upload_button"
            , "html": "Upload"
            }).appendTo(el.parent());

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

    /**
     * Multimedia Uploader
     */

    if (document.getElementById('multimedia_file-uploader')) {
      new qq.FileUploader({
        element: document.getElementById('multimedia_file-uploader'),
        action: '/base/upload',
        onComplete: function(idx, name, data){
          var tpl = _.template(
            '<tr>'
          +   '<td><img src="<%= url %>"></td>'
          +   '<td><a href="<%= _url %>"><%= name %></a><td>'
          +   '<form class="btn trash" onsubmit="return confirm(\'Sei sicuro?\')" method="post" action="/multimedia/destroy/<%= id %>">'
          +     '<input value="delete" name="_method" type="hidden"><input value="Elimina" type="submit"></form>'
          +   '</form>'
          + '</tr>'
          );
          $('tbody').append(
            tpl({
              _url: data._url
            , url: data.url
            , name: data.data
            , id: data.success
            })
          );
        }
      });
    }

    /**
     * hCard editor
     */

    (function() {
      if (! $('#hcard')) return null;
      var template = _.template(
        '<div id="<%= id %>" class="vcard">' +
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
        '</div>'
      );

      var build = function (){
          var params = {
              given_name:     $('#givenname').val()       ||''
            , additional_name: $('#additionalname').val() ||''
            , family_name:    $('#familyname').val()      ||''
            , org:            $('#org').val()             ||''
            , email:          $('#email').val()           ||''
            , street_address: $("#street").val()          ||''
            , city:           $("#city").val()            ||''
            , region:         $("#region").val()          ||''
            , postal_code:    $("#postal").val()          ||''
            , country:        $("#country").val()         ||''
            , note:           $("#note").val()            ||''
            , phone: (function(){
                  var val = $("#phone").val();
                  if (!val) return '';
                  return _.map(val.split(','), function(e) {
                    return e.trim();
                  });
                })()
            , photo: $("#photo").val() || ''
            };
            params.id = _.map([params.given_name, params.additional_name, params.family_name], function(el) {
              if (el) return el.replace(/\s+/g, '-');
              return null;
            }).join('-');

            var hcard = template(params)
            $('#target').append(hcard);
            $('#hcard').val(hcard);
          };
      $('input[type="text"]').keyup(_.debounce(build, 500));
      $('form').bind('submit', function(){ build(); });
      _.defer(build);
    })();


  });

  
  (function() {
    if (! $('#dropbox')) return;

    var id = 0
      , template = _.template(
            '<tr id="<%= success %>"><td><input type="checkbox" checked></td>'
          + '<td><img src="<%= url %>"><td>'
          + '<td><%= data %></td>'
          + '<td><input name="import[photo][<%= id %>][media]" type="hidden" value="<%= success %>" />'
          + '    <button class="btn danger" type="button" data-id="<%= success %>">Delete!</button></td>'
          + '</tr>')
      , uploader = new qq.FileUploader({
        //  debug: true
          allowedExtensions: ['jpg', 'jpeg', 'png', 'gif']
        , element: $('#dropbox')[0]
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

    $('#__target').delegate('click', 'button.danger', function (ev) {
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
  });


  $.fn.inEdit = function (target, options) {
    var el = $(this);

    target = $(target);

    el.bind("click", function(e){
      e.preventDefault();
      target.attr('contenteditable', 'true')
        .focus()
        .bind('keydown', function(e){
          if (e.keyCode != 13) return;
          $(this).blur();
          e.preventDefault();

          target.attr('contenteditable', false);
          var data = options.data || {};
          data[options.name || 'name'] = target.text();

          $.ajax({
            url:    options.url
          , method: options.method
          , type: 'json'
          , data: data
          , success: options.success || function(){}
          , error: options.error || function(e) {console.log(e)}
          });
        });
      // window.getSelection().setPosition(0);
    });
  }

  $.domReady(function(){
    $('a.edit.sym').each(function(el){
      var el = $(el)
        , target = el.parent().find('span');

      el.inEdit(
        target
      , {
          url:'/photos/rename'
        , name: 'name'
        , data: {gallery: target.text()}
        , method:'post'
        , success: function () { ui.notify('Photo', 'galleria rinominata').effect('slide'); }
        , error: function () { ui.error('Photo', 'galleria rinominata').effect('slide'); }
      });
    });
  });


  $.domReady(function(){
    var $win = $(window)
      , $nav = $('.subnav')
      , navTop = $('.subnav').length && $('.subnav').offset().top
      , isFixed = 0;

    processScroll()
  
    $win.on('scroll', processScroll)
  
    function processScroll() {
      var i, scrollTop = $win.scrollTop()
      
      if (scrollTop >= navTop && !isFixed) {
        isFixed = 1
        $nav.addClass('subnav-fixed')
      } else if (scrollTop <= navTop && isFixed) {
        isFixed = 0
        $nav.removeClass('subnav-fixed')
      }
    }
  });

}(window.ender);
