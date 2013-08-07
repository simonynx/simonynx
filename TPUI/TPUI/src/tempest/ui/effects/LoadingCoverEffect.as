package tempest.ui.effects
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import tempest.ui.components.TLoadingCover;
	import tempest.ui.events.EffectEvent;

	public class LoadingCoverEffect extends BaseEffect
	{
		private var _loadingCover:TLoadingCover;
		private var _parent:DisplayObjectContainer;
		private var _width:Number;
		private var _height:Number;
		private var _xOffset:Number;
		private var _yOffset:Number;

		public function LoadingCoverEffect(target:DisplayObject, width:Number = 0, height:Number = 0, xOffset:Number = 0, yOffset:Number = 0)
		{
			super(target)
			_parent = target as DisplayObjectContainer;
			_width = width;
			_height = height;
			_xOffset = xOffset;
			_yOffset = yOffset;
			this.addEventListener(EffectEvent.START, onStart);
		}

		private function onStart(event:EffectEvent):void
		{
			if (!_loadingCover)
			{
				_loadingCover = new TLoadingCover(_width, _height);
				_loadingCover.x = _xOffset;
				_loadingCover.y = _yOffset;
			}
			if (_loadingCover.parent)
				return;
			_parent.addChild(_loadingCover);
		}

//		override public function play():void
//		{
//			super.play();
//		}
		override public function stop():void
		{
			super.stop();
			if (!_loadingCover)
				return;
			if (!_loadingCover.parent)
				return;
			_parent.removeChild(_loadingCover);
		}

		override public function cancel():void
		{
			super.cancel();
			if (!_loadingCover.parent)
				return;
			_parent.removeChild(_loadingCover);
		}
	}
}
