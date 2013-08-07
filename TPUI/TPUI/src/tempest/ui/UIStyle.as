package tempest.ui
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;

	import tempest.ui.components.tips.TSimpleToolTip;
	import tempest.ui.components.tips.TToolTip;
	import tempest.utils.Geom;

	public class UIStyle
	{
		public static var BACKGROUND:uint = 0xCCCCCC;
		public static var BUTTON_FACE:uint = 0xFFFFFF;
		public static var INPUT_TEXT:uint = 0x333333;
		public static var LABEL_TEXT:uint = 0x666666;
		public static var NORMAL_TEXT:uint = 0xFFFFFF;
		public static var DEFAULT_TIP:uint = 0xFFFFFF;
		public static var DROPSHADOW:uint = 0x000000;
		public static var PANEL:uint = 0xF3F3F3;
		public static var PROGRESS_BAR:uint = 0xFFFFFF;
		public static var YELLOW:uint = 0xFF9900;
		public static var BLUE:uint = 0x0099FF;
		public static var BLUE_STR:String = "#0099FF";
		public static var embedFonts:Boolean = true;
		public static var fontName:String = "宋体";
		public static var fontSize:Number = 12;
		public static var DEFAULT_TIP_MAX_WIDTH:uint = 150;
		public static var tipBkSkin:Class = null;
		public static var menuBkSkin:Class = null;
		public static var alertSkin:Class = null;
		public static var inputDialogSkin:Class = null;
		public static var scrollBar:Class = null;
		public static var listItemSkin:Class = null;
		public static var toolTip:TToolTip = null;
		public static var htmlToolTip:TToolTip = null;
		public static var loading:Class = null;
		public static var defaultImageBk:BitmapData = new BitmapData(1, 1, true, 0x00000000);
		public static var textListItemRender:Class = null;
		public static var COVER_ALPHA:Number = 0.5;
//		public static var disableFilter:ColorMatrixFilter = new ColorMatrixFilter([0.35, 0, 0, 0, 41.275,
//																					0, 0.35, 0, 0, 41.275,
//																					0, 0, 0.35, 0, 41.275,
//																					0, 0, 0, 1, 0]);
		public static var disableFilter:ColorMatrixFilter = new ColorMatrixFilter([0.33, 0.33, 0.33, 0, 0,
			0.33, 0.33, 0.33, 0, 0,
			0.33, 0.33, 0.33, 0, 0,
			0, 0, 0, 1, 0]);
		/**
		 *血量警示深色滤镜
		 */
		public static var lowHeightWarning:GlowFilter = new GlowFilter(0x00ff0000, 1, 255, 255, 2, 1, true, true);
		/**
		 *血量警示浅色滤镜
		 */
		public static var lowLightWarning:GlowFilter = new GlowFilter(0x00fa2a2a, 1, 255, 255, 2, 1, true, true);
//		public static var redFilter:ColorMatrixFilter = new ColorMatrixFilter([5, 0, 0, 0, 0, 
//																				  0, 1, 0, 0, 0,
//																				  0, 0, 1, 0, 0,
//																				  0, 0, 0, 1, 0]);
		/**
		 * 文本边框滤镜
		 */
		public static var textBoundFilter:GlowFilter = new GlowFilter(0x0, 1, 2, 2, 5, BitmapFilterQuality.LOW);
		public static var itemSelectFilter:GlowFilter = new GlowFilter(0xFFFF00, 1);
		public static var redFilter:ColorMatrixFilter = new ColorMatrixFilter([0.7, 0.7, 0.7, 0, 0,
			0, 0.2, 0, 0, 0,
			0, 0, 0.2, 0, 0,
			0, 0, 0, 1, 0]);
		public static var yellowFilter:ColorMatrixFilter = new ColorMatrixFilter([0.6, 0.6, 0.6, 0, 0,
			0.3, 0.3, 0.3, 0, 0,
			0, 0, 0.3, 0, 0,
			0, 0, 0, 1, 0]);
		/**
		 *红色滤镜
		 */
		public static var redFiliter:ColorMatrixFilter = Geom.getColorFilter([0xff, 0x00, 0x00, 5]);
		/**
		 * 发光滤镜
		 */
		public static var yellowGlowFilter:GlowFilter = new GlowFilter(0xFFFF00, 1, 5, 5, 3);

		public static function get defaultTextFormat():TextFormat
		{
			return new TextFormat(UIStyle.fontName, UIStyle.fontSize, UIStyle.LABEL_TEXT);
		}
	}
}


