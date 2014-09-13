package Interfaces
{
	import starling.events.Event;

	public interface IState
	{
		function loadContent():void;
		function update(event:Event):void;
		function destroy():void;
		function activate():void;
		function deactivate():void;
	}
}