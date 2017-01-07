var _pdamoc$elm_box$Native_Box = function()
{

function define(impl){
    var newClass = new DOMClass({
        name: impl.name,
        constructor: function () {
            this.textContent = 'Hello from the other side!';
        }, 
        css : {button : {'color': "#f00"}}
    });
    // console.log(newClass())
    return true;
}

return {
    define: define
};

}();


