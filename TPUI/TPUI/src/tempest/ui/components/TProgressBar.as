package tempest.ui.components
{
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.GTweener;
	import com.gskinner.motion.easing.Sine;
	import com.gskinner.motion.plugins.CurrentFramePlugin;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import tempest.utils.Fun;

	public class TProgressBar extends TComponent
	{
		protected var _mc_value:MovieClip;
		protected var _text:TextField;
		protected var _currentValue:Number;
		protected var _maxValue:Number;
		protected var _strFormat:String;
		protected var _useTween:Boolean = false;
		protected var _makeTextHandler:Function;
		protected var _html:Boolean;
		protected var _autoValidCurrentValue:Boolean = false;

		public function TProgressBar(constraints:Object = null, _proxy:* = null, currentValue:Number = 0, maxValue:Number = 0, /*strFormat:String = "{0}/{1}",*/ useTween:Boolean = true, html:Boolean =
			false, makeTextHandler:Function = null)
		{
			_currentValue = currentValue;
			_maxValue = maxValue;
//			_strFormat = strFormat;
			_useTween = useTween;
			_html = html;
			_makeTextHandler = makeTextHandler;
			super(constraints, _proxy);
			CurrentFramePlugin.install();
		}

		override protected function addChildren():void
		{
			_mc_value = _proxy as MovieClip;
			if(_mc_value)
			{
				if (_proxy.hasOwnProperty("lbl_value"))
				{
					_text = _proxy.lbl_value as TextField;
				}
				makeText();
				this.drawCover(0xFFFFFF, 0); //画一层透明色用于响应mouseOver
			}
		}

		override protected function draw():void
		{
			if(_mc_value)
			{
				var val:int = Math.ceil(_currentValue / _maxValue * (_mc_value.totalFrames - 1) + 1);
				if (_useTween)
				{
					GTweener.to(_mc_value, 0.2, {currentFrame: val});
				}
				else
				{
					_mc_value.gotoAndStop(val);
				}
				makeText();
			}
		}

		protected function makeText():void
		{
			if (_text)
			{
				if (_makeTextHandler != null)
				{
					if (_html)
					{
						_text.htmlText = _makeTextHandler(this);
					}
					else
					{
						_text.text = _makeTextHandler(this);
					}
				}
				else
				{
					var curValue:int = _currentValue >> 0;
					var maxValue:int = _maxValue >> 0;
					curValue = Math.min(curValue, maxValue); //默认的显示容错，让_currentValue不大于maxValue
					if (_html)
					{
						_text.htmlText = curValue + "/" + maxValue;
					}
					else
					{
						_text.text = curValue + "/" + maxValue;
					}
				}
			}
		}

		/**
		 * 制作显示的字符串,
		 * @param value
		 *
		 */
		public function set makeTextHandler(value:Function):void
		{
			_makeTextHandler = value;
		}

		public function set html(value:Boolean):void
		{
			_html = value;
		}

		public function set currentValue(value:Number):void
		{
			if (_autoValidCurrentValue)
			{
				_currentValue = Math.max(Math.min(value, _maxValue), 0); //确定_currentValue的有效范围
			}
			else
			{
				_currentValue = value;
			}
			this.invalidate();
		}

		public function get currentValue():Number
		{
			return _currentValue;
		}

		public function set maxValue(value:Number):void
		{
			if (_autoValidCurrentValue)
			{
				_maxValue = value; //Math.max(value, _currentValue);
				if (_maxValue > _currentValue) //修正_currentValue到有效范围
				{
					_currentValue = _maxValue;
				}
			}
			else
			{
				_maxValue = value;
			}
			this.invalidate();
		}

		public function get maxValue():Number
		{
			return _maxValue;
		}

		public function setTextVisible(value:Boolean):void
		{
			_text.visible = value;
		}

		public function get autoValidCurrentValue():Boolean
		{
			return _autoValidCurrentValue;
		}

		/**
		 * 设置是否自行验证currentValue的值是否有效
		 * 并在currentValue > maxValue 或 currentValue < 0时修正currentValue的值至有效范围
		 */
		public function set autoValidCurrentValue(value:Boolean):void
		{
			_autoValidCurrentValue = value;3
			if (_autoValidCurrentValue)
			{
				_currentValue = Math.max(Math.min(_currentValue, _maxValue), 0);
				this.invalidate();
			}
		}

		/**
		 *是否进度条已满，并且最大值不为0
		 * @return
		 *
		 */
		public function get isFullValue():Boolean
		{
			if (this.maxValue != 0 && maxValue == currentValue)
			{
				return true;
			}
			return false;
		}
	}
}
