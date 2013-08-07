package fj1.common.data.dataobject.items.toolTipShowers
{
	import fj1.common.staticdata.ToolTipName;

	import flash.display.DisplayObject;

	import tempest.common.staticdata.StyleSheetType;
	import tempest.ui.components.tips.TRichTextToolTip;
	import tempest.ui.interfaces.IRichTextTipClient;
	import tempest.utils.HtmlUtil;

	public class BaseToolTipShower implements IRichTextTipClient
	{
		public static var normalRed:String = "#FF0000";
		public static var normalGreen:String = "#00FF00";
		public static var normalWhite:String = "#FFFFFF";
		public static var normalBlue:String = "#0099FF";
		public static var normalYellow:String = "#FF9900";
		public static var normalLightYellow:String = "#FFD323";
		public static var nameYellow:String = "#FF9900";
		public static var normalPurple:String = "#D700FF";
		public static var spaceStr:String = "                            ";
		public static var spaceStr1:String = "    ";
		public static var colonStr:String = "：";

		public function BaseToolTipShower()
		{
		}

		public function getTipWidth():int
		{
			return 200;
		}

		/**
		 * Tip中图片数据列表
		 * {id: "img", imgUrl: path, defaultImg:defaultBitmapData, w: 36, h: 36, align: "lineHead", marginX:140, marginY:0}
		 * @return
		 *
		 */
		public function getImageList():Array
		{
			return null;
		}

		public function getTipDataArray(params:Object):Array
		{
			return null;
		}

		public function getIconImage():DisplayObject
		{
			return null;
		}

		public function onTipHide(toolTip:TRichTextToolTip):void
		{

		}

		/**
		 * TipCSS样式
		 * @return
		 *
		 */
		public function getCssType():String
		{
			return StyleSheetType.DEFAULT;
		}

		public function getTipString(place:int = 0):String
		{
			return rebuildTipString(place);
		}

		/**
		 * 重新构建字符串，派生类重写该方法设置并返回_tipString
		 * @return
		 *
		 */
		protected function rebuildTipString(place:int = 0):String
		{
			return null;
		}

		/**
		 * Tip类型
		 * @return
		 *
		 */
		public function getTipType():String
		{
			return ToolTipName.RICHTEXT;
		}

		/**
		 *  追加newText参数指定的文本和newSprites参数指定的显示元素到文本字段的末尾。
		 * @param newText  要追加的新文本。
		 * @param newSprites 要追加的显示元素数组，每个元素包含src和index两个属性，如：{src:sprite, index:1}。
		 * @param autoWordWrap 指示是否自动换行。
		 * @return
		 *
		 */
		public static function makeAppendParams(newText:String, newSprites:Array = null, autoWordWrap:Boolean = false):Object
		{
			return {text: newText, newSprites: newSprites, autoWordWrap: autoWordWrap};
		}

		/**
		 * 获得richtextfield的append的值
		 * @param pos 对齐方向
		 * @param color 字体颜色
		 * @param text 文本
		 * @return richtextfield的append的值
		 *
		 */
		public static function makeAppendParams2(pos:String = "left", color:String = "#FFFFFF", text:String = ""):Object
		{
			return makeAppendParams(getHtmlTextWithAlign(pos, color, text));
		}

		/**
		 * 获得htmltext字符串
		 * @param pos 对齐方向
		 * @param color 字体颜色
		 * @param text 文本
		 * @return htmltext字符串
		 *
		 */
		public static function getHtmlTextWithAlign(pos:String = "left", color:String = "#FFFFFF", text:String = ""):String
		{
			var str:String;
			str = HtmlUtil.tag('p', [{key: 'align', value: pos}], HtmlUtil.color(color, text));
			return str;
		}

		/**
		 * 获得带段落标签的htmlText字符串
		 * @param pos
		 * @param text
		 * @return
		 *
		 */
		public static function getParagraphText(pos:String = "left", text:String = ""):String
		{
			return HtmlUtil.tag('p', [{key: 'align', value: pos}], text);
		}

		/**
		 * 设置粗体
		 * @param text 文本
		 * @return 粗体文本
		 *
		 */
		public function setBoldText(text:String):String
		{
			return HtmlUtil.bold(text);
		}
		
		/**
		 *设置字体大小
		 * @param text
		 * @param size
		 * @return
		 *
		 */
		public function setSize(text:String, size:int):String
		{
			return HtmlUtil.tag("font", [{key: "size", value: size}], text);
		}
	}
}
