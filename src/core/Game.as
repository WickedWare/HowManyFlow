package core
{	
	import starling.display.Sprite;
	import starling.events.Event;
	import Screens.DemoState;
	
	public class Game extends Sprite
	{
		public function Game()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			// define pantallas
//			var inGameScreen = new DemoState(this);
//			this.addChild(inGameScreen);
			
			var inGameScreen = new DemoProduce(this);
			this.addChild(inGameScreen);
		}
	}
}