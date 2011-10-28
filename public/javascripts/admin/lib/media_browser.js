$.domReady(function () {
  var thumb = function (link, size) {
        if (! size) size = '300xx300';
        return link.replace(/\.[a-z]+$/i, '_' + size + '.' + e );
      }
    , vis = function (image) {
      image = $(image);
      
      }
    , images = $('#filebrowser_list img')
    , images_event = function (e) {
        e.preventDefault();
        $('.selected').toggleClass('selected');
        $(this).toggleClass('selected');
        vis(this);
      };
  
  images.on('click dblclick', images_event);
  
  $('#submit').on('click', function (e) {
    var funcNum = (function (paramName) {
          var match = window.location.search.match(
            new RegExp('(?:[\\?&]|&amp;)' + paramName + '=([^&]+)', 'i')
          );
          return (match && match.length > 1) ? match[1] : '';
        })('CKEditorFuncNum')
      , fileUrl = $('.selected').first().attr('data-link');
    window.opener.CKEDITOR.tools.callFunction(funcNum, fileUrl);

    window.close();
  });
  
  // uploader
  new qq.FileUploader({
    element: $('#upload')[0],
    action: '/base/upload',
    onComplete: function(idx, name, data){
      var img = $('<img>').attr({
        src: data.url
      , 'data-link': data.data
      }).appendTo($('#filebrowser_list')).on('click dblclick', images_event);;
    }
  });
});