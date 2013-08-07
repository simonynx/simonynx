package tempest.ui.helper
{
	import com.riaidea.text.RichTextField;

	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;

	import tempest.ui.components.TComponent;
	import tempest.utils.StringUtil;

	public class TextFieldHelper
	{
//		private var _textField:TextField;
//		public var _text:int;

//		public function NumberTextField(constraints:Object = null, textField:TextField = null)
//		{
//			super(constraints, textField);
//			_textField = textField;
//			_text = int(_textField.text);
//		}
//
//		public function set text(value:String):void
//		{
//			_textField.text = getMoneyFormat(_textField.text);
//		}
		public static function getMoneyFormat(str:String):String
		{
			var arr:Array = new Array();
			//逗号个数
			var commaNum:int = (str.length - 1) / 3;
			//余数
			var remainder:int;
			if (str.length % 3 == 0)
				remainder = 3;
			else
				remainder = str.length % 3;
			for (var i:int = 0; i < commaNum + 1; i++)
			{
				var s:int;
				var e:int;
				if (i == 0)
					s = 0;
				else
					s = (i - 1) * 3 + remainder;
				e = i * 3 + remainder;
				arr.push(str.slice(s, e));
			}
			return arr.join(",");
		}

		public static function getMoney(myStr:String):String
		{
			var mystr:String;
			mystr = String(parseInt(myStr.split(",").join("")));
			if (mystr == "NaN")
				mystr = "";
			return mystr;
		}

		/**
		 * 复制 TextFormat
		 * @param src
		 * @return
		 *
		 */
		public static function copyFormat(src:TextFormat):TextFormat
		{
			var tar:TextFormat = new TextFormat();
			tar.align = src.align;
			tar.blockIndent = src.blockIndent;
			tar.bold = src.bold;
			tar.bullet = src.bullet;
			tar.color = src.color;
			tar.display = src.display;
			tar.font = src.font;
			tar.indent = src.indent;
			tar.italic = src.italic;
			tar.kerning = src.kerning;
			tar.leading = src.leading;
			tar.leftMargin = src.leftMargin;
			tar.letterSpacing = src.letterSpacing;
			tar.rightMargin = src.rightMargin;
			tar.size = src.size;
			tar.tabStops = src.tabStops;
			tar.target = src.target;
			tar.underline = src.underline;
			tar.url = src.url;
			return tar;
		}

		/**
		 * 获取指定字符串在TextField中的显示矩形
		 * @param str
		 * @param textField
		 * @return
		 *
		 */
		public static function getTextBound(str:String, textField:TextField):Rectangle
		{
			var boundRect:Rectangle = null;
			var char:String;
			var rect:Rectangle;
			var fullStr:String = textField.text;
			for (var i:int = 0; i < str.length; i++)
			{
				char = str.charAt(i);
				var charIndex:int = fullStr.indexOf(char);
				rect = textField.getCharBoundaries(charIndex);

				//计算外包矩形
				if (!boundRect)
				{
					boundRect = rect;
				}
				else
				{
					boundRect.x = Math.min(boundRect.x, rect.x);
					boundRect.y = Math.min(boundRect.y, rect.y);
					boundRect.bottom = Math.max(boundRect.bottom, rect.bottom);
					boundRect.right = Math.max(boundRect.right, rect.right);
				}

			}

			return boundRect;
		}

		/**
		 * 添加混排文本到RichTextField
		 * newText中使用占位符如：{passId}
		 * newSprites中的显示对象会被按顺序添加到占位符位置
		 * @param textField
		 * @param newText 包含占位符的文本
		 * @param newSprites 显示对象列表，其中的显示对象会被按顺序添加到占位符位置
		 * @param autoWordWrap
		 * @param format
		 *
		 */
		public static function append2(textField:RichTextField, newText:String, newSprites:Array = null, autoWordWrap:Boolean = false, format:TextFormat = null):void
		{
			var index:int = 0;
			append(textField, newText, function(match:String):Sprite
			{
				return newSprites[index++];
			}, autoWordWrap, format);
		}

		/**
		 * 添加混排文本到RichTextField
		 * newText中使用占位符如：{passId}
		 * 通过spriteHandler获取占位符对应的显示对象
		 * @param textField
		 * @param newText 包含占位符的文本
		 * @param spriteHandler 获得用于替换占位符的显示对象的回调函数，返回显示对象，参数为完整的占位符（包含大括号）
		 * @param autoWordWrap
		 * @param format
		 *
		 */
		public static function append(textField:RichTextField, newText:String, spriteHandler:Function, autoWordWrap:Boolean = false, format:TextFormat = null):void
		{
			var result:Object = analysisSprite(newText, textField.html, spriteHandler);
			textField.append(result.text, result.sprites, autoWordWrap, format);
		}

		/**
		 * 解析带图文混排占位符的字符串
		 * 替换占位符，并获得RichTextField所需的图文混排格式的参数
		 * @param text 包含占位符的文本
		 * @param html 是否以html文本处理
		 * @param spriteHandler 获得用于替换占位符的显示对象的回调函数，返回显示对象，参数为完整的占位符（包含大括号）
		 * @return
		 *
		 */
		public static function analysisSprite(text:String, html:Boolean, spriteHandler:Function):Object
		{
			var oldText:String = text;
			var reg:RegExp;
			if (html)
			{
				//过滤html标签
				reg = /<.*?>|&quot;/g;
				text = text.replace(reg, function():String
				{
					if (arguments[0] == "<br>" || arguments[0] == "<br/>")
						return "\n";
					else if (arguments[0] == "&quot;")
						return "\"";
					else
						return "";
				});
			}
			reg = /{.*?}/;
			//获取图片对应字符位置
			var spriteBuff:Array = [];
			while (true)
			{
				var match:Object = reg.exec(text);
				if (!match)
				{
					break;
				}
				spriteBuff.push({src: spriteHandler(match[0]), index: match.index}); //记录插入位置
				var _text:String = text.replace(reg, "");
				if (_text == text)
					break;
				text = _text;
			}
			reg = /{.*?}/g;
			return {text: oldText.replace(reg, ""), sprites: spriteBuff};
		}
	}
}
