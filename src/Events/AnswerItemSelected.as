package Events
{
	import starling.events.Event;
	
	public class AnswerItemSelected extends Event
	{
		public static const ITEMSELECTED = "itemselected";
		
		public function AnswerItemSelected(type:String,bubbles:Boolean=false, data:Object=null)
		{
			super(type, bubbles, data);
		}
	}
}