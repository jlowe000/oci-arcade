/**
 * @author pjnovas
 */

// const SCORE_BASE_URL = 'http://'+window.location.hostname+':8081/score';
const SCORE_BASE_URL = 'https://'+API_HOSTNAME+'/score';

var Game = Class.extend({
  init : function(options) {
    this.canvas = options.canvas || this.initCanvas(options.canvasId);
    this.ctx = null;

    this.loopInterval = 10;
    this.currentDir = [];

    this.startx = 0;
    this.starty = 0;
    this.endx = 0;
    this.endy = 0;
    this.dx = 0;
    this.dy = 0;
    this.currdir = 0;
    this.listener = 'None';
    this.touchlength = 0;

    this.shield = {};
    this.shieldshape = '';
    this.ship = {};
    this.invasion = {};

    this.initCanvas(options.canvasId);
    
    this.onLose = options.onLose || function(){};
    this.onWin = options.onWin || function(){};
    this.onExit = options.onExit || function(){};

    this.isOnGame = false;
    this.level = 0;
    this.instance_id = '';
    this.hiscore = null;

    // this.boundGameRun = this.gameRun.bind(this);

    /* FPS Info */
    this.fps = 0
    this.now = null;
    this.lastUpdate = (new Date) * 1 - 1;
    this.fpsFilter = this.loopInterval;

    var self = this;
    var fpsOut = document.getElementById('fps');
    setInterval(function() {
      fpsOut.innerHTML = self.fps.toFixed(1) + "fps";
    }, 1000);
    /* End FPS Info */
  },
  initCanvas : function(canvasId) {
    this.canvas = document.getElementById(canvasId || 'canvas');
    // this.canvas.hidden = true;
    this.ctx = this.canvas.getContext('2d');
    // this.ctx.scale(0.75,0.75);
    // window.particles.init(this.ctx, { x1: mapMargin, y1: mapHeight, x2: mapWidth, y2: mapHeight });
  },
  start : function() {
    // this.canvas.hidden = false;
    this.isOnGame = true;
    this.instance_id = window.name + ":" + Date.now();
    this.level = 0;
    console.log("instance_id (event):"+this.instance_id);
    EventHandler.addEvent({ "game_id": 5, "instance_id": this.instance_id, "user_id": window.name, "state" : "NEW_GAME" });
    // this.gameRun();
  },
  end : function() {
    // this.canvas.hidden = true;
    this.isOnGame = false;
  },
  resetLevel : function() {
    var self = this;

    this.shield = new Shield({
      ctx : this.ctx,
      x : 200,
      y : 440,
      brickSize : 8,
      color : '#fff',
      shape : this.shieldshape
    });

    this.invasion = new Invasion({
      ctx : this.ctx,
      x : 60,
      y : 100,
      shield : this.shield,
      ship : this.ship,
      onAliensClean : function() {
        self.stop();
        console.log('Win');
        self.onWin();
      }
    });

    // window.particles.init(this.ctx, { x1: mapMargin, y1: mapHeight, x2: mapWidth, y2: mapHeight });
    this.level = level + 1;
    console.log("instance_id (event):"+this.instance_id);
    EventHandler.addEvent({ "game_id": 5, "instance_id": this.instance_id, "user_id": window.name, "score": this.ship.getScore(), "level": this.level, "state" : "NEW_LEVEL" });
    this.ship.invasion = this.invasion;
    this.currentDir = [];
    this.isOnGame = true;

    this.gameRun();
  },
  resetLife : function() {
    var self = this;

    console.log("instance_id (event):"+this.instance_id);
    EventHandler.addEvent({ "game_id": 5, "instance_id": this.instance_id, "user_id": window.name, "score": this.ship.getScore(), "level": this.level, "x": this.ship.pos().x, "y": this.ship.pos().y, "state" : "DIED" });
    if (this.lives > 0) {
        this.lives = this.lives - 1;
        console.log('lives = '+this.lives);
        this.invasion.clearShoot();
        this.ship.clearShoot();
        // window.particles.init(this.ctx, { x1: mapMargin, y1: mapHeight, x2: mapWidth, y2: mapHeight });
        this.isOnGame = true;
    } else {
        this.isOnGame = false;
        console.log('game score = '+this.ship.getScore());
        console.log("instance_id (event):"+this.instance_id);
        EventHandler.addEvent({ "game_id": 5, "instance_id": this.instance_id, "user_id": window.name, "score": this.ship.getScore(), "level": this.level, "state" : "GAME_OVER" });
        axios.post(SCORE_BASE_URL,{ "game_id": 5, "user_id": window.name, "score": this.ship.getScore() })
        .then(scoreres => {
            console.log(scoreres);
        })
        .catch(err => {
            console.log(err);
        })
        // self.destroy();
        console.log('Reset');
        self.onExit();
        // this.build();
        // window.particles.init(this.ctx, { x1: mapMargin, y1: mapHeight, x2: mapWidth, y2: mapHeight });
    }
    this.gameRun();
  },
  getHiScore: function() {
    if (this.hiscore === null) {
      this.hiscore = 0;
      axios.get(SCORE_BASE_URL+'?game_id=5')
      .then(scoreres => {
        console.log(scoreres);
        this.hiscore = scoreres.data.items[0].score;
        return this.hiscore;
      })
      .catch(err => {
        console.log(err);
        return 0;
      })
    } else {
      if (this.ship.getScore() > this.hiscore) {
        this.hiscore = this.ship.getScore();
      }
      return this.hiscore;
    }
  },
  isGameOn: function() {
    return this.isOnGame;
  },
  gameRun: function(){
    // if (window.gameTime.tick()) { this.loop(); }
    // this.tLoop = window.requestAnimationFrame(this.boundGameRun);
  },
  build : function() {
    var self = this;

    this.lives = 2;

    this.shield = new Shield({
      ctx : this.ctx,
      x : 120,
      y : 440,
      brickSize : 8,
      color : '#fff',
      shape : this.shieldshape
    });

    var cnvW = mapWidth; // this.canvas.width;

    this.ship = new Ship({
      ctx : this.ctx,
      shield : this.shield,
      maxMoveLeft : 5,
      maxMoveRight : cnvW - 10,
      x : ((cnvW - 10) / 2),
      y : 510,
      color : '#1be400',
      onShipHit : function() {
        self.stop();
        console.log('Lose');
        self.onLose();
      }
    });

    this.invasion = new Invasion({
      ctx : this.ctx,
      x : 60,
      y : 100,
      shield : this.shield,
      ship : this.ship,
      onAliensClean : function() {
        self.stop();
        console.log('Win');
        self.onWin();
      }
    });

    this.ship.invasion = this.invasion;

    this.currentDir = [];

    this.isOnGame = true;
    this.bindControls();
  },
  loop : function() {
    if (this.isOnGame){
      this.update(window.gameTime.frameTime);
    }
    this.draw();
  },
  update : function(dt) {
    if (this.isOnGame){
        // console.log('frame:'+dt);
        this.shield.update(dt);
        this.ship.update(this.currentDir, dt);
        this.invasion.update(dt);
        // window.particles.update(dt);
    }
  },
  draw : function() {
//    if (this.isGameOn) {
        this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);

        this.ctx.font = "16px ArcadeR";
        this.ctx.textBaseline = "top";
        this.ctx.fillStyle = "#FFF";
        this.ctx.textAlign = "right";
        this.ctx.fillText("1UP "+window.name, 8*16, 16);
        this.ctx.fillText(((this.ship.getScore() == 0) ? "00" : this.ship.getScore()), 8*16, 32);
        this.ctx.fillText("LIVES", 36*16, 16);
        this.ctx.fillText(this.lives, 36*16, 32);
        this.ctx.fillText("HI SCORE", 24*16, 16);
        this.ctx.fillText(((this.getHiScore() == 0) ? "00" : this.getHiScore()), 24*16, 32);

        this.shield.draw();
        this.ship.draw();
        this.invasion.draw();
        // window.particles.draw();

        /* FPS Info */
        var thisFrameFPS = 1000 / ((this.now = new Date) - this.lastUpdate);
        this.fps += (thisFrameFPS - this.fps) / this.fpsFilter;
        this.lastUpdate = this.now;
        /* End FPS Info */
//    }
  },
  bindControls : function(params) {
    var self = this;
    var gameKeys = [Keyboard.Space, Keyboard.Left, Keyboard.Right];
    var r = 1;
    // var dx = 0;
    // var dy = 0;
    // var x = 0;
    // var y = 0;

    function getAction(code) {
      switch (code) {
        case Keyboard.Space:
          return Controls.Shoot;
        case Keyboard.Left:
          return Controls.Left;
        case Keyboard.Right:
          return Controls.Right;
      }

      return null;
    }
    
    document.addEventListener('touchstart', function(event) {
      event.preventDefault();
      self.listener = 'touchstart';
      if(self.isOnGame) {
        // commit new anchor
        self.startx = event.targetTouches[0].screenX;
        self.starty = event.targetTouches[0].screenY;
        self.touchlength = event.touches.length;
        self.currdir = Controls.Shoot;
        self.currentDir[0] = self.currdir;
      }
    });

    document.addEventListener('touchmove', function(event) {
      event.preventDefault();
      self.listener = 'touchmove';
      if(self.isOnGame) {
        self.endx = event.touches[0].screenX;
        self.endy = event.touches[0].screenY;
        self.dx = self.endx - self.startx;
        self.dy = self.endy - self.starty;
        if (Math.abs(self.dx) > 4) {
          self.currdir = (self.dx>0 ? Controls.Right: Controls.Left);
        }
        self.currentDir[0] = self.currdir;
        // register direction
        // if (Math.abs(dx) >= Math.abs(dy)) {
        //   pacman.setInputDir(dx>0 ? DIR_RIGHT : DIR_LEFT);
        // }
        // else {
        //   pacman.setInputDir(dy>0 ? DIR_DOWN : DIR_UP);
        // }
        // event.stopPropagation();
        // event.preventDefault();
        self.touchlength = event.touches.length;
      }
    });

    document.addEventListener('touchend', function(event) {
      event.preventDefault();
      self.listener = 'touchend';
      // get current distance from anchor
      if(self.isOnGame) {

        // if(self.currentDir.indexOf(dir) === -1)
        self.currentDir = [];

        // var dir = self.currdir;
        // var pos = self.currentDir.indexOf(dir);
        // if(pos > -1)
        //   self.currentDir.splice(pos, 1);
      }
    });

    document.addEventListener('keydown', function(event) {
      if(self.isOnGame) {
        var key = event.keyCode;

        if(gameKeys.indexOf(key) > -1) {
          var dir = getAction(key);

          if(self.currentDir.indexOf(dir) === -1)
            self.currentDir.push(dir);

          event.stopPropagation();
          event.preventDefault();
          return false;
        }
      }
    });

    document.addEventListener('keyup', function(event) {
      if(self.isOnGame) {
        var key = event.keyCode;

        var dir = getAction(key);
        var pos = self.currentDir.indexOf(dir);
        if(pos > -1)
          self.currentDir.splice(pos, 1);
      }
    });

  },
  unbindControls : function(params) {
    document.removeEventListener('keydown', function() {});
    document.removeEventListener('keyup', function() {});
  },
  destroy : function() {
    this.shield.destroy();
    this.invasion.destroy();
    this.ship.destroy();
  },
  stop : function() {
    //this.unbindControls();
    this.isOnGame = false;

    for(var i = 0; i < this.currentDir.length; i++)
    this.currentDir[i] = null;

    this.currentDir = [];

    // this.destroy();
  },
  drawSplash : function(callback) {
    var ctx = this.ctx,
      cellSize = 1,
      cols = mapHeight/cellSize,
      colsL = mapWidth/cellSize,
      colIdx = 0;
      
    function drawColumn(idx, color){
      for(j=0; j< colsL; j++){
        ctx.save();
        ctx.fillStyle = color;  
        ctx.fillRect(mapMargin+mapPad+idx*(cellSize+20),mapMargin+mapPad+j*cellSize , cellSize+20, cellSize); 
        ctx.restore();
      }
    }
    
    var loopInterval = this.loopInterval;

    function doForward(){
      for(var i=0; i<5; i++){
        drawColumn(colIdx+i, "rgba(208,57,42," + (i ? i/10 : 1) + ")"); 
      }

      colIdx++;

      if(colIdx < colsL/10)
        setTimeout(doForward, loopInterval);
      else {
        colIdx = colsL/10;
        doBack();
      }
    }

    function doBack(){
      for(var i=5; i>=0; i--){
        drawColumn(colIdx-i, "rgba(0,0,0," + (i ? i/10 : 1) + ")"); 
      }

      colIdx--;

      if(colIdx > 0)
        setTimeout(doBack, loopInterval);
      else {
        callback();
      }
    }

    doForward();
  }
});
