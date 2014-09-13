package core
{
	import Events.AnswerItemSelected;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	public class AnswerItem extends TextField
	{
		private var stringId:String;
		private var touch:Touch;
		
		public function AnswerItem(width:int, height:int, text:String, fontName:String="Verdana", fontSize:Number=12, color:uint=0x0, bold:Boolean=false)
		{
			super(width, height, text, fontName, fontSize, color, bold);
			this.stringId = text;
			//this.addEventListener(TouchEvent.TOUCH, onTouch);
			this.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			touch = event.getTouch(this);
			if (touch != null)
			{
				if (touch.phase == TouchPhase.BEGAN)
					this.dispatchEvent(new AnswerItemSelected(AnswerItemSelected.ITEMSELECTED,true,{id:this.stringId}));
			}
		}
	}
}