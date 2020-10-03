/**
 * @author pjnovas
 */

window.particles = (function(){

  var pars = [],
    gravity = [5, 40],
    ctx,
    size;

  function rnd(from, to){
    return Math.floor((Math.random()*to)+from);
  }

  function rndM(){
    return (Math.round(Math.random()) ? 1 : -1);
  }
  
  return {
    init: function(_ctx, _size){
      ctx = _ctx;
      size = _size;
      pars = [];
    },
    create: function(pos, qty, color){
      for (var i=0; i < qty; i++){
        var vel = [rnd(10, 30)*rndM(), rnd(10, 30)*-1];
        pars.push({
          pos: [pos[0] + (rnd(1, 3)*rndM()), pos[1] + (rnd(1, 3)*rndM())],
          vel: vel,
          c: color
        });
      }
    },
    update: function(dt){
      dt = dt/500;
      for(var i=0; i < pars.length; i++){
        var p = pars[i];
        p.vel[0] += gravity[0] * dt;
        p.vel[1] += gravity[1] * dt;

        p.pos[0] += p.vel[0] * dt;
        p.pos[1] += p.vel[1] * dt;

        if (p.pos[1] > size.h){
          pars.splice(i, 1);
        }
      }
    },
    draw: function(dt){
      for(var i=0; i < pars.length; i++){
        var p = pars[i];
        ctx.save();
        ctx.fillStyle = p.c;
        ctx.fillRect(p.pos[0], p.pos[1], 3, 3);
        ctx.restore();
      }
    }
  }

})();