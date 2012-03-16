!function(){
  var _has = function(obj, key) {
        return hasOwnProperty.call(obj, key);
      }
    ;

  function loadImage (el, fn) {
    var img = new Image()
      , src = el.attr('data-src');
    img.onload = function() {
      el.attr({
        'width': img.width
      , 'height': img.height
      });
      el[0].src = src; // sometimes using DOM directly is better (:
      fn? fn() : null;
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
          loadImage($(images[i]), function () {
            images.splice(i, i);
          });
        }
      };
    }).trigger('scroll');
  });
}(window.jQuery || window.ender);