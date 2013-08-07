package assets
{

	public class EmbedRes
	{
		[Embed(source = "assets/res/loading.swf", symbol = "sloading")]
		public static var loadingSkin:Class;

		[Embed(source="assets/res/loading.swf", symbol="wait_loading")]
		public static var waitingLoadBar:Class;
		
		[Embed(source = "assets/res/logo.swf", mimeType = "application/octet-stream")]
		public static var logo:Class;

		[Embed(source = "assets/res/LoadUI.swf", symbol = "MainLoader")]
		public static var mainLoader:Class;
		
		[Embed(source = "assets/res/battleposition.swf", symbol = "battle_position")]
		public static var battleGrid:Class;
	}
}
