package com.djoker.glteste;

import com.engine.game.Entity;
import com.engine.game.Screen;
import com.engine.render.BlendMode;
import com.engine.render.SpriteBatch;
import com.engine.render.Texture;
import flash.text.TextField;
import flash.text.TextFormat;


/**
 * ...
 * @author djoker
 */
class TesteBatch extends Screen
{

 var tex :Texture;
 var batch:SpriteBatch;


 
 var child:Entity;
 
 var player:Entity;
 var logo:Entity;

   var particles : Array<Particle>;
   var playerTex :Texture;
   var skew:Float = 0;
 
	
	override public function show()
	{
	
		tex = new Texture("assets/texture.png");
	    playerTex = new Texture("assets/zazaka.png");
	
         batch = new SpriteBatch(500);
        particles = [];
        for(i in 0...200)
         addParticle();
		 
	
		 var caption:TextField = new TextField();
		 caption.x =  game.gameWidth / 2-100;
		 caption.y = 20;
		 caption.width = 200;
		 caption.defaultTextFormat = new TextFormat ("_sans", 12, 0xffff00);
		 caption.text = "Test 200 sprites with  SpriteBatch ";
		 caption.selectable = false;
		 game.addChild(caption);
		 
		 player = new  Entity(300, 200, playerTex);
		 child = new  Entity(0, 0, playerTex);
		 child.blue = 0;
		 player.add(child);
		 
		 logo= new Entity(this.width/2,this.height/2,new Texture("assets/hxlogo.png"));
		 
		 game.clarColor(0, 0, 0);


	}

	override public function render(dt:Float) 
	{ 
  
		  player.rotation += dt * 2.1;
		  child.rotation -= dt * 2.5;
		//  player.skewX += dt * 0.1;
		  
		skew += dt * 1;
 
		logo.skewX = Math.sin(skew)*1;
		logo.skewY = Math.cos(skew)*1;
		
		  
	batch.Begin();

	batch.drawEntity(logo);
	
      for(p in particles)
      {
         p.move(dt);
	
        batch.drawImage(p);
      }
	  
	  batch.drawEntity(player);
	  batch.drawEntity(child);
	  
      batch.End();
	

	}

		
		

public function addParticle()
{
	var particle:Particle = new Particle(tex);
	particle.Init();
	particle.blendMode = BlendMode.NORMAL;
    particles.push(particle);
}
public function addParticle2(x:Float,y:Float)
{
	var particle:Particle = new Particle(tex);
	particle.Init();
	particle.x = x;
	particle.y = y;
	particle.blendMode = BlendMode.NORMAL;
    particles.push(particle);
}

override public function mouseDown(mousex:Float, mousey:Float) 
{
	addParticle2(mousex, mousey);
	player.x = mousex;
	player.y = mousey;
}

	
	
}