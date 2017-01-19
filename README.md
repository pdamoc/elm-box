# THIS IS AN EXPLORATION (not working code) 

- `elm-package install` in `examples` folder 

- `elm-make Main.elm --output=elm.js`

- open `Test.html`

## How to patch the current libraries to get this to work 

in `elm-stuff/packages/elm-lang/core/5.0.0/src/Native/Platform.js`

it ends like this: 

```js
return {
    // routers
    sendToApp: F2(sendToApp),
    sendToSelf: F2(sendToSelf),

    // global setup
    effectManagers: effectManagers,
    outgoingPort: outgoingPort,
    incomingPort: incomingPort,

    htmlToProgram: htmlToProgram,
    program: program,
    programWithFlags: programWithFlags,
    initialize: initialize,

    // effect bags
    leaf: leaf,
    batch: batch,
    map: F2(map)
};

}();
```

it should end like this: 

```js
return {
    // routers
    sendToApp: F2(sendToApp),
    sendToSelf: F2(sendToSelf),

    // global setup
    effectManagers: effectManagers,
    outgoingPort: outgoingPort,
    incomingPort: incomingPort,

    htmlToProgram: htmlToProgram,
    program: program,
    programWithFlags: programWithFlags,
    initialize: initialize,

    //needed for pseudo-web-components 
    spawnLoop: spawnLoop,
    dispatchEffects: dispatchEffects,
    setupEffects: setupEffects,

    // effect bags
    leaf: leaf,
    batch: batch,
    map: F2(map)
};

}();

```

in `elm-stuff/packages/elm-lang/virtual-dom/2.0.3/src/Native/VirtualDom.js` 

it ends like this: 

```js 
return {
    node: node,
    text: text,
    custom: custom,
    map: F2(map),

    on: F3(on),
    style: style,
    property: F2(property),
    attribute: F2(attribute),
    attributeNS: F3(attributeNS),
    mapProperty: F2(mapProperty),

    lazy: F2(lazy),
    lazy2: F3(lazy2),
    lazy3: F4(lazy3),
    keyedNode: F3(keyedNode),

    program: program,
    programWithFlags: programWithFlags,
    staticProgram: staticProgram
};

}();

```
it should end like this: 

```js
return {
    node: node,
    text: text,
    custom: custom,
    map: F2(map),

    on: F3(on),
    style: style,
    property: F2(property),
    attribute: F2(attribute),
    attributeNS: F3(attributeNS),
    mapProperty: F2(mapProperty),

    lazy: F2(lazy),
    lazy2: F3(lazy2),
    lazy3: F4(lazy3),
    keyedNode: F3(keyedNode),

    // needed for the pseudo-web-components
    normalRenderer: normalRenderer,

    program: program,   
    programWithFlags: programWithFlags,
    staticProgram: staticProgram
};

}();

```
