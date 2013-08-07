package tempest.engine.graphics.tagger
{
	import com.gskinner.motion.GTweener;
	import com.riaidea.text.RichTextField;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	import tempest.core.IPoolClient;
	import tempest.engine.SceneRender;
	import tempest.utils.Fun;
	import tempest.utils.HtmlUtil;

	public class HeadFace extends Sprite implements IPoolClient
	{
		private var _leftIco:DisplayObject;
		private var _topIco:DisplayObject;
		private static const SPACE:Number = 2;

		/**
		 *
		 * @param nickName
		 * @param nickNameColor
		 * @param customTile
		 * @param leftIco
		 * @param topIco
		 */
		public function HeadFace(nickName:String = "", nickNameColor:uint = 0xFF0000, customTile:String = "", leftIco:DisplayObject = null, topIco:DisplayObject = null)
		{
			super();
			this.mouseChildren = this.mouseEnabled = false;
			this._nickName = nickName;
			this._nickNameColor = nickNameColor;
			this._customTitle = customTile;
			this._leftIco = leftIco;
			this._topIco = topIco;
		}
		//////////////////////////////////////////////////////////////////////////////////////////
		private var _showNickName:Boolean = true;
		private var _showCustomTitle:Boolean = true;
		private var _nickName:String = "";
		private var _nickNameColor:uint = 0xFFFFFF;
		private var _customTitle:String = "";
		private var _updateMain:Boolean = false;
		private var _mainBitmap:Bitmap;
		private var _mainBitmapOffset:Number = 0;

		public function setNickNameVisible(value:Boolean):void
		{
			if (_showNickName != value)
			{
				_showNickName = value;
				this._updateMain = true;
			}
		}

		/**
		 * 获取/设置昵称
		 * @return
		 */
		public function get nickName():String
		{
			return _nickName;
		}

		public function setNickName(nickName:String, nickNameColor:uint):void
		{
			if (this._nickName != nickName)
			{
				this._nickName = nickName;
				this._updateMain = true;
			}
			if (this._nickNameColor != nickNameColor)
			{
				this._nickNameColor = nickNameColor;
				this._updateMain = true;
			}
		}

		public function setCustomTitleVisible(value:Boolean):void
		{
			if (_showCustomTitle != value)
			{
				_showCustomTitle = value;
				this._updateMain = true;
			}
		}

		public function get nickNameColor():uint
		{
			return _nickNameColor;
		}

		public function get customTitle():String
		{
			return _customTitle;
		}

		public function setCustomTitle(value:String, customTitleIcos:Array = null):void
		{
			if (_customTitle != value)
			{
				_customTitle = value;
				this._updateMain = true;
			}
		}

		public function get leftIco():DisplayObject
		{
			return _leftIco;
		}

		public function setLeftIco(value:DisplayObject):void
		{
			if (_leftIco != value)
			{
				_leftIco = value;
				_updateMain = true;
			}
		}

		public function get topIco():DisplayObject
		{
			return _topIco;
		}

		public function setTopIco(value:DisplayObject):void
		{
			if (_topIco != value)
			{
				_topIco = value;
				_updateMain = true;
			}
		}

		private function updateMain():void
		{
			if (!_updateMain)
			{
				return;
			}
			var sp:Sprite = new Sprite();
			var tf_name:TextField;
			var tf_custom:TextField;
			var offset:int = 0;
			var maxWidth:int = 0;
			var bottom:int = 0;
			if (this._showNickName && this._nickName != "")
			{
				tf_name = new TextField();
				tf_name.filters = [new GlowFilter(0x0, 1, 2, 2, 5, BitmapFilterQuality.LOW)];
				tf_name.autoSize = TextFieldAutoSize.CENTER;
				tf_name.multiline = false;
				tf_name.defaultTextFormat = new TextFormat("宋体", 12, _nickNameColor, null, null, null, null, null, TextFormatAlign.CENTER);
				tf_name.text = _nickName;
				bottom += tf_name.height;
				if (tf_name.width > maxWidth)
				{
					maxWidth = tf_name.width;
				}
				sp.addChild(tf_name);
			}
			if (this._showCustomTitle && this._customTitle != "")
			{
				tf_custom = new TextField();
				tf_custom.filters = [new GlowFilter(0x0, 1, 2, 2, 5, BitmapFilterQuality.LOW)];
				tf_custom.autoSize = TextFieldAutoSize.CENTER;
				tf_custom.multiline = true;
				tf_custom.defaultTextFormat = new TextFormat("宋体", 12, null, null, null, null, null, null, TextFormatAlign.CENTER, 0, 0, 0, 5);
				tf_custom.htmlText = _customTitle;
				bottom += tf_custom.height;
				if (tf_custom.width > maxWidth)
				{
					maxWidth = tf_custom.width;
				}
				sp.addChild(tf_custom);
			}
			var topIcoRect:Rectangle;
			if (this._topIco != null)
			{
				topIcoRect = this._topIco.getBounds(this._topIco);
				bottom += topIcoRect.height + SPACE;
				if (topIcoRect.width > maxWidth)
				{
					maxWidth = topIcoRect.width;
				}
				sp.addChild(this._topIco);
			}
			var leftIcoRect:Rectangle;
			if (this._leftIco != null)
			{
				leftIcoRect = this._leftIco.getBounds(this._leftIco);
				sp.addChild(this._leftIco);
				_mainBitmapOffset = leftIcoRect.width + SPACE;
			}
			else
			{
				_mainBitmapOffset = 0;
			}
			if (leftIcoRect)
			{
				var leftOffset:int = 0
				if (tf_name)
				{
					leftOffset = (maxWidth - tf_name.width) * 0.5;
					_mainBitmapOffset -= leftOffset;
					if (_mainBitmapOffset < 0)
					{
						_mainBitmapOffset = 0;
					}
				}
				this._leftIco.x = -leftIcoRect.x;
				this._leftIco.y = -leftIcoRect.y + (bottom - leftIcoRect.height);
			}
			if (tf_name)
			{
				tf_name.x = (maxWidth - tf_name.width) * 0.5 + _mainBitmapOffset;
				tf_name.y = (bottom -= tf_name.height);
			}
			if (tf_custom)
			{
				tf_custom.x = (maxWidth - tf_custom.width) * 0.5 + _mainBitmapOffset;
				tf_custom.y = (bottom -= tf_custom.height);
			}
			if (topIcoRect)
			{
				this._topIco.x = -topIcoRect.x + (maxWidth - topIcoRect.width) * 0.5 + _mainBitmapOffset;
				this._topIco.y = -topIcoRect.y + (bottom -= topIcoRect.height) - SPACE;
			}
			if (sp.numChildren > 0)
			{
				if (_mainBitmap == null)
				{
					_mainBitmap = new Bitmap();
					this.addChild(_mainBitmap);
				}
				if (_mainBitmap.bitmapData)
				{
					_mainBitmap.bitmapData.dispose();
				}
				var bd:Rectangle = sp.getBounds(sp);
				_mainBitmap.bitmapData = new BitmapData(bd.width, bd.height, true, 0);
				_mainBitmap.bitmapData.draw(sp, new Matrix(1, 0, 0, 1, -bd.x, -bd.y));
				_updateLayout = true;
			}
			else
			{
				if (_mainBitmap != null)
				{
					_mainBitmap.bitmapData.dispose();
					if (_mainBitmap.parent)
					{
						_mainBitmap.parent.removeChild(_mainBitmap);
					}
					_mainBitmap = null;
					_updateLayout = true;
				}
			}
			_updateMain = false;
		}
		/************************************************************************************************************************/
		private static const TALKBULLUE_MAX_WIDTH:int = 190; //最大宽度
		private static const TALKBULLUE_MAX_HEIGHT:int = 400; //最大高度
		private static const TALKBULLUE_MIN_WIDTH:int = 100; //最小宽度
		private static const TALKBULLUE_MIN_HEIGHT:int = 24; //最小高度
		private static const TALKBULLUE_SPACE:int = 4; //文字距离背景便宜
		private static const TALKBULLUE_ARROW:int = 10; //箭头边长
		private static const TALKBULLUE_BACK_ALPHA:Number = 0.3; //背景透明度
		private var _updateTalk:Boolean = false;
		private var _talkBitmp:Bitmap;
		private var _talkText:String = "";
		private var _talkSimleys:Array;
		private var _talkTime:uint;
		private var _talkDelay:int = 0;

		public function setTalkText(talkText:String = "", talkSimleys:Array = null, talkDelay:int = 3000):void
		{
			_talkText = talkText;
			_talkSimleys = talkSimleys;
			_talkDelay = talkDelay;
			_talkTime = SceneRender.nowTime;
			_updateTalk = true;
		}

		private var _talkSprite:Sprite;
		private var _talkBitmapValid:Boolean = true;

		private function invalidTalkBitmap():void
		{
			if (!_talkBitmapValid)
			{
				return;
			}
			_talkBitmapValid = false;
			this.addEventListener(Event.ENTER_FRAME, onValidTalkBitmap);
		}

		private function onValidTalkBitmap(event:Event):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			if (_talkBitmapValid)
			{
				return;
			}
			_talkBitmapValid = true;

			validTalkBitmap();
		}

		private function validTalkBitmap():void
		{
			if (_talkSprite)
			{
				if (_talkBitmp == null)
				{
					_talkBitmp = new Bitmap();
					this.addChild(_talkBitmp);
				}
				var bd:Rectangle = _talkSprite.getBounds(_talkSprite);
				_talkBitmp.bitmapData = new BitmapData(bd.width, bd.height, true, 0);
				_talkBitmp.bitmapData.draw(_talkSprite);
			}
			else
			{
				if (_talkBitmp != null)
				{
					_talkBitmp.bitmapData.dispose();
					if (_talkBitmp.parent)
					{
						_talkBitmp.parent.removeChild(_talkBitmp);
					}
					_talkBitmp = null;
				}
			}
			_updateLayout = true;
			updateLayout();
		}

		protected function updateTalk():void
		{
			if (!_updateTalk)
			{
				return;
			}
			if (hasTalkContent())
			{
				_talkSprite = getTalkSprite();
			}
			else
			{
				_talkSprite = null;
			}
			invalidTalkBitmap();
			_updateTalk = false;
		}

		private function hasTalkContent():Boolean
		{
			return _talkText || (_talkSimleys && _talkSimleys.length > 0)
		}

		private function getTalkSprite():Sprite
		{
			var rtf:RichTextField = new RichTextField();
			rtf.html = true;
			rtf.defaultTextFormat = new TextFormat("宋体", 12, 0xFFFFFF, null, null, null, null, null, null, null, null, null, 3);
			rtf.textfield.filters = [new GlowFilter(0x0, 1, 2, 2, 5, BitmapFilterQuality.LOW)];
			rtf.textfield.autoSize = TextFieldAutoSize.LEFT;
			rtf.textfield.mouseWheelEnabled = false;
			rtf.setSize(10000, 20);
			rtf.append(_talkText, _talkSimleys);

			var w:Number = Math.max(Math.min(rtf.textfield.textWidth + TALKBULLUE_SPACE * 2, TALKBULLUE_MAX_WIDTH), TALKBULLUE_MIN_WIDTH);
			rtf.setSize(w - TALKBULLUE_SPACE * 2 + 4, 20); //+4左右边距，防止实际的文本宽度被预期外的缩小
			rtf.setSize(rtf.textfield.width + 4, rtf.textfield.height); //将文本宽高应用于rtf
			var h:Number = Math.max(Math.min(rtf.textfield.height + TALKBULLUE_SPACE * 2, TALKBULLUE_MAX_HEIGHT), TALKBULLUE_MIN_HEIGHT);
			rtf.x = rtf.y = TALKBULLUE_SPACE;

			var sp:Sprite = new Sprite();
			sp.addChild(rtf);

			//画背景框
			sp.graphics.beginFill(0x0, TALKBULLUE_BACK_ALPHA);
			sp.graphics.drawRoundRectComplex(0, 0, w + 4, h, 8, 8, 8, 8);
			//画三角	
			var offset_x:Number = w * 0.5;
			sp.graphics.moveTo(offset_x, h);
			sp.graphics.lineTo(offset_x, h + TALKBULLUE_ARROW);
			sp.graphics.lineTo(offset_x + TALKBULLUE_ARROW, h);
			sp.graphics.lineTo(offset_x, h);
			sp.graphics.endFill();
			return sp;
		}

		private function checkTalk():void
		{
			if (hasTalkContent() && (SceneRender.nowTime - _talkTime) >= _talkDelay)
			{
				this.setTalkText("");
			}
		}
		//////////////////////////////////////////////////////////////////////////////////////
		private static const BAR_WIDTH:Number = 60;
		private static const BAR_HEIGHT:Number = 3;
		private var _showBar:Boolean = false;
		private var _updateBar:Boolean = false;
		private var _barTotal:int = 0;
		private var _barNow:int = 0;
		private var _barBack:Shape;
		private var _bar:Shape;

		public function setBarVisible(value:Boolean):void
		{
			if (_showBar != value)
			{
				_showBar = value;
				if (_barBack)
				{
					_barBack.visible = _showBar;
				}
				if (_bar)
				{
					_bar.visible = _showBar;
				}
				_updateLayout = true;
			}
		}

		public function get barNow():int
		{
			return _barNow;
		}

		public function get barTotal():int
		{
			return _barTotal;
		}

		public function setBar(minValue:int, maxValue:int):void
		{
			if (maxValue <= 0)
			{
				return;
			}
			if (minValue < 0)
			{
				minValue = 0;
			}
			_barNow = minValue;
			_barTotal = maxValue;
			_updateBar = true;
		}

		private function updateBar():void
		{
			if (!_updateBar)
			{
				return;
			}
			if (this._bar == null || this._barBack == null)
			{
				if (this._barBack == null)
				{
					this._barBack = new Shape();
					this._barBack.graphics.beginFill(0, 0.4);
					this._barBack.graphics.drawRoundRectComplex(0, 0, BAR_WIDTH, BAR_HEIGHT, BAR_HEIGHT * 0.5, BAR_HEIGHT * 0.5, BAR_HEIGHT * 0.5, BAR_HEIGHT * 0.5);
					this.addChild(this._barBack);
					this._barBack.visible = _showBar;
				}
				if (this._bar == null)
				{
					this._bar = new Shape();
					this._bar.graphics.beginFill(0xFF0000, 1);
					this._bar.graphics.drawRoundRectComplex(0, 0, BAR_WIDTH, BAR_HEIGHT, BAR_HEIGHT * 0.5, BAR_HEIGHT * 0.5, BAR_HEIGHT * 0.5, BAR_HEIGHT * 0.5);
					this.addChild(this._bar);
					this._bar.visible = _showBar;
				}
				this._updateLayout = true;
			}
			if (_showBar)
			{
				GTweener.to(_bar, 0.3, {scaleX: Math.min(Math.max(0, _barNow / _barTotal), 1)});
			}
			else
			{
				_bar.scaleX = Math.min(Math.max(0, _barNow / _barTotal), 1);
			}
			_updateBar = false;
		}
		//////////////////////////////////////////////////////////////////////////////////////
		private var _updateLayout:Boolean = false;

		private function updateLayout():void
		{
			if (!_updateLayout)
			{
				return;
			}
			var offset:int = 0
			///////////////////////////
			if (this._showBar && this._bar != null && this._barBack != null)
			{
				this._bar.x = this._barBack.x = -BAR_WIDTH * 0.5;
				this._bar.y = this._barBack.y = -BAR_HEIGHT;
				offset = this._bar.y - SPACE;
			}
			if (this._mainBitmap)
			{
				this._mainBitmap.x = -(this._mainBitmap.width - this._mainBitmapOffset) * 0.5 - _mainBitmapOffset;
				this._mainBitmap.y = offset - this._mainBitmap.height;
				offset = this._mainBitmap.y - SPACE;
			}
			if (this._talkBitmp)
			{
				this._talkBitmp.x = -this._talkBitmp.width * 0.5;
				this._talkBitmp.y = offset - this._talkBitmp.height;
				offset = this._talkBitmp.y; // - SPACE;
			}
			//////////////////////////
			_updateLayout = false;
		}

		/////////////////////////////////////////////////////////////////////////////////////////
		public function run(diff:uint):void
		{
			this.checkTalk();
		}

		public function update():void
		{
			this.updateTalk();
			this.updateBar();
			this.updateMain();
			this.updateLayout();
		}

		public function dispose():void
		{
			Fun.removeAllChildren(this, true, true);
		}

		public function reset(args:Array):void
		{
			// TODO Auto Generated method stub
		}

		public static function disposeHeadFace(headFace:HeadFace):void
		{
			if (headFace)
			{
				headFace.dispose();
			}
		}
	}
}
