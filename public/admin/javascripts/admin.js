window.log = function() {
  log.history = log.history || []; // store logs to an array for reference
  log.history.push(arguments);
  if (this.console) {
    console.log(Array.prototype.slice.call(arguments));
  }
};

$().ready(function() {
  // standard behaviour:
  $('textarea').wmd(); // default editor
  $('.tabs').tabs(); // UI tabs
  $('.photobox').each(function() {
    $(this).click(function(ev) {
      $("<div><img src='" + $(this).attr('href') + "'></div>").dialog({
        width: 'auto',
        heigth: 'auto',
        modal: true,
        position: ['25%', '25%'],
        resizable: false
      });
      return false;
    });
  });
  // App specific widgets:
  if ($('#page_tag_list').length > 0 | $('#photo_tag_list').length  > 0) {
    jQuery.getJSON('/tags.json', function(data) {
      $('#page_tag_list,#photo_tag_list').autocomplete({
        source: data
      });
    });
  }
  // Menu weigth as slider
  $('#weigth_slider').slider({
    min: 0,
    max: 20,
    step: 1,
    value: $('#menu_weigth,#page_weigth').val(),
    slide: function(ev, ui) {
      $('#menu_weigth,#page_weigth').val(ui.value);
    }
  });
});