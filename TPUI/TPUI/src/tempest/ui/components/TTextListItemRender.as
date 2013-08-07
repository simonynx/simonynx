package tempest.ui.components
{
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.describeType;

	import tempest.ui.UIStyle;
	import tempest.ui.components.textFields.TText;

	public class TTextListItemRender extends TListItemRender
	{
//		public var text:TextField;
		//---------------------------------------------
		protected var _text:TText;
		protected var txtFormat:TextFormat = new TextFormat(UIStyle.fontName, UIStyle.fontSize, UIStyle.NORMAL_TEXT);
		private var _nameProperty:String = "name";
		protected var _autoMeansure:Boolean = true;

		public function TTextListItemRender(_proxy:* = null, data:Object = null)
		{
			super(_proxy, data);
		}

		override protected function addChildren():void
		{
			super.addChildren();
			if (_proxy && _proxy.hasOwnProperty("text"))
			{
				_text = new TText(null, _proxy.text, "", TextFieldAutoSize.LEFT);
			}
			else
			{
				_text = new TText(null, null, "", TextFieldAutoSize.LEFT);
				_text.format = txtFormat;
			}
			_text.editable = false;
			_text.selectable = false;
			this.addChild(_text);
			if (_autoMeansure)
			{
				this.measureChildren();
			}
		}

		public function get textField():TText
		{
			return _text;
		}

		public function set nameProperty(value:String):void
		{
			_nameProperty = value;
		}

		/**
		 *
		 * @param value 通过toString()函数来获得文本
		 *
		 */
		override public function set data(value:Object):void
		{
			super.data = value;
			if (value is String)
			{
				_text.text = String(data);
			}
			else if (_nameProperty)
			{
				_text.text = data == null ? "" : data[_nameProperty];
			}
			if (_autoMeansure)
			{
				this.measureChildren();
			}
		}

		/**
		 *
		 * @param value
		 *
		 */
		override public function set width(value:Number):void
		{
			_text.width = value;
//			if (_text.multiline)
//			{
			//宽度设置有效
			this.measureChildren();
//			}
//			else
//			{
//				//宽度设置无效
//				if (_bkMovieClip)
//					_bkMovieClip.width = value;
//				this.measureChildren(false);
//				_width = value;
//				super.width = value;
//
//			}

		}

		public function get tText():TText
		{
			return _text;
		}
	}
}
