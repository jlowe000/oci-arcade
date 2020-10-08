
var atlas = (function(){

    var canvas,ctx;
    var size = 22;
    var cols = 14; // has to be ONE MORE than intended to fix some sort of CHROME BUG (last cell always blank?)
    var rows = 22;

    var creates = 0;

    var drawGrid = function() {
        // draw grid overlay
        var canvas = document.getElementById('gridcanvas');
        if (!canvas) {
            return;
        }
        var w = size*cols*renderScale;
        var h = size*rows*renderScale;
        canvas.width = w;
        canvas.height = h;
        var ctx = canvas.getContext('2d');
        ctx.clearRect(0,0,w,h);
        var x,y;
        var step = size*renderScale;
        ctx.beginPath();
        for (x=0; x<=w; x+=step) {
            ctx.moveTo(x,0);
            ctx.lineTo(x,h);
        }
        for (y=0; y<=h; y+=step) {
            ctx.moveTo(0,y);
            ctx.lineTo(w,y);
        }
        ctx.lineWidth = "1px";
        ctx.lineCap = "square";
        ctx.strokeStyle="rgba(255,255,255,0.5)";
        ctx.stroke();
    };

    var create = function() {
        drawGrid();
        canvas = document.getElementById('atlas');
        ctx = canvas.getContext("2d");
        /*
        canvas.style.left = 0;
        canvas.style.top = 0;
        canvas.style.position = "absolute";
        */

        var w = size*cols*renderScale;
        var h = size*rows*renderScale;
        canvas.width = w;
        canvas.height = h;

        if (creates > 0) {
            ctx.restore();
        }
        creates++;

        ctx.save();
        ctx.clearRect(0,0,w,h);
        ctx.scale(renderScale,renderScale);
    };

    var copyCellTo = function(row, col, destCtx, x, y,display) {
    };

    var copyGhostPoints = function(destCtx,x,y,points) {
    };

    var copyPacFruitPoints = function(destCtx,x,y,points) {
    };

    var copyMsPacFruitPoints = function(destCtx,x,y,points) {
    };

    var copyGhostSprite = function(destCtx,x,y,frame,dirEnum,scared,flash,eyes_only,color) {
    };

    var copyMuppetSprite = function(destCtx,x,y,frame,dirEnum,scared,flash,eyes_only,color) {
    };

    var copyMonsterSprite = function(destCtx,x,y,frame,dirEnum,scared,flash,eyes_only,color) {
    };

    var copyOttoSprite = function(destCtx,x,y,dirEnum,frame) {
    };

    var copyMsOttoSprite = function(destCtx,x,y,dirEnum,frame) {
    };

    var copySnail = function(destCtx,x,y,frame) {
    };

    var copyPacmanSprite = function(destCtx,x,y,dirEnum,frame) {
    };

    var copyMsPacmanSprite = function(destCtx,x,y,dirEnum,frame) {
    };

    var copyCookiemanSprite = function(destCtx,x,y,dirEnum,frame) {
    };

    var copyFruitSprite = function(destCtx,x,y,name) {
    };

    return {
        create: create,
        getCanvas: function() { return canvas; },
        drawGhostSprite: copyGhostSprite,
        drawMonsterSprite: copyMonsterSprite,
        drawMuppetSprite: copyMuppetSprite,
        drawOttoSprite: copyOttoSprite,
        drawMsOttoSprite: copyMsOttoSprite,
        drawPacmanSprite: copyPacmanSprite,
        drawMsPacmanSprite: copyMsPacmanSprite,
        drawCookiemanSprite: copyCookiemanSprite,
        drawFruitSprite: copyFruitSprite,
        drawGhostPoints: copyGhostPoints,
        drawPacFruitPoints: copyPacFruitPoints,
        drawMsPacFruitPoints: copyMsPacFruitPoints,
        drawSnail: copySnail,
    };
})();
