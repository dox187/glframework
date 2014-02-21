package com.djoker.glteste;

import com.engine.game.Screen;

import com.engine.render.BatchPrimitives;
import com.engine.render.Texture;
import com.engine.render.OrthoCamera;

import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFormat;

/**
 * ...
 * @author djoker
 */
class TestePrimitives extends Screen
{

 
 var batch:BatchPrimitives;
 var camera:OrthoCamera;





	
	override public function show()
	{
	
		
        camera = new OrthoCamera(640, 480);
		batch = new  BatchPrimitives(camera, 500);
		

		 var caption:TextField = new TextField();
		 caption.x =  game.screnWidth / 2-100;
		 caption.y = 20;
		 caption.width = 200;
		 caption.defaultTextFormat = new TextFormat ("_sans", 12, 0xaa00ff);
		 caption.text = "Teste Primitives Batch";
		 game.addChild(caption);


	}

	override public function render(dt:Float) 
	{ 
    camera.Update();
	

	batch.begin();
	
	batch.renderMode(false);
	batch.line(10, 10, 100, 100, 1, 0, 1);
	batch.rect(100, 100, 90, 120, 1, 1, 1);
	batch.circle(100, 100, 12, 8, 1, 1, 1, 1);
	batch.ellipse(300, 90, 55, 15, 8, 1, 1, 1, 1);
	batch.render();

	batch.renderMode(true);
	batch.fillrect(200, 200, 50, 50, 1, 0, 0, 1);
	batch.fillrect(280, 200, 50, 50, 1, 0, 1, 1);
	batch.fillcircle(200, 100, 8, 18, 1, 1, 1, 1);
	batch.fillellipse(300, 100, 55, 15, 8, 1, 1, 1, 1);
 	batch.render();
	
	batch.end();
	
    }
	override public function resize(width:Int, height:Int) 
	{
	game.setViewPort(0, 0, width, height);
	}
		
		
		


	
	
}