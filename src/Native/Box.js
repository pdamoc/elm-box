var _pdamoc$elm_box$Native_Box = function()
{
// https://github.com/WebReflection/document-register-element
/*! (C) Andrea Giammarchi - @WebReflection - Mit Style License */
(function(e,t){"use strict";function Dt(){var e=wt.splice(0,wt.length);Et=0;while(e.length)e.shift().call(null,e.shift())}function Pt(e,t){for(var n=0,r=e.length;n<r;n++)Vt(e[n],t)}function Ht(e){for(var t=0,n=e.length,r;t<n;t++)r=e[t],_t(r,A[jt(r)])}function Bt(e){return function(t){ut(t)&&(Vt(t,e),Pt(t.querySelectorAll(O),e))}}function jt(e){var t=ht.call(e,"is"),n=e.nodeName.toUpperCase(),r=_.call(L,t?N+t.toUpperCase():T+n);return t&&-1<r&&!Ft(n,t)?-1:r}function Ft(e,t){return-1<O.indexOf(e+'[is="'+t+'"]')}function It(e){var t=e.currentTarget,n=e.attrChange,r=e.attrName,i=e.target,s=e[y]||2,o=e[w]||3;Nt&&(!i||i===t)&&t[h]&&r!=="style"&&(e.prevValue!==e.newValue||e.newValue===""&&(n===s||n===o))&&t[h](r,n===s?null:e.prevValue,n===o?null:e.newValue)}function qt(e){var t=Bt(e);return function(e){wt.push(t,e.target),Et&&clearTimeout(Et),Et=setTimeout(Dt,1)}}function Rt(e){Tt&&(Tt=!1,e.currentTarget.removeEventListener(S,Rt)),Pt((e.target||n).querySelectorAll(O),e.detail===l?l:a),st&&Wt()}function Ut(e,t){var n=this;vt.call(n,e,t),Ct.call(n,{target:n})}function zt(e,t){nt(e,t),At?At.observe(e,yt):(xt&&(e.setAttribute=Ut,e[o]=Lt(e),e[u](x,Ct)),e[u](E,It)),e[m]&&Nt&&(e.created=!0,e[m](),e.created=!1)}function Wt(){for(var e,t=0,n=at.length;t<n;t++)e=at[t],M.contains(e)||(n--,at.splice(t--,1),Vt(e,l))}function Xt(e){throw new Error("A "+e+" type is already registered")}function Vt(e,t){var n,r=jt(e);-1<r&&(Mt(e,A[r]),r=0,t===a&&!e[a]?(e[l]=!1,e[a]=!0,r=1,st&&_.call(at,e)<0&&at.push(e)):t===l&&!e[l]&&(e[a]=!1,e[l]=!0,r=1),r&&(n=e[t+f])&&n.call(e))}function $t(){}function Jt(e,t,r){var i=r&&r[c]||"",o=t.prototype,u=tt(o),a=t.observedAttributes||j,f={prototype:u};ot(u,m,{value:function(){if(Q)Q=!1;else if(!this[W]){this[W]=!0,new t(this),o[m]&&o[m].call(this);var e=G[Z.get(t)];(!V||e.create.length>1)&&Gt(this)}}}),ot(u,h,{value:function(e){-1<_.call(a,e)&&o[h].apply(this,arguments)}}),o[d]&&ot(u,p,{value:o[d]}),o[v]&&ot(u,g,{value:o[v]}),i&&(f[c]=i),e=e.toUpperCase(),G[e]={constructor:t,create:i?[i,et(e)]:[e]},Z.set(t,e),n[s](e.toLowerCase(),f),Yt(e),Y[e].r()}function Kt(e){var t=G[e.toUpperCase()];return t&&t.constructor}function Qt(e){return typeof e=="string"?e:e&&e.is||""}function Gt(e){var t=e[h],n=t?e.attributes:j,r=n.length,i;while(r--)i=n[r],t.call(e,i.name||i.nodeName,null,i.value||i.nodeValue)}function Yt(e){return e=e.toUpperCase(),e in Y||(Y[e]={},Y[e].p=new K(function(t){Y[e].r=t})),Y[e].p}function Zt(){X&&delete e.customElements,B(e,"customElements",{configurable:!0,value:new $t}),B(e,"CustomElementRegistry",{configurable:!0,value:$t});for(var t=function(t){var r=e[t];if(r){e[t]=function(t){var i,s;return t||(t=this),t[W]||(Q=!0,i=G[Z.get(t.constructor)],s=V&&i.create.length===1,t=s?Reflect.construct(r,j,i.constructor):n.createElement.apply(n,i.create),t[W]=!0,Q=!1,s||Gt(t)),t},e[t].prototype=r.prototype;try{r.prototype.constructor=e[t]}catch(i){z=!0,B(r,W,{value:e[t]})}}},r=i.get(/^HTML[A-Z]*[a-z]/),s=r.length;s--;t(r[s]));n.createElement=function(e,t){var n=Qt(t);return n?gt.call(this,e,et(n)):gt.call(this,e)}}var n=e.document,r=e.Object,i=function(e){var t=/^[A-Z]+[a-z]/,n=function(e){var t=[],n;for(n in s)e.test(n)&&t.push(n);return t},i=function(e,t){t=t.toLowerCase(),t in s||(s[e]=(s[e]||[]).concat(t),s[t]=s[t.toUpperCase()]=e)},s=(r.create||r)(null),o={},u,a,f,l;for(a in e)for(l in e[a]){f=e[a][l],s[l]=f;for(u=0;u<f.length;u++)s[f[u].toLowerCase()]=s[f[u].toUpperCase()]=l}return o.get=function(r){return typeof r=="string"?s[r]||(t.test(r)?[]:""):n(r)},o.set=function(n,r){return t.test(n)?i(n,r):i(r,n),o},o}({collections:{HTMLAllCollection:["all"],HTMLCollection:["forms"],HTMLFormControlsCollection:["elements"],HTMLOptionsCollection:["options"]},elements:{Element:["element"],HTMLAnchorElement:["a"],HTMLAppletElement:["applet"],HTMLAreaElement:["area"],HTMLAttachmentElement:["attachment"],HTMLAudioElement:["audio"],HTMLBRElement:["br"],HTMLBaseElement:["base"],HTMLBodyElement:["body"],HTMLButtonElement:["button"],HTMLCanvasElement:["canvas"],HTMLContentElement:["content"],HTMLDListElement:["dl"],HTMLDataElement:["data"],HTMLDataListElement:["datalist"],HTMLDetailsElement:["details"],HTMLDialogElement:["dialog"],HTMLDirectoryElement:["dir"],HTMLDivElement:["div"],HTMLDocument:["document"],HTMLElement:["element","abbr","address","article","aside","b","bdi","bdo","cite","code","command","dd","dfn","dt","em","figcaption","figure","footer","header","i","kbd","mark","nav","noscript","rp","rt","ruby","s","samp","section","small","strong","sub","summary","sup","u","var","wbr"],HTMLEmbedElement:["embed"],HTMLFieldSetElement:["fieldset"],HTMLFontElement:["font"],HTMLFormElement:["form"],HTMLFrameElement:["frame"],HTMLFrameSetElement:["frameset"],HTMLHRElement:["hr"],HTMLHeadElement:["head"],HTMLHeadingElement:["h1","h2","h3","h4","h5","h6"],HTMLHtmlElement:["html"],HTMLIFrameElement:["iframe"],HTMLImageElement:["img"],HTMLInputElement:["input"],HTMLKeygenElement:["keygen"],HTMLLIElement:["li"],HTMLLabelElement:["label"],HTMLLegendElement:["legend"],HTMLLinkElement:["link"],HTMLMapElement:["map"],HTMLMarqueeElement:["marquee"],HTMLMediaElement:["media"],HTMLMenuElement:["menu"],HTMLMenuItemElement:["menuitem"],HTMLMetaElement:["meta"],HTMLMeterElement:["meter"],HTMLModElement:["del","ins"],HTMLOListElement:["ol"],HTMLObjectElement:["object"],HTMLOptGroupElement:["optgroup"],HTMLOptionElement:["option"],HTMLOutputElement:["output"],HTMLParagraphElement:["p"],HTMLParamElement:["param"],HTMLPictureElement:["picture"],HTMLPreElement:["pre"],HTMLProgressElement:["progress"],HTMLQuoteElement:["blockquote","q","quote"],HTMLScriptElement:["script"],HTMLSelectElement:["select"],HTMLShadowElement:["shadow"],HTMLSlotElement:["slot"],HTMLSourceElement:["source"],HTMLSpanElement:["span"],HTMLStyleElement:["style"],HTMLTableCaptionElement:["caption"],HTMLTableCellElement:["td","th"],HTMLTableColElement:["col","colgroup"],HTMLTableElement:["table"],HTMLTableRowElement:["tr"],HTMLTableSectionElement:["thead","tbody","tfoot"],HTMLTemplateElement:["template"],HTMLTextAreaElement:["textarea"],HTMLTimeElement:["time"],HTMLTitleElement:["title"],HTMLTrackElement:["track"],HTMLUListElement:["ul"],HTMLUnknownElement:["unknown","vhgroupv","vkeygen"],HTMLVideoElement:["video"]},nodes:{Attr:["node"],Audio:["audio"],CDATASection:["node"],CharacterData:["node"],Comment:["#comment"],Document:["#document"],DocumentFragment:["#document-fragment"],DocumentType:["node"],HTMLDocument:["#document"],Image:["img"],Option:["option"],ProcessingInstruction:["node"],ShadowRoot:["#shadow-root"],Text:["#text"],XMLDocument:["xml"]}});t||(t="auto");var s="registerElement",o="__"+s+(e.Math.random()*1e5>>0),u="addEventListener",a="attached",f="Callback",l="detached",c="extends",h="attributeChanged"+f,p=a+f,d="connected"+f,v="disconnected"+f,m="created"+f,g=l+f,y="ADDITION",b="MODIFICATION",w="REMOVAL",E="DOMAttrModified",S="DOMContentLoaded",x="DOMSubtreeModified",T="<",N="=",C=/^[A-Z][A-Z0-9]*(?:-[A-Z0-9]+)+$/,k=["ANNOTATION-XML","COLOR-PROFILE","FONT-FACE","FONT-FACE-SRC","FONT-FACE-URI","FONT-FACE-FORMAT","FONT-FACE-NAME","MISSING-GLYPH"],L=[],A=[],O="",M=n.documentElement,_=L.indexOf||function(e){for(var t=this.length;t--&&this[t]!==e;);return t},D=r.prototype,P=D.hasOwnProperty,H=D.isPrototypeOf,B=r.defineProperty,j=[],F=r.getOwnPropertyDescriptor,I=r.getOwnPropertyNames,q=r.getPrototypeOf,R=r.setPrototypeOf,U=!!r.__proto__,z=!1,W="__dreCEv1",X=e.customElements,V=t!=="force"&&!!(X&&X.define&&X.get&&X.whenDefined),$=r.create||r,J=e.Map||function(){var t=[],n=[],r;return{get:function(e){return n[_.call(t,e)]},set:function(e,i){r=_.call(t,e),r<0?n[t.push(e)-1]=i:n[r]=i}}},K=e.Promise||function(e){function i(e){n=!0;while(t.length)t.shift()(e)}var t=[],n=!1,r={"catch":function(){return r},then:function(e){return t.push(e),n&&setTimeout(i,1),r}};return e(i),r},Q=!1,G=$(null),Y=$(null),Z=new J,et=String,tt=r.create||function nn(e){return e?(nn.prototype=e,new nn):this},nt=R||(U?function(e,t){return e.__proto__=t,e}:I&&F?function(){function e(e,t){for(var n,r=I(t),i=0,s=r.length;i<s;i++)n=r[i],P.call(e,n)||B(e,n,F(t,n))}return function(t,n){do e(t,n);while((n=q(n))&&!H.call(n,t));return t}}():function(e,t){for(var n in t)e[n]=t[n];return e}),rt=e.MutationObserver||e.WebKitMutationObserver,it=(e.HTMLElement||e.Element||e.Node).prototype,st=!H.call(it,M),ot=st?function(e,t,n){return e[t]=n.value,e}:B,ut=st?function(e){return e.nodeType===1}:function(e){return H.call(it,e)},at=st&&[],ft=it.attachShadow,lt=it.cloneNode,ct=it.dispatchEvent,ht=it.getAttribute,pt=it.hasAttribute,dt=it.removeAttribute,vt=it.setAttribute,mt=n.createElement,gt=mt,yt=rt&&{attributes:!0,characterData:!0,attributeOldValue:!0},bt=rt||function(e){xt=!1,M.removeEventListener(E,bt)},wt,Et=0,St=!1,xt=!0,Tt=!0,Nt=!0,Ct,kt,Lt,At,Ot,Mt,_t;s in n||(R||U?(Mt=function(e,t){H.call(t,e)||zt(e,t)},_t=zt):(Mt=function(e,t){e[o]||(e[o]=r(!0),zt(e,t))},_t=Mt),st?(xt=!1,function(){var e=F(it,u),t=e.value,n=function(e){var t=new CustomEvent(E,{bubbles:!0});t.attrName=e,t.prevValue=ht.call(this,e),t.newValue=null,t[w]=t.attrChange=2,dt.call(this,e),ct.call(this,t)},r=function(e,t){var n=pt.call(this,e),r=n&&ht.call(this,e),i=new CustomEvent(E,{bubbles:!0});vt.call(this,e,t),i.attrName=e,i.prevValue=n?r:null,i.newValue=t,n?i[b]=i.attrChange=1:i[y]=i.attrChange=0,ct.call(this,i)},i=function(e){var t=e.currentTarget,n=t[o],r=e.propertyName,i;n.hasOwnProperty(r)&&(n=n[r],i=new CustomEvent(E,{bubbles:!0}),i.attrName=n.name,i.prevValue=n.value||null,i.newValue=n.value=t[r]||null,i.prevValue==null?i[y]=i.attrChange=0:i[b]=i.attrChange=1,ct.call(t,i))};e.value=function(e,s,u){e===E&&this[h]&&this.setAttribute!==r&&(this[o]={className:{name:"class",value:this.className}},this.setAttribute=r,this.removeAttribute=n,t.call(this,"propertychange",i)),t.call(this,e,s,u)},B(it,u,e)}()):rt||(M[u](E,bt),M.setAttribute(o,1),M.removeAttribute(o),xt&&(Ct=function(e){var t=this,n,r,i;if(t===e.target){n=t[o],t[o]=r=Lt(t);for(i in r){if(!(i in n))return kt(0,t,i,n[i],r[i],y);if(r[i]!==n[i])return kt(1,t,i,n[i],r[i],b)}for(i in n)if(!(i in r))return kt(2,t,i,n[i],r[i],w)}},kt=function(e,t,n,r,i,s){var o={attrChange:e,currentTarget:t,attrName:n,prevValue:r,newValue:i};o[s]=e,It(o)},Lt=function(e){for(var t,n,r={},i=e.attributes,s=0,o=i.length;s<o;s++)t=i[s],n=t.name,n!=="setAttribute"&&(r[n]=t.value);return r})),n[s]=function(t,r){p=t.toUpperCase(),St||(St=!0,rt?(At=function(e,t){function n(e,t){for(var n=0,r=e.length;n<r;t(e[n++]));}return new rt(function(r){for(var i,s,o,u=0,a=r.length;u<a;u++)i=r[u],i.type==="childList"?(n(i.addedNodes,e),n(i.removedNodes,t)):(s=i.target,Nt&&s[h]&&i.attributeName!=="style"&&(o=ht.call(s,i.attributeName),o!==i.oldValue&&s[h](i.attributeName,i.oldValue,o)))})}(Bt(a),Bt(l)),Ot=function(e){return At.observe(e,{childList:!0,subtree:!0}),e},Ot(n),ft&&(it.attachShadow=function(){return Ot(ft.apply(this,arguments))})):(wt=[],n[u]("DOMNodeInserted",qt(a)),n[u]("DOMNodeRemoved",qt(l))),n[u](S,Rt),n[u]("readystatechange",Rt),it.cloneNode=function(e){var t=lt.call(this,!!e),n=jt(t);return-1<n&&_t(t,A[n]),e&&Ht(t.querySelectorAll(O)),t}),-2<_.call(L,N+p)+_.call(L,T+p)&&Xt(t);if(!C.test(p)||-1<_.call(k,p))throw new Error("The type "+t+" is invalid");var i=function(){return o?n.createElement(f,p):n.createElement(f)},s=r||D,o=P.call(s,c),f=o?r[c].toUpperCase():p,p,d;return o&&-1<_.call(L,T+f)&&Xt(f),d=L.push((o?N:T)+p)-1,O=O.concat(O.length?",":"",o?f+'[is="'+t.toLowerCase()+'"]':f),i.prototype=A[d]=P.call(s,"prototype")?s.prototype:tt(it),Pt(n.querySelectorAll(O),a),i},n.createElement=gt=function(e,t){var r=Qt(t),i=r?mt.call(n,e,et(r)):mt.call(n,e),s=""+e,o=_.call(L,(r?N:T)+(r||s).toUpperCase()),u=-1<o;return r&&(i.setAttribute("is",r=r.toLowerCase()),u&&(u=Ft(s.toUpperCase(),r))),Nt=!n.createElement.innerHTMLHelper,u&&_t(i,A[o]),i}),$t.prototype={constructor:$t,define:V?function(e,t,n){if(n)Jt(e,t,n);else{var r=e.toUpperCase();G[r]={constructor:t,create:[r]},Z.set(t,r),X.define(e,t)}}:Jt,get:V?function(e){return X.get(e)||Kt(e)}:Kt,whenDefined:V?function(e){return K.race([X.whenDefined(e),Yt(e)])}:Yt};if(!X||t==="force")Zt();else try{(function(t,r,i){r[c]="a",t.prototype=tt(HTMLAnchorElement.prototype),t.prototype.constructor=t,e.customElements.define(i,t,r);if(ht.call(n.createElement("a",{is:i}),"is")!==i||V&&ht.call(new t,"is")!==i)throw r})(function rn(){return Reflect.construct(HTMLAnchorElement,[],rn)},{},"document-register-element-a")}catch(en){Zt()}try{mt.call(n,"a","a")}catch(tn){et=function(e){return{is:e}}}})(window);

function gatherEvents(bag, eventList)
{
  switch (bag.type)
  {
    case 'event':
      eventList.push(bag);
      return;

    case 'leaf':
      return;

    case 'node':
      var list = bag.branches;
      while (list.ctor !== '[]')
      {
        gatherEvents(list._0, eventList);
        list = list._1;
      }
      return;

    case 'map':
      gatherEvents(bag.tree, eventList);
      return;
  }
}


function generateEvent(node, cmds){

  var evts = [];
  gatherEvents(cmds, evts);
  for (var idx in evts){
    var evtInfo = evts[idx]; 
    var event;
    if (document.createEvent) {
      event = document.createEvent("HTMLEvents");
      event.initEvent(evtInfo.name, true, true);
    } else {
      event = document.createEventObject();
      event.eventType = evtInfo.name;
    }

    event.eventName = evtInfo.name;
    event.value = evtInfo.payload; 
    if (document.createEvent) {
      node.dispatchEvent(event);
    } else {
      node.fireEvent("on" + event.eventType, event);
    } 
  }
}

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
      generateEvent(node, cmds);
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

var boxRegistry = Object.create(null);

function box(impl){
  if (!(impl.name in boxRegistry) ){
    var proto = Object.create(HTMLElement.prototype);

    proto.createdCallback = function(){
      initializeWC(this, impl); 
      if (!(impl.name in css)){
        loadCSS(this.ownerDocument || document, impl.css);
        css[impl.name] = true 
      };
    };


    proto.attributeChangedCallback = function (name, prev, curr) {
      this.send(name, curr);
    };
    
    document.registerElement(impl.name, { prototype:proto });
    boxRegistry[impl.name] = true
  }
  return _elm_lang$virtual_dom$Native_VirtualDom.node(impl.name)
    
}

function event(name, payload){
  return {
    type: 'event',
    name: name,
    payload: payload
  };
}

return {
    box: box,
    event: F2(event)
};

}();


