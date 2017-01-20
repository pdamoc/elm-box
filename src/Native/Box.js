var _pdamoc$elm_box$Native_Box = function()
{
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
var css = Object.create(null);

function loadCSS(document, css) {    
  var style = document.createElement('style');
    style.type  = 'text/css';
    style.textContent  = css;
    document.head.insertBefore(style, document.head.lastChild);
}

function define(impl){
  var proto = Object.create(HTMLElement.prototype);

  proto.createdCallback = function(){
    initializeWC(this, impl); 
    if (!(impl.name in css)){
      loadCSS(this.ownerDocument || document, impl.css);
      css[impl.name] = true 
    };
  };


  proto.attributeChangedCallback = function (name, prev, curr) {
    console.log("attributeChangedCallback", name, curr)
    this.send(name, curr);
  };
  
  document.registerElement(impl.name, { prototype:proto });
    
}

return {
    define: define
};

}();


