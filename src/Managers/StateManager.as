package Managers
{
	import Interfaces.IState;
	
	import core.State;
	
	public class StateManager implements IState
	{
		public static var StateList:Vector.<State>;
		
		public static function init()
		{
			StateList = new Vector.<State>();
		}
		
		public function update():void
		{
			// intera sobre lso estados activos 
			
		}
		
		public function destroy():void
		{
			// destruye la lista de estados activos 
			
		}
		
		public static function addState(state:String):void
		{
			
		}
		
		public static function removeState(state:String):void
		{
			
		}
		
		public static function changeState(state:String):void
		{
			
		}
	}
}