package tempest.ui.components.tips
{
	import com.riaidea.text.RichTextField;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.StyleSheet;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getTimer;

	import tempest.ui.StyleSheetManager;
	import tempest.ui.UIStyle;
	import tempest.ui.components.TImage;
	import tempest.ui.interfaces.IRichTextTipClient;

	public class TRichTextToolTip extends TToolTip
	{
		protected var _maxTipWidth:Number;
		protected var _tipStyleSheet:StyleSheet;
		protected var _xPading:Number = 8;
		protected var _yPading:Number = 8;
		
		private var richTextField:RichTextField;
		//图片
		private var _iconImage:DisplayObject;

		public function TRichTextToolTip(_proxy:* = null, mouseFollow:Boolean = false, yOffset:Number = 0, xOffset:Number = 0, maxTipWidth:Number = 100, tipStyleSheet:StyleSheet = null)
		{
			_maxTipWidth = maxTipWidth;
			_tipStyleSheet = tipStyleSheet;
			super(_proxy, mouseFollow, yOffset, xOffset);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}

		override protected function addChildren():void
		{
			super.addChildren();
			richTextField = new RichTextField();
			richTextField.textfield.mouseEnabled = false;
			richTextField.mouseEnabled = false;
			richTextField.html = true;
			richTextField.textfield.autoSize = TextFieldAutoSize.LEFT;
			richTextField.x = _xPading;
			richTextField.y = _yPading;

			this.setProxySize(_maxTipWidth, this.height);
		}

		private function del():void
		{
			for (var i:int = 0; i < this.numChildren; i++)
			{
				this.removeChildAt(i);
				i--;
			}

		}

		public function get iconImage():DisplayObject
		{
			return _iconImage;
		}

		override public function set data(value:Object):void
		{
			
			super.data = value;
			clean();
			if (!value)
			{
				return;
			}
			if (value is IRichTextTipClient)
			{
				//设置图片（缓存引用）
				var tipClient:IRichTextTipClient = IRichTextTipClient(value);
				var tipDataArray:Array = tipClient.getTipDataArray(showParams);
				var tipDataItem:Object;
				//图片
				_iconImage = tipClient.getIconImage();
				var text:String = "";
				for each (tipDataItem in tipDataArray)
				{
					if (tipDataItem != null)
					{
						if (!tipDataItem.newSprites)
						{
							text = text.concat(tipDataItem.text);
						}
						else
						{
							richTextField.append(text);
							richTextField.append(tipDataItem.text, tipDataItem.newSprites);
							text = "";
						}
					}
				}
				richTextField.append(text);
				
//				var spArray:Array = [];
//				for each (tipDataItem in tipDataArray)
//				{
//					text = text.concat(tipDataItem.text);
//					
//					if(tipDataItem.newSprites && tipDataItem.newSprites.length > 0)
//					{
//						var purText:String = text.replace(/<.*?>/g, function():String
//						{
//							if (arguments[0] == "<br>")
//								return "\n";
//							else if (arguments[0] == "</p>")
//								return "\n";
//							else
//								return "";
//						})
//						for each(var spConfig:Object in tipDataItem.newSprites)
//						{
//							spConfig.index += purText.length - 1;
//							spArray.push(spConfig);
//						}
//					}
//				}
//				richTextField.append(text, spArray);
				
				/******************************************************************************/
				
				if (_iconImage)
				{
					_iconImage.x = 17;
					_iconImage.y = 35;
					this.addChild(_iconImage);
				}
				this.addChild(richTextField);
				richTextField.setSize(tipClient.getTipWidth(), richTextField.textfield.height);
//				richTextField.addEventListener(Event.ENTER_FRAME, onDelayMeasureChildren);
				this.measureChildren();
			}
			else
			{
				richTextField.append(value as String);
				this.addChild(richTextField);
				richTextField.setSize(richTextField.textfield.width, richTextField.textfield.height);
				this.measureChildren();
			}
			
		}

		private function clean():void
		{
			if (_delayCount != 0)
			{
				_delayCount = 0;
			}
			richTextField.clear();
//			richTextField.removeEventListener(Event.ENTER_FRAME, onDelayMeasureChildren);
			this.measureChildren();
			if (_iconImage && _iconImage.parent)
			{
				this.removeChild(_iconImage);
				_iconImage = null;
			}
		}

		private var _delayCount:int = 0;

		private function onDelayMeasureChildren(e:Event):void
		{
			if (_delayCount < 1)
			{
				++_delayCount;
				return;
			}
			_delayCount = 0;
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			this.measureChildren();
		}
		
		private function onRemoveFromStage(event:Event):void
		{
			var toolTipClient:IRichTextTipClient = this.data as IRichTextTipClient;
			if(!toolTipClient)
			{
				return;
			}
			toolTipClient.onTipHide(this);
			clean();
		}

		override public function measureChildren(proxyAsBackGround:Boolean = false, setSize:Boolean = true):Point
		{
			var size:Point = super.measureChildren(true, false);
			this.setProxySize(size.x + _xPading, size.y + _yPading);
			var ret:Point = super.measureChildren(false, true);
			return ret;
		}

		public function set styleSheet(value:int):void
		{
			this.styleSheet = value;
			this.measureChildren();
//			this.setProxySize(this.width + _xPading, this.height + _yPading);
		}
	}
}
