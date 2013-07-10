package asset
{

	public class EmbedRes
	{
		[Embed(source = "asset/logo.swf", mimeType = "application/octet-stream")]
		public static var logo:Class;

		[Embed(source = "asset/LoadUI.swf", symbol = "MainLoader")]
		public static var mainLoader:Class;

		[Embed(source = "asset/weizhi.swf", mimeType = "application/octet-stream")]
		public static var battleGrid:Class;
	}
}
