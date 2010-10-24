window.addEvent('domready', function() {
  var style = new Element('style', {
    text: "#moolog{\
          position: fixed;\
          left: 15px;\
          bottom: 15px;\
          width: 300px;\
          max-height: 200px;\
          border: solid 2px #f0f0f0;\
          background: rgba(180, 180, 180, 0.6);\
          padding: 10px;\
          font: bold 11px 'Consolas', 'Courier New';\
          line-height: 16px;\
          overflow: auto;\
      }\
      #moolog div{\
          border-bottom: solid 1px #e0e0e0;\
          margin: 5px;\
      }\
      #moolog div:last-child{\
          border: none;\
          margin-bottom: none;\
      }"
  });

  var parent = new Element('div', {
        'id': 'moolog'
      }),
      log = function(message, type) {
        var child = new Element('div', {
          'class': (typeof type != 'undefined') ? type : 'log',
          'text': message
        });
        parent.adopt(child).scrollTo(0, parent.getScrollSize().y);
      };
  document.id(document.body).adopt(style);
  document.id(document.body).adopt(parent);
  window.log = log;
});
