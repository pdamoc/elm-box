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
        if (!(name in css))
          loadCSS(this.ownerDocument || document, stylesheet);
          css[name] = true
        if (constructor) constructor.apply(this, arguments);
      };
    }
    return document.registerElement(
      name || ('zero-dom-class-'+ ++o),
      {prototype: create(xtends || HTMLElement.prototype, descriptors)}
    );
  };

}(Object, 0));

// INITIALIZE A COMPONENT (lifted from Platform.js)

function initializeWC(node, impl)
{

  // cleanup
  while (node.lastChild)
  {
    node.removeChild(node.lastChild);
  }

  var 
    init = impl.init,
    update = impl.update,
    subscriptions = impl.subscriptions,
    attributeDecoder = impl.attributeDecoder,
    renderer = _elm_lang$virtual_dom$Native_VirtualDom.normalRenderer(node, impl.view), 
    attrs = node.attributes,
    incoming = _elm_lang$core$Native_List.Nil 
      
    for (var i = attrs.length; i--; )
    { 
      var result = A2(attributeDecoder, attrs[i].name, attrs[i].value)
      if (result.tag == "succeed"){
        incoming = _elm_lang$core$Native_List.Cons(result.msg, incoming);
      }
    }

   

  init =  init(incoming)  

  // ambient state
  var managers = {};
  var updateView;

  // init and update state in main process
  var initApp = _elm_lang$core$Native_Scheduler.nativeBinding(function(callback) {
    var model = init._0;
    updateView = renderer(enqueue, model);
    var cmds = init._1;
    var subs = subscriptions(model);
    _elm_lang$core$Native_Platform.dispatchEffects(managers, cmds, subs);
    callback(_elm_lang$core$Native_Scheduler.succeed(model));
  });

  function onMessage(msg, model)
  {
    return _elm_lang$core$Native_Scheduler.nativeBinding(function(callback) {
      var results = A2(update, msg, model);

      model = results._0;
      updateView(model);
      var cmds = results._1;
      var evts = results._2;
      if (evts.ctor == "Just"){
        var attr = evts._0._0;
        var value = evts._0._1;
        var event; // The custom event that will be created

        if (document.createEvent) {
          event = document.createEvent("HTMLEvents");
          event.initEvent(attr, true, true);
        } else {
          event = document.createEventObject();
          event.eventType = attr;
        }

        event.eventName = attr;
        event.value = value; 
        if (document.createEvent) {
          node.dispatchEvent(event);
        } else {
          node.fireEvent("on" + event.eventType, event);
        } 

      };
      var subs = subscriptions(model);
      _elm_lang$core$Native_Platform.dispatchEffects(managers, cmds, subs);
      callback(_elm_lang$core$Native_Scheduler.succeed(model));
    });
  }

  var mainProcess = _elm_lang$core$Native_Platform.spawnLoop(initApp, onMessage);

  function enqueue(msg)
  {
    _elm_lang$core$Native_Scheduler.rawSend(mainProcess, msg);
  }

  
  node.send = function(name, value){
    var results = A2(attributeDecoder, name, value);
    if (results.tag == "succeed"){
      enqueue(results.msg);
    }
  } 

  var ports = _elm_lang$core$Native_Platform.setupEffects(managers, enqueue);

}

// REGISTERS THE COMPONENT

function define(impl){
    var newClass = new DOMClass({
        
        name: impl.name,
        
        constructor: function () { 
            initializeWC(this, impl); 
        }, 
        
        stylesheet : impl.css,

        onChanged: function (name, prev, curr) {
          this.send(name, curr);
        }
    });

    return true;
}

return {
    define: define
};

}();


