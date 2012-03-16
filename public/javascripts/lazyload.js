!function(){
  var _has = function(obj, key) {
        return hasOwnProperty.call(obj, key);
      }
    ;

  function loadImage (el) {
    var img = new Image()
      , src = el.attr('data-src');
    img.onload = function() {
      el.attr({
        'src': src
      , 'width': img.width
      , 'height': img.height
      });
    }
    img.src = src;
  }

  function elementInViewport(el) {
    el = (el.hasOwnProperty(length))? el[0] : el;
    var rect = el.getBoundingClientRect()

    return (
       rect.top    >= 0
    && rect.left   >= 0
    && rect.bottom <= window.innerHeight
    && rect.right  <= window.innerWidth 
    )
  }

  $(document).ready(function(){
    var images = $('img.lazy');
    $(window).bind('scroll', function(e){
      for (var i = 0; i < images.length; i++) {
        if (elementInViewport(images[i])) {
          loadImage($(images[i]));
          images.splice(i, i);
        }
      };
    }).trigger('scroll');
  });
}(window.jQuery || window.ender);