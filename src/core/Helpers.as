package core
{
	public class Helpers
	{
		public static function randomInt(lowVal:int, highVal:int):int {
			if (lowVal <= highVal) {
				return (lowVal + Math.floor(Math.random() * (highVal - lowVal + 1)));
			} else {
				throw (new Error("Error en los valores pasados al math.random")); 
			}
		} // randomInt
	}
}