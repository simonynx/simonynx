package fj1.common.ui.animation
{

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;

	import mx.logging.AbstractTarget;

	import tempest.engine.graphics.moivce.BitmapFrameInfo;

	/**
	 * 位图动画类
	 * 支持设置帧率控制器让多个动画同步播放
	 * 需要
	 * @author linxun
	 *
	 */
	public class BitmapAnimation extends Sprite
	{
		private var _frameCtrl:IAnimationFrameController;
		private var _res:IBitmapAnimationRes;

		private var _playing:Boolean;
		private var _currentFrame:int;

		private var bitmap:Bitmap;

		/**
		 * 位图动画类
		 * 支持设置帧率控制器让多个动画同步播放
		 * @param res 资源对象
		 * @param frameCtrl 帧率控制器
		 *
		 */
		public function BitmapAnimation(res:IBitmapAnimationRes, frameCtrl:IAnimationFrameController = null)
		{
			super();
			bitmap = new Bitmap();
			this.addChild(bitmap);
			_frameCtrl = frameCtrl ? frameCtrl : new AnimationFrameController(30);
			reset(res);
		}

		public function reset(res:IBitmapAnimationRes):void
		{
			_res = res;
			if (_playing && _res.totalFrames <= 1) //一帧的动画不处理播放
			{
				_frameCtrl.removeFrameListener(onUpdate);
			}

			onUpdate(_frameCtrl.tick);
			this.filters = _res.filters;
		}

		public function play():void
		{
			if (!_playing)
			{
				_playing = true;
				if (_res.totalFrames > 1)
				{
					_frameCtrl.addFrameListener(onUpdate);
				}
			}
		}

		public function stop():void
		{
			if (_playing)
			{
				_playing = false;
				if (_res.totalFrames > 1)
				{
					_frameCtrl.removeFrameListener(onUpdate);
				}
			}
		}

		public function get playing():Boolean
		{
			return _playing;
		}

		public function get currentFrame():int
		{
			return _currentFrame;
		}

		public function get totalFrames():int
		{
			return _res.totalFrames;
		}

		private function onUpdate(tick:int):void
		{
			_currentFrame = tick % _res.totalFrames + 1;
			var fInfo:BitmapFrameInfo = _res.getBitmapData(_currentFrame);
			bitmap.bitmapData = fInfo.bitmapData;
			bitmap.x = fInfo.x;
			bitmap.y = fInfo.y;
		}
	}
}
