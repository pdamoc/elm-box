#!/usr/local/bin/python

plat = "./elm-stuff/packages/elm-lang/core/5.0.0/src/Native/Platform.js"
vdom = "./elm-stuff/packages/elm-lang/virtual-dom/2.0.3/src/Native/VirtualDom.js"

platCont = ""
with open(plat, "r") as f:
    platCont = f.read()


vdomCont = ""
with open(vdom, "r") as f:
    vdomCont = f.read()

if not "spawnLoop:spawnLoop" in platCont:
    platCont = platCont.replace("initialize: initialize,", "initialize: initialize,\n\tspawnLoop:spawnLoop,\n\tdispatchEffects:dispatchEffects,\n\tsetupEffects:setupEffects,")
    with open(plat, "w") as f:
        f.write(platCont)

if not "normalRenderer:normalRenderer" in vdomCont:
    vdomCont = vdomCont.replace("keyedNode: F3(keyedNode),", "keyedNode: F3(keyedNode),\n\tnormalRenderer:normalRenderer,")
    with open(vdom, "w") as f:
        f.write(vdomCont)

print "core files PATCHED!"