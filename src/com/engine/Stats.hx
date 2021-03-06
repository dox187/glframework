/**
 * Hi-ReS! Stats
 *
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 *
 * How to use:
 *
 *      addChild( new Stats() );
 *      
 *      or
 *      
 *      addChild( new Stats( { bg: 0xffffff } );
 *
 * version log:
 *
 *      09.03.28                2.1             Mr.doob                 + Theme support.
 *      09.02.21                2.0             Mr.doob                 + Removed Player version, until I know if it's really needed.
 *                                                                                      + Added MAX value (shows Max memory used, useful to spot memory leaks)
 *                                                                                      + Reworked text system / no memory leak (original reason unknown)
 *                                                                                      + Simplified                            
 *      09.02.07                1.5             Mr.doob                 + onRemovedFromStage() (thx huihuicn.xu)
 *      08.12.14                1.4             Mr.doob                 + Code optimisations and version info on MOUSE_OVER
 *      08.07.12                1.3             Mr.doob                 + Some speed and code optimisations
 *      08.02.15                1.2             Mr.doob                 + Class renamed to Stats (previously FPS)
 *      08.01.05                1.2             Mr.doob                 + Click changes the fps of flash (half up increases, half down decreases)
 *      08.01.04                1.1             Mr.doob                 + Shameless ripoff of Alternativa's FPS look :P
 *                                                      Theo                    + Log shape for MEM
 *                                                                                      + More room for MS
 *      07.12.13                1.0             Mr.doob                 + First version
 **/

package engine;


import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.system.System;
import flash.text.StyleSheet;
import flash.text.TextField;
import flash.Lib;    
import flash.xml.XML;

/**
* <b>Hi-ReS! Stats</b> FPS, MS and MEM, all in one.
*/
typedef Theme = { bg: UInt, fps: UInt, ms: UInt, mem: UInt, memmax: UInt }

class Stats extends Sprite
{      
		private var _xml : XML;

		private var _text : TextField;
		private var _style : StyleSheet;

		private var _timer : Int;
		private var _fps : Int;
		private var _ms : Int;
		private var _ms_prev : Int;
		private var _mem : Float;
		private var _mem_max : Float;
	   
		private var _graph : BitmapData;
		private var _rectangle : Rectangle;
	   
		private var _fps_graph : UInt;
		private var _mem_graph : UInt;
		private var _mem_max_graph : UInt;
	   
		private var _theme : Theme;

		/**
		 * <b>Hi-ReS! Stats</b> FPS, MS and MEM, all in one.
		 *
		 * @param theme         Example: { bg: 0x202020, fps: 0xC0C0C0, ms: 0x505050, mem: 0x707070, memmax: 0xA0A0A0 }
		 */
		public function new( ?theme : Theme ) : Void
		{
			super();
				_theme = { bg: 0x000033, fps: 0xffff00, ms: 0x00ff00, mem: 0x00ffff, memmax: 0xff0070 }
				if (theme != null)
				{
						_theme = theme;
				}
			   
				addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
		}

		private function init(e : Event) : Void
		{
				removeEventListener(Event.ADDED_TO_STAGE, init);
			   
				graphics.beginFill(_theme.bg);
				graphics.drawRect(0, 0, 70, 50);
				graphics.endFill();

				_mem_max = 0;

				_xml = new XML('<xml><fps>FPS:</fps><ms>MS:</ms><mem>MEM:</mem><memMax>MAX:</memMax></xml>');
	   
				_style = new StyleSheet();
				_style.setStyle("xml", {fontSize:'9px', fontFamily:'_sans', leading:'-2px'});
				_style.setStyle("fps", {color: hex2css(_theme.fps)});
				_style.setStyle("ms", {color: hex2css(_theme.ms)});
				_style.setStyle("mem", {color: hex2css(_theme.mem)});
				_style.setStyle("memMax", {color: hex2css(_theme.memmax)});
			   
				_text = new TextField();
				_text.width = 70;
				_text.height = 50;
				_text.styleSheet = _style;
				_text.condenseWhite = true;
				_text.selectable = false;
				_text.mouseEnabled = false;
				addChild(_text);
			   
				var bitmap : Bitmap = new Bitmap( _graph = new BitmapData(70, 50, false, _theme.bg) );
				bitmap.y = 50;
				addChild(bitmap);
			   
				_rectangle = new Rectangle( 0, 0, 1, _graph.height );                  
			   
				addEventListener(MouseEvent.CLICK, onClick);
				addEventListener(Event.ENTER_FRAME, update);
		}

		private function update(e : Event) : Void
		{
				_timer = Lib.getTimer();
			   
				if( _timer - 1000 >  _ms_prev )
				{
						_ms_prev = _timer;
						_mem = cast ((System.totalMemory * 0.000000954)/*.toFixed(3)*/);
						_mem_max = _mem_max > _mem ? _mem_max : _mem;
					   
						_fps_graph = Std.int(Math.min( 50, ( _fps / stage.frameRate ) * 50 ));
						_mem_graph =  Std.int(Math.min( 50, Math.sqrt( Math.sqrt( _mem * 5000 ) ) ) ) - 2;
						_mem_max_graph =  Std.int(Math.min( 50, Math.sqrt( Math.sqrt( _mem_max * 5000 ) ) ) ) - 2;
					   
						_graph.scroll( 1, 0 );
					   
						_graph.fillRect( _rectangle , _theme.bg );
						_graph.setPixel( 0, _graph.height - _fps_graph, _theme.fps);
						_graph.setPixel( 0, _graph.height - ( ( _timer - _ms ) >> 1 ), _theme.ms );
						_graph.setPixel( 0, _graph.height - _mem_graph, _theme.mem);
						_graph.setPixel( 0, _graph.height - _mem_max_graph, _theme.memmax);
					   
						untyped _xml.fps = "FPS: " + _fps + " / " + stage.frameRate;
						untyped _xml.mem = "MEM: " + _mem;
						untyped _xml.memMax = "MAX: " + _mem_max;
					   
						_fps = 0;
				}

				_fps++;
			   
				untyped _xml.ms = "MS: " + (_timer - _ms);
				_ms = _timer;
			   
				_text.htmlText = _xml.toXMLString();
		}
	   
		private function onClick(e : MouseEvent) : Void
		{
				mouseY / height > .5 ? stage.frameRate-- : stage.frameRate++;
				untyped _xml.fps = "FPS: " + _fps + " / " + stage.frameRate;
				_text.htmlText = _xml.toXMLString();
		}
	   
		// .. Utils
	   
		private function hex2css( color : Int ) : String
		{
				return "#" + StringTools.hex(color);
		}
}