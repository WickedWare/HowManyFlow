package Managers
{
	import flash.display.Bitmap;
	import flash.text.Font;
	import flash.utils.Dictionary;
	
	import starling.display.Image;
	import starling.text.BitmapFont;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;
	
	import starling.text.TextField;
	
	public class AssetsManager
	{
		[Embed(source="../Assets/graphics/shuffle.png")]
		private static const shuffle:Class;
		
		[Embed(source="../Assets/graphics/burbuja.png")]
		private static const Bubble:Class;
		
		[Embed(source="../Assets/graphics/PT.SS.0.5.png")]
		private static const AtlasTexture:Class;
		
		[Embed(source="../Assets/graphics/PT.SS.0.5.xml", mimeType="application/octet-stream")]
		private static const AtlasXml:Class;
		
		[Embed(source="../Assets/graphics/myGlyphs.png")]
		private static const FontTexture:Class;
		
		[Embed(source="../Assets/graphics/myGlyphs.fnt", mimeType="application/octet-stream")]
		private static const FontXml:Class;
		
//		[Embed(source="../Assets/fonts/baby_blocks.ttf", fontFamily="MyFontName", embedAsCFF="false")]
//		public static var MyFont:Class;
		
		private static var gameTextures:Dictionary = new Dictionary();
		private static var gameImages:Dictionary = new Dictionary();
		private static var gameTextureAtlas:TextureAtlas;
		private static var MyFont:BitmapFont;
		
		public static function getFont():BitmapFont
		{
			var fontTexture:Texture = Texture.fromBitmap(new FontTexture());
			var fontxml:XML = XML(new FontXml());
			var font:BitmapFont = new BitmapFont(fontTexture,fontxml);
			TextField.registerBitmapFont(font);
			return font;
		}
		
		public static function getAtlas():TextureAtlas
		{
			if (gameTextureAtlas == null)
			{
				var texture:Texture = getTexture("AtlasTexture");
				var xml:XML = XML(new AtlasXml());
				gameTextureAtlas = new TextureAtlas(texture,xml);
			}
			return gameTextureAtlas;
		}
		
		public static function getTexture(name:String):Texture
		{
			if (gameTextures[name] == undefined)
			{
				var bitmap:Bitmap = new AssetsManager[name]();
				gameTextures[name] = Texture.fromBitmap(bitmap);
			}
			return gameTextures[name];
		}
		
		public static function getImage(name:String):Image 
		{
			if (gameImages[name] == undefined)
			{	
				var bitmap:Bitmap = new AssetsManager[name](); 
				gameImages[name] = Image.fromBitmap(bitmap);
			}
			return gameImages[name];
		}
		
		public static function createNewImage(name:String):Image
		{
			var bitmap:Bitmap = new AssetsManager[name]();
			return Image.fromBitmap(bitmap);
		}
	}
}