/* ------------------------------------------------------------------------
    Title:          Tiny Doodle
    
    Original Author:  Andrew Mason (a.w.mason at gmail dot com)
    Original Version: 0.2
    Original URL:     http://tinydoodle.appspot.com/


    Version: 0.3

    Modified By:    Lorenzo Giuliani (lorenzo at frenzart dot com)

    Licence:
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

------------------------------------------------------------------------ */
$(window).addEvent('domready', function() {
  doodle.init();
});

var doodle = {
  drawing: false,
  linethickness: 1,
};
doodle.init = function() {
  // Collect elements from the DOM and set-up the canvas
  doodle.pen = $('antistress_pen');
  doodle.eraser = $('antistress_eraser');
  doodle.cleaner = $('antistress_cleaner');
  doodle.saver = $('antistress_saver');

  doodle.canvas = $('antistress');
  doodle.context = doodle.canvas.getContext('2d');

  doodle.getSaved();

  // Mouse based interface
  doodle.canvas.addEvents({
    mousedown: doodle.drawStart,
    mousemove: doodle.draw,
    mouseup: doodle.drawEnd,
    mouseleave: doodle.drawEnd
  });

  doodle.pen.addEvent('click', doodle.setPen);
  doodle.eraser.addEvent('click', doodle.setEraser);
  doodle.cleaner.addEvent('click', doodle.clearCanvas);
  doodle.saver.addEvent('click', doodle.saveCanvas);
};

doodle.getSaved = function(){
  doodle.clearCanvas();
  var img_src = store.get('antistress');
  if (typeof(img_src) == "undefined") {
    return true;
  } else {
    var img = new Image();
    img.src = img_src;
    img.onload = function() {
      doodle.context.drawImage(img, 0, 0);
    };
  }
};

doodle.saveCanvas = function(){
  img = doodle.canvas.toDataURL("image/png");
  store.set('antistress', img);
};

doodle.clearCanvas = function(event) {
  doodle.context.clearRect(0, 0, doodle.canvas.width, doodle.canvas.height);
  doodle.canvas.width = doodle.canvas.width;

  doodle.context.fillStyle = '#FFFFFF';
  doodle.context.fillRect(0, 0, doodle.canvas.width, doodle.canvas.height);
  doodle.context.fillStyle = '#000000';

  doodle.setPen();

  doodle.updating = false;
};

doodle.drawStart = function(event) {
  // Calculate the current mouse X, Y coordinates with canvas offset
  var x, y;
  x = event.page.x - doodle.canvas.getPosition().x;
  y = event.page.y - doodle.canvas.getPosition().y;
  doodle.drawing = true;
  doodle.context.lineWidth = doodle.linethickness;

  // Store the current x, y positions
  doodle.oldX = x;
  doodle.oldY = y;
};

doodle.draw = function(event) {
  // Calculate the current mouse X, Y coordinates with canvas offset
  var x, y;
  x = event.page.x - doodle.canvas.getPosition().x;
  y = event.page.y - doodle.canvas.getPosition().y;

  // If the mouse is down (drawning) then start drawing lines
  if (doodle.drawing) {
    doodle.context.beginPath();
    doodle.context.moveTo(doodle.oldX, doodle.oldY);
    doodle.context.lineTo(x, y);
    doodle.context.closePath();
    doodle.context.stroke();
  }

  // Store the current X, Y position
  doodle.oldX = x;
  doodle.oldY = y;
};

// Finished drawing (mouse up)
doodle.drawEnd = function(event) {
  doodle.drawing = false;
};
// Set the drawing method to pen
doodle.setPen = function() {
    doodle.context.strokeStyle = '#000000';
    doodle.linethickness = 1;
};

doodle.setEraser = function() {
    doodle.context.strokeStyle = '#FFFFFF';
    doodle.linethickness = 7;
};


/*  Used to save your last doodle
    store.js
    http://github.com/marcuswestin/store.js
*/
var store = (function() {
  var api = {},
    win = window,
    doc = win.document,
    localStorageName = 'localStorage',
    globalStorageName = 'globalStorage',
    storage;

  api.set = function(key, value) {};
  api.get = function(key) {};
  api.remove = function(key) {};
  api.clear = function() {};
  api.transact = function(key, transactionFn) {
    var val = api.get(key);
    if (typeof val == 'undefined') {
      val = {};
    }
    transactionFn(val);
    store.set(key, val);
  };

  api.serialize = function(value) {
    return JSON.stringify(value);
  };
  api.deserialize = function(value) {
    if (typeof value != 'string') {
      return undefined;
    }
    return JSON.parse(value);
  };

  if (localStorageName in win && win[localStorageName]) {
    storage = win[localStorageName];
    api.set = function(key, val) {
      storage.setItem(key, api.serialize(val));
    };
    api.get = function(key) {
      return api.deserialize(storage.getItem(key));
    };
    api.remove = function(key) {
      storage.removeItem(key);
    };
    api.clear = function() {
      storage.clear();
    };

  } else if (globalStorageName in win && win[globalStorageName]) {
    storage = win[globalStorageName][win.location.hostname];
    api.set = function(key, val) {
      storage[key] = api.serialize(val);
    };
    api.get = function(key) {
      return api.deserialize(storage[key] && storage[key].value);
    };
    api.remove = function(key) {
      delete storage[key];
    };
    api.clear = function() {
      for (var key in storage) {
        delete storage[key];
      }
    };

  } else if (doc.documentElement.addBehavior) {
    var storage = doc.createElement('div');
    function withIEStorage(storeFunction) {
      return function() {
        var args = Array.prototype.slice.call(arguments, 0);
        args.unshift(storage);
        // See http://msdn.microsoft.com/en-us/library/ms531081(v=VS.85).aspx
        // and http://msdn.microsoft.com/en-us/library/ms531424(v=VS.85).aspx
        doc.body.appendChild(storage);
        storage.addBehavior('#default#userData');
        storage.load(localStorageName);
        var result = storeFunction.apply(api, args);
        doc.body.removeChild(storage);
        return result;
      };
    }
    api.set = withIEStorage(function(storage, key, val) {
      storage.setAttribute(key, api.serialize(val));
      storage.save(localStorageName);
    });
    api.get = withIEStorage(function(storage, key) {
      return api.deserialize(storage.getAttribute(key));
    });
    api.remove = withIEStorage(function(storage, key) {
      storage.removeAttribute(key);
      storage.save(localStorageName);
    });
    api.clear = withIEStorage(function(storage) {
      var attributes = storage.XMLDocument.documentElement.attributes;
      storage.load(localStorageName);
      for (var i = 0, attr; attr = attributes[i]; i++) {
        storage.removeAttribute(attr.name);
      }
      storage.save(localStorageName);
    });
  }

  return api;
})();
