package core
{
	import Box2D.Common.Math.b2Vec2;
	
	import starling.utils.Color;

	public class Helpers
	{
		public static function randomInt(lowVal:int, highVal:int):int {
			if (lowVal <= highVal) {
				return (lowVal + Math.floor(Math.random() * (highVal - lowVal + 1)));
			} else {
				throw (new Error("Error en los valores pasados al math.random")); 
			}
		} // randomInt
		
		public static function mouseToWorld(mouseX:int, mouseY:int, worldScale:int):b2Vec2
		{
			return new b2Vec2(mouseX / worldScale, mouseY / worldScale);	
		}
		
		public static function getRandomColor(color:uint,finalValue:int = 100, step = 0):uint
		{
			var red = Color.getRed(color);
			var green = Color.getGreen(color);
			var blue = Color.getBlue(color);
			var redRandomNumber = randomInt(red, red + finalValue);
			var greenRandomNumber = randomInt(green, green + finalValue);
			var blueRandomNumber = randomInt(blue, blue + finalValue);
			return Color.rgb(redRandomNumber,greenRandomNumber, blueRandomNumber);
		}
	}
}