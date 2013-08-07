package tempest.ui.effects
{
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.GTweener;
	import com.gskinner.motion.easing.Sine;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;

	import spark.effects.easing.EaseInOutBase;
	import spark.effects.easing.EasingFraction;

	import tempest.ui.effects.BaseEffect;
	import tempest.ui.events.EffectEvent;

	/**
	 * 收起效果
	 * @author linxun
	 *
	 */
	public class WindowCloseEffectA extends BaseEffect
	{
		private var _posTo:Point;
		private var _controlTo:DisplayObject;
		private var _scaleXTo:Number = 0.1;
		private var _scaleYTo:Number = 0.1;
		private var _offset:Point;

		private var _alphaFrom:Number = 0.3;
		private var _alphaTo:Number = 0;

		private var _delay:Number;
		private var _model:int = DEFAULT;

		private var _targetSnapshot:Object;

		private static const TO_CONTROL:int = 1;
		private static const TO_POS:int = 2;
		private static const DEFAULT:int = 3;


		public function WindowCloseEffectA(delay:Number, target:DisplayObject, controlTo:DisplayObject, offset:Point = null)
		{
			super(target);
			_delay = delay;

			this.addEventListener(EffectEvent.START, onStart);
			this.controlTo = controlTo;
			_offset = offset;
			_posTo = new Point();
		}

		override public function get playing():Boolean
		{
			return super.playing;
		}

		public function set scaleXTo(value:Number):void
		{
			_scaleXTo = value;
		}

		public function set scaleYTo(value:Number):void
		{
			_scaleYTo = value;
		}

		public function set alphaFrom(value:Number):void
		{
			_alphaFrom = value;
		}

		public function set alphaTo(value:Number):void
		{
			_alphaTo = value;
		}

		public function set controlTo(value:DisplayObject):void
		{
			_controlTo = value;
			if (_controlTo)
			{
				_model = TO_CONTROL;
			}
		}

		public function setToPos(x:Number, y:Number):void
		{
			_posTo.x = x;
			_posTo.y = y;
			_model = TO_POS;
		}

		public function set targetSnapshot(value:Object):void
		{
			_targetSnapshot = value;
		}

		override public function reset():void
		{

		}

		override public function cancel():void
		{
			GTweener.removeTweens(_targetSnapshot.bitmap);
			super.cancel();
		}

		/**
		 * 获取起始位置
		 * @return
		 *
		 */
		private function getPosTo():Point
		{
			switch (_model)
			{
				case TO_CONTROL:
					if (_controlTo)
					{
						var control:Point = _controlTo.localToGlobal(new Point(_controlTo.width / 2, _controlTo.height / 2));
						_posTo.x = _offset ? control.x + _offset.x : control.x;
						_posTo.y = _offset ? control.y + _offset.y : control.y;
					}
					break;
				case TO_POS:
					break;
				case DEFAULT:
					//设置默认位置
					_posTo.x = _targetSnapshot.x + _targetSnapshot.width / 2;
					_posTo.y = _targetSnapshot.y + _targetSnapshot.height / 2;
					break;
				default:
					//设置默认位置
					_posTo.x = _targetSnapshot.x + _targetSnapshot.width / 2;
					_posTo.y = _targetSnapshot.y + _targetSnapshot.height / 2;
					break;
			}

			return _posTo;
		}

		private function onStart(event:Event):void
		{
			var _scaleXFrom:Number = 1;
			var _scaleYFrom:Number = 1;
			//设置收起后位置
			var posTo:Point = getPosTo();

			_target.alpha = 0; //隐藏窗口

			var bitmap:Bitmap = _targetSnapshot.bitmap;
			bitmap.alpha = _alphaFrom;
			_target.parent.addChild(bitmap);
			GTweener.removeTweens(bitmap);
			GTweener.to(bitmap, _delay, {x: posTo.x, y: posTo.y, scaleX: _scaleXTo, scaleY: _scaleYTo, alpha: _alphaTo}, {useFrames: true, ease: Sine.easeIn}).onComplete = function(gTween:GTween):void
			{
				stop();

//				//关闭后，设置宽高位置到原始值
//				_target.scaleX = _scaleXFrom;
//				_target.scaleY = _scaleYFrom;
//				_target.x = _targetSnapshot.x;
//				_target.y = _targetSnapshot.y;

				if (bitmap.parent)
				{
					bitmap.parent.removeChild(bitmap);
				}
				_target.alpha = 1; //显示窗口
			};
		}
	}
}
