package tempest.ui.effects
{
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.GTweener;
	import com.gskinner.motion.easing.Elastic;
	import com.gskinner.motion.easing.Sine;
	import com.gskinner.motion.plugins.BlurPlugin;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.geom.Point;

	import tempest.ui.effects.BaseEffect;
	import tempest.ui.events.EffectEvent;

	/**
	 * 弹出效果
	 * @author linxun
	 *
	 */
	public class WindowOpenEffectA extends BaseEffect
	{
		private var _controlFrom:DisplayObject;
		private var _posFrom:Point;
		private var _scaleXFrom:Number = 0.1;
		private var _scaleYFrom:Number = 0.1;
		private var _offset:Point;

		private var _alphaFrom:Number = 0.3;
		private var _alphaTo:Number = 0.6;

		private var _delay:Number;
		private var _model:int = DEFAULT;

		private var _targetSnapshot:Object;

		private static const FROM_CONTROL:int = 1;
		private static const FROM_POS:int = 2;
		private static const DEFAULT:int = 3;


		public function WindowOpenEffectA(delay:Number, target:DisplayObject, controlFrom:DisplayObject = null, offset:Point = null)
		{
			super(target);
			_delay = delay;
			this.addEventListener(EffectEvent.START, onStart);
			this.addEventListener(EffectEvent.END, onEnd);
			this.controlFrom = controlFrom;
			_offset = offset;
			_posFrom = new Point();
		}

		public function set controlFrom(value:DisplayObject):void
		{
			_controlFrom = value;
			if (_controlFrom)
			{
				_model = FROM_CONTROL;
			}
		}

		public function set targetSnapshot(value:Object):void
		{
			_targetSnapshot = value;
		}

		public function setFromPos(x:Number, y:Number):void
		{
			_posFrom.x = x;
			_posFrom.y = y;
			_model = FROM_POS;
		}

		public function set alphaTo(value:Number):void
		{
			_alphaTo = value;
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
		private function getPosFrom():Point
		{
			switch (_model)
			{
				case FROM_CONTROL:
					if (_controlFrom)
					{
						var _controlPos:Point = _controlFrom.localToGlobal(new Point(_controlFrom.width / 2, _controlFrom.height / 2));
						_posFrom.x = _offset ? _controlPos.x + _offset.x : _controlPos.x;
						_posFrom.y = _offset ? _controlPos.y + _offset.y : _controlPos.y;
					}
					break;
				case FROM_POS:
					break;
				case DEFAULT:
					//设置默认位置
					_posFrom.x = _targetSnapshot.x + _targetSnapshot.width / 2;
					_posFrom.y = _targetSnapshot.y + _targetSnapshot.height / 2;
					break;
				default:
					//设置默认位置
					_posFrom.x = _targetSnapshot.x + _targetSnapshot.width / 2;
					_posFrom.y = _targetSnapshot.y + _targetSnapshot.height / 2;
					break;
			}

			return _posFrom;
		}

		private var _targetMouseEnabled:Boolean = true;
		private var _targetMouseChildren:Boolean = true;

		private function onStart(event:Event):void
		{
//			if (_target is InteractiveObject)
//			{
//				var it:InteractiveObject = _target as InteractiveObject;
//				_targetMouseEnabled = it.mouseEnabled;
//				it.mouseEnabled = false;
//			}
//			if (_target is DisplayObjectContainer)
//			{
//				var ic:DisplayObjectContainer = _target as DisplayObjectContainer;
//				_targetMouseChildren = ic.mouseChildren;
//				ic.mouseChildren = false;
//			}
			var scaleXTo:Number = 1;
			var scaleYTo:Number = 1;

			var posFrom:Point = getPosFrom();
			var posTo:Point = new Point(_targetSnapshot.x, _targetSnapshot.y);

			_target.alpha = 0; //隐藏窗口

			var bitmap:Bitmap = _targetSnapshot.bitmap;
			GTweener.removeTweens(bitmap);
			_target.parent.addChild(bitmap);
			bitmap.x = posFrom.x;
			bitmap.y = posFrom.y;
			bitmap.scaleX = _scaleXFrom;
			bitmap.scaleY = _scaleYFrom;
			bitmap.alpha = _alphaFrom;
			GTweener.removeTweens(_target);
			BlurPlugin.install();
			BlurPlugin.enabled = true;
			GTweener.to(bitmap, _delay, {x: posTo.x, y: posTo.y, scaleX: scaleXTo, scaleY: scaleYTo, blurX: 2, blurY: 2, alpha: _alphaTo}, {useFrames: true, ease: Sine.easeOut}).onComplete = function(gTween:GTween):void
			{
				stop();
				if (bitmap.parent)
				{
					bitmap.parent.removeChild(bitmap);
				}
				_target.alpha = 1; //显示窗口
			};
		}

		private function onEnd(event:Event):void
		{
//			if (_target is InteractiveObject)
//			{
//				var it:InteractiveObject = _target as InteractiveObject;
//				it.mouseEnabled = _targetMouseEnabled;
//			}
//			if (_target is DisplayObjectContainer)
//			{
//				var ic:DisplayObjectContainer = _target as DisplayObjectContainer;
//				ic.mouseChildren = _targetMouseChildren;
//			}
		}
	}

}
