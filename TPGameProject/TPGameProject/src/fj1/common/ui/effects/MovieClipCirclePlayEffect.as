package fj1.common.ui.effects
{
	import com.gskinner.motion.GTweener;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * 循环播放影片剪辑到某帧停止
	 * @author linxun
	 *
	 */
	public class MovieClipCirclePlayEffect
	{
		private var _targetFrame:int;
		private var _target:MovieClip;
		private var _playing:Boolean;
		private var _onComplete:Function;

		public var data:Object;

		public function MovieClipCirclePlayEffect(target:MovieClip, onComplete:Function):void
		{
			_targetFrame = 1;
			_target = target;
			_target.stop();
			_onComplete = onComplete;
		}

		private function onEnterFrame(event:Event):void
		{
			if (_targetFrame == _target.currentFrame)
			{
				_playing = false;
				_target.stop();
				_target.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				_onComplete(this);
			}
		}

		public function play(targetFrame:int):void
		{
			if (_targetFrame == targetFrame)
			{
				return;
			}
			if (!_playing)
			{
				_playing = true;
				_target.play();
				_target.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			_targetFrame = targetFrame;
		}

		public function stop(targetFrame:int):void
		{
			_targetFrame = targetFrame;
			_target.gotoAndStop(targetFrame);
			_target.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
	}
}
