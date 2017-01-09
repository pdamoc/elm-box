var _pdamoc$elm_box$Native_Box = function()
{

var DOMClass = (function (O,o) {

  /*! (C) Andrea Giammarchi */

  var
    create = O.create,
    css = create(null),
    dP = O.defineProperty,
    gOPD = O.getOwnPropertyDescriptor,
    gOPN = O.getOwnPropertyNames,
    gOPS = O.getOwnPropertySymbols,
    ownKeys = gOPS ?
      function (object) {
        return gOPN(object).concat(gOPS(object));
      } :
      gOPN,
    loadCSS = function (document, css) {
      
      var style = document.createElement('style');
        style.type  = 'text/css';
        style.textContent  = css;
        document.head.insertBefore(style, document.head.lastChild);
       
      return true;
    }
  ;

  return function DOMClass(description) {
    for (var
      k, name, xtends,
      constructor,
      stylesheet,
      descriptors = {},
      keys = ownKeys(description),
      set = function (s) {
        dP(descriptors, s, {
          enumerable: true,
          writable: true,
          value: gOPD(description, k)
        });
      },
      i = 0; i < keys.length; i++
    ) {
      k = keys[i];
      switch (k.toLowerCase()) {
        case 'name': name = description[k]; break;
        case 'stylesheet': stylesheet = description[k]; break;
        case 'extends':
          xtends = typeof description[k] === 'function' ?
            description[k].prototype : description[k];
          break;
        case 'constructor': constructor = description[k];
                            set('createdCallback');           break;
        case 'onattached':  set('attachedCallback');          break;
        case 'onchanged':   set('attributeChangedCallback');  break;
        case 'ondetached':  set('detachedCallback');          break;
        default: set(k); break;
      }
    }
    if (stylesheet) {
      descriptors.createdCallback.value = function () {
        if (!(stylesheet in css))
          loadCSS(this.ownerDocument || document, stylesheet);
        if (constructor) constructor.apply(this, arguments);
      };
    }
    return document.registerElement(
      name || ('zero-dom-class-'+ ++o),
      {prototype: create(xtends || HTMLElement.prototype, descriptors)}
    );
  };

}(Object, 0));


function define(impl){
    var newClass = new DOMClass({
        
        name: impl.name,
        
        constructor: function () { 
            var comp = {};
            _elm_lang$virtual_dom$VirtualDom$program (impl)()(comp);
            // var rootDiv = document.createElement('div')  
            
            comp.embed(this);
            
            // this.appendChild(rootDiv)

        }, 
        
        stylesheet : impl.css,

        onChanged: function (name, prev, curr) {
          console.log('changed', arguments);
        }
    });

    return true;
}

return {
    define: define
};

}();


