package fj1.common.flytext
{
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import tempest.core.IPoolClient;
	import tempest.engine.tools.ScenePool;
	import tempest.ui.UIStyle;
	import tempest.ui.components.textFields.TText;

	public class FlyableText extends BaseFlyText
	{
		public static const TEXT_SIZE_20:int = 20;
		public static const TEXT_SIZE_32:int = 32;
		private var _body:TText = new TText();
		private var _textFormat:TextFormat;
		private static var filterArr:Array = [new GlowFilter(3591, 1, 4, 4, 4, BitmapFilterQuality.LOW)];

		public function FlyableText(orien:int, content:String, textFormat:String, size:int)
		{
			_textFormat = new TextFormat(textFormat ? textFormat : UIStyle.fontName);
			_body.textField.autoSize = TextFieldAutoSize.CENTER;
			_body.selectable = false;
			this.mouseEnabled = this.mouseChildren = false;
			bodySize = size;
			setText(orien, content);
			_body.filters = filterArr;
			_body.format = _textFormat;
			_body.x = -(_body.width >> 1);
			_body.y = -_body.height;
			this.addChild(_body);
		}

		public override function reset(args:Array):void
		{
			this.alpha = 1;
			_textFormat = new TextFormat(args[2] ? args[2] : UIStyle.fontName);
			bodySize = args[3];
			setText(args[0], args[1]);
			_body.format = _textFormat;
			_body.x = -_body.width >> 1;
			_body.y = -_body.height;
			this.addChild(_body);
		}

		public override function dispose():void
		{
			if (this)
			{
				this.x = 0;
				this.y = 0;
				this.alpha = 1;
				bodySize = 0;
				this.content = "";
			}
			if (this.parent != null)
				this.parent.removeChild(this);
		}

		public function set content(value:String):void
		{
			_body.text = value;
		}

		public function get content():String
		{
			return _body.text;
		}

		public function set bodyColor(value:uint):void
		{
			_textFormat.color = value;
			_body.format = _textFormat;
		}

		public function get bodyColor():uint
		{
			return uint(_textFormat.color);
		}

		public function set bodySize(value:int):void
		{
			_textFormat.size = value;
			_body.format = _textFormat;
		}

		public function get bodySize():int
		{
			return int(_textFormat.size);
		}

		public function get bodyWidth():Number
		{
			return _body.width;
		}

		public function get bodyHeight():Number
		{
			return _body.height;
		}

		public override function setText(orien:int, content:String):void
		{
			direction = orien;
			this.content = content;
		}

		/**
		 *创建飞行文字池对象
		 * @param valueEffect
		 * @param value
		 * @param color
		 * @param size
		 * @param isWeight
		 * @return
		 *
		 */
		public static function createFlyableText(orien:int, content:String, size:int = 20):FlyableText
		{
			return (ScenePool.flyTextPool.createObj(FlyableText, orien, content, "楷体", size) as FlyableText);
		}

		/**
		 *回收
		 * @param flyableText
		 *
		 */
		public static function recycleFlyableText(flyableText:IPoolClient):void
		{
			ScenePool.flyTextPool.disposeObj(flyableText);
		}
	}
}


