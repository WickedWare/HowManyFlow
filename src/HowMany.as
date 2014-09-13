package 
{	
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import net.hires.debug.Stats;
	
	import starling.core.Starling;
	import starling.core.starling_internal;
	import starling.events.Event;
	import core.Game;
	
	[SWF(frameRate="60", width="1280", height="800", backgroundColor="0x333333")]
	public class HowMany extends flash.display.Sprite
	{
		private var stats:Stats;
		private var starling:Starling;
		public static var debugSprite:Sprite;
		
		public function HowMany()
		{
			stats = new Stats();
			this.addChild(stats);
		
			// objeto starling 
			starling = new Starling(Game, stage);
			starling.antiAliasing = 1;
			starling.start();
			debugSprite = new Sprite();
			stage.stage3Ds[0].addEventListener(flash.events.Event.CONTEXT3D_CREATE, onContextCreated);
		}
		
		protected function onContextCreated(event:flash.events.Event):void
		{
			//debug mode
			this.addChild(debugSprite);	
		}
	}
}