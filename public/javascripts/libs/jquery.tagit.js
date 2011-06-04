;(function($) {

  $.fn.tagit = function(options) {
    if (!this.length) return this;

    const TAB = 0;
    const BACKSPACE = 8;
    const ENTER = 13;
    const SPACE = 32;
    const COMMA = 44;

    this.hide();

    var input = $('<input>')
                .attr('type', 'text')
                .addClass("tagit")
                .appendTo(this.parent()),
        el = $('<ul>')
            .addClass("tagit")
            .appendTo(this.parent());

    var input_name = this.attr('name') + '[]';

    $.each(
        this.html().match(/[a-zA-Z\-\_\.]+/g),
        function(k,v){
          create_choice(v);
        });
    this.attr('name', 'none');

    el.click(function(e) {
      if (e.target.tagName == 'A') {
        // Removes a tag when the little 'x' is clicked.
        // Event is binded to the UL, otherwise a new tag (LI > A) wouldn't have this event attached to it.
        $(e.target).parent().remove();
      } else {
        // Sets the focus() to the input field, if the user clicks anywhere inside the UL.
        // This is needed because the input field needs to be of a small size.
        input.focus();
      }
    });

    input.keypress(function(event) {
      if (event.which == BACKSPACE) {
        if (input.attr('value') == "") {
          // When backspace is pressed, the last tag is deleted.
          el.children(".tagit-choice:last").remove();
        }
      } // Comma/Space/Enter are all valid delimiters for new tags.
      else if (event.which == COMMA || event.which == SPACE || event.which == ENTER || event.which == TAB) {
        if (event.which != TAB) event.preventDefault();

        var typed = input.attr('value').replace(/,+$/, "").trim();

        if (typed != "") {
          if (is_new(typed)) {
            create_choice(typed);
          }
          // Cleaning the input.
          input.attr('value',"");
        }
      }
    });

    input.autocomplete({
      source: options.availableTags,
      select: function(event, ui) {
        if (is_new(ui.item.value)) {
          create_choice(ui.item.value);
        }
        // Cleaning the input.
        input.val("");
        // Preventing the tag input to be update with the chosen value.
        return false;
      }
    });

    function is_new(value) {
      return ($('input[value="'+ value +'"]', el).size() > 0)? false : true;
    }
    function create_choice(value) {
      var e = '<li class="tagit-choice">'
            + value
            + '<a class="close">x</a>'
            + '<input type="hidden" style="display:none;" value="'+ value +'" name="'+ input_name + '">'
            + '</li>';
      $(e).appendTo(el);
    }
  };

  String.prototype.trim = function() {
    return this.replace(/^\s+|\s+$/g, "");
  };

})(jQuery);
