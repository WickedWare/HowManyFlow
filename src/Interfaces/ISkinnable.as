package Interfaces
{
	import starling.textures.Texture;

	public interface ISkinnable
	{
		function applySkin(texture:Texture);
		function removeSkin(texture:Texture);
	}
}