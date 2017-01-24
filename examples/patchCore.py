#!/usr/local/bin/python

import os, re

def max_ver(path):
    versions = filter(re.compile('[0-9]+.[0-9]+.[0-9]+').match, os.listdir(path))
    return  ".".join(map(str, max([map(int, i.split(".")) for i in versions])))

plat = "./elm-stuff/packages/elm-lang/core/" + max_ver("./elm-stuff/packages/elm-lang/core")+"/src/Native/Platform.js"
vdom = "./elm-stuff/packages/elm-lang/virtual-dom/" + max_ver("./elm-stuff/packages/elm-lang/virtual-dom/")+"/src/Native/VirtualDom.js"

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