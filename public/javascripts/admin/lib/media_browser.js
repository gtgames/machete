"use strict";

var tim = function (template) {
  var start   = "{{"
    , end     = "}}"
    , path    = "[a-z0-9_][\\.a-z0-9_]*" // e.g. config.person.name
    , pattern = new RegExp(start + "\\s*("+ path +")\\s*" + end, "gi")
    , undef;
  
  return function(data){
    // Merge data into the template string
    return template.replace(pattern, function(tag, token){
      var path = token.split(".")
        , len = path.length
        , lookup = data
        , i = 0
        ;

      for (; i < len; i++){
        lookup = lookup[path[i]];
        
        // Property not found
        if (lookup === undef){
          throw "tim: '" + path[i] + "' not found in " + tag;
        }
        
        // Return the required value
        if (i === len - 1){
          return lookup;
        }
      }
    });
  };
};

$.domReady(function () {
  var template = tim($('#template').html())

    , thumb = function (link, size) {
        if (! size) size = '300xx300';
        var e;
        try {
          e = link.match(/\.([a-z])$/i)[1];
        } catch (e) {
          e = 'jpg'; // most likely
        }
        return link.replace(/\.[a-z]+$/i, '_' + size + '.' + e );
      }
    ;


  $('#filebrowser_list').delegate('.submit', 'click', function (e) {
    var funcNum = (function (paramName) {
          var match = window.location.search.match(
            new RegExp('(?:[\\?&]|&amp;)' + paramName + '=([^&]+)', 'i')
          );
          return (match && match.length > 1) ? match[1] : '';
        })('CKEditorFuncNum')
      , fileUrl = $(this).attr('data-link');


    window.opener.CKEDITOR.tools.callFunction(funcNum, fileUrl);
    window.close();
  });
  
  // uploader
  new qq.FileUploader({
    element: $('#upload')[0],
    action: '/base/upload',
    onComplete: function(idx, name, data){
      var tpl;

      data['name'] = name;
      tpl = $(template(data));

      if (/(jpe?g|png|gif)/i.test(data.url)) {
        var img = $('<img>').attr({
              src: data.url
            });

        img.appendTo($('a', tpl).html(''))
      }
      tpl.appendTo($('#filebrowser_list tbody'));
    }
  });
});