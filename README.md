# THIS CODE IS EXPERIMENTAL


# To play 

in the `examples` folder run:


    elm-package install -y
    python patchCore.py
    elm-reactor

navigate to [http://localhost:8000/](http://localhost:8000/)

The examples show how to create boxes and how to compose them in your elm apps. 

The `patchCore.py` is a temporary measure. It simply adds a few lines that exposes private functions needed by the implementation. Two files are affected: `Platform.js` and `VirtualDom.js`.  