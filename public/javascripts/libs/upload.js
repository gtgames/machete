;(function($, document, window){
  $.fn.jsUpload = function(){
    if (this.length == 0) return;

    var uuid = (function(){
      this.chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-_'.split('');
      var radix = chars.length,
          uuid = [];
      for (i = 0; i < 22; i++) uuid[i] = chars[0 | Math.random()*radix];
      return uuid.join('');
    })();

    var parent = this.parent(),
        iform = $('<form accept-charset="UTF-8" action="/base/upload" class="asynchronous-upload" enctype="multipart/form-data" method="post" target="upload_frame_'+ uuid +'" id="upload_form_'+ uuid +'">'),
        iframe = $('<iframe id="upload_frame_'+ uuid +'" name="upload_frame_'+ uuid +'" style="width:1px;height:1px;border:0px;display:none;" src="javascript:false;">'),
        field = {
          filename: $('<input name="'+ this.attr('name') +'[name]" type="hidden">').appendTo(this.parent()),
          tempfile: $('<input name="'+ this.attr('name') +'[path]" type="hidden">').appendTo(this.parent()),
          filetype: $('<input name="'+ this.attr('name') +'[content_type]" type="hidden">').appendTo(this.parent())
        };

    $('<input type="hidden" name="form_id" value="upload_form_'+ uuid +'">').appendTo(iform); // passing the form_id to call it back when upload completes

    iframe.appendTo(document.body);
    iform.appendTo(this.parent());
    iform.append(this); // let's see if it works ....

    this.attr('name', 'file');

    this.change(function(e){
      iform.submit();
    });

    iform.bind('clear', function(evt, val) {
      $(this).find('input[type=text], input[type=file]').val('');
    }).bind('success', function(evt, val) {
      field.filename.attr('value', val.filename);
      field.tempfile.attr('value', val.tempfile);
      field.filetype.attr('value', val.type);
      $(this).trigger('clear');
      $(this).slideUp();
      $('<p class="success">Upload terminato con successo, il file verr&agrave; salvato solo dopo aver finito di compilare la form.</p>').appendTo($(this).parent());
      iframe.remove();
      $(this).remove();
    }).bind('failure', function(evt, val) {
      $(this).trigger('clear');
      $('<p class="error">Errore nell\'upload</p>').appendTo($(this).parent());
    }).bind('destroy',function(evt, val){});
  };
})(jQuery, document, window);
/*$(function(){
  $('input[type=file]').jsUpload();
});
post upload do
  %{<script>window.parent.eval('$("##{params[:form_id]}").trigger("success", [#{data.to_json}]);');</script>}
end
*/
