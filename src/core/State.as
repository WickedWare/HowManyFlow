package core
{
	import Interfaces.IState;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class State extends Sprite implements IState
	{
		protected var _active:Boolean;
		protected var _id:String;
		
		public function State()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(event:Event):void
		{
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		
		public function loadContent():void
		{
			
		}
		
		public function update(event:Event):void
		{
			
		}
		
		public function destroy():void
		{
			
		}
		
		public function activate():void
		{
			this._active = true;
		}
		
		public function deactivate():void
		{
			this._active = false;
		}
		
		//properties 
		public function get Active():Boolean
		{
			return _active;
		}
		
		public function set Active(value:Boolean):void
		{
			_active = value;
		}
		
		public function get Id():String
		{
			return _id;
		}
		
		public function set Id(value:String):void
		{
			_id = value;
		}

	}
}