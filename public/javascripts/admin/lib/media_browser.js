$.domReady(function () {
  var thumb = function (link, size) {
        if (! size) size = '300xx300';
        return link.replace(/\.[a-z]+$/i, '_' + size + '.' + e );
      }
    , vis = function (image) {
      image = $(image);
      
      }
      , images = $('#filebrowser_list img');
  
  images.on('click dblclick', function (e) {
    e.preventDefault();
    $('.selected').toggleClass('selected');
    $(this).toggleClass('selected');
    vis(this);
  });
  
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
  /*new qq.FileUploader({
    element: $('input[type="file"]')[0],
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
  });*/
});