/**
 * @author pjnovas
 */

var Alien = DrawableElement.extend({
	init: function(options){
		this._super(options);
		
		this.images = options.stateImgs || [];
		this.destroyedImg = options.destroyedImg || [];
		
		this.onWallCollision = options.onWallCollision || [];
		
		this.shield = options.shield || null;
		this.ship = options.ship || null;
		
		this.destroyed = false;
		this.shoots = [];
		this.score = options.score || 0;
	},
	build: function(){
		
	},
	update: function(){
		this.hasCollision();
		
		var sX = this.position.x;
		if (sX < this.size.width || sX > mapWidth-10-this.size.width)
			this.onWallCollision();
			
		var sY = this.position.y;
		if (sY < 0 || sY > mapHeight-40)
                        this.ship.collided();
	},
	draw: function(state){
		if (!this.destroyed){
			var idx = (state) ? 0: 1;	
			this._super(this.images[idx]);
		}
		else {
			this._super(this.destroyedImg[0]);
			this.destroy();
			this.onDestroy(this);
		}
	},
	hasCollision: function(){
		var sX = this.position.x + this.size.width/2;
		var sY = this.position.y + this.size.height*0.8;
		
		function checkCollision(arr){
			if (!arr){
				return false;
			}
			
			var cb = arr;
			var cbLen = cb.length;
			
			for(var i=0; i< cbLen; i++){
				var cbO = cb[i];
				
				var cbL = cbO.position.x;
				var cbT = cbO.position.y;
				var cbR = cbL + cbO.size.width;
				var cbD = cbT + cbO.size.height;
				
				if (sX >= cbL && sX <= cbR && sY >= cbT && sY <= cbD && !cbO.destroyed){
					arr[i].collided(true);
					return true;
				}
			}	
			
			return false;
		}
		
		if (checkCollision(this.shield.bricks)) return true;
		if (checkCollision([this.ship])) return true;
	},
	collided: function(){
		this.destroyed = true;
		// window.particles.create([this.position.x + this.size.width/2, this.position.y + this.size.height/2], 10, this.color);
	},
	destroy: function(){
		this._super();
	},
	getScore: function(){
		return this.score;
	}
});
