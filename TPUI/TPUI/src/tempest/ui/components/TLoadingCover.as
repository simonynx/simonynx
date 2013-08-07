package tempest.ui.components
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;

	import tempest.ui.UIStyle;

	public class TLoadingCover extends Sprite
	{
		private var _centerSprite:DisplayObject;

		private var _width:Number;
		private var _height:Number;

		public function TLoadingCover(width:Number = 0, height:Number = 0)
		{
			_width = width;
			_height = height;


			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

			if (_width != 0 && _height != 0)
			{
				_centerSprite = new UIStyle.loading();

				this.graphics.clear();
				this.graphics.beginFill(0x000000, 0.3);
				if (_centerSprite.width > _width)
					_centerSprite.width = _width;
				if (_centerSprite.height > _height)
					_centerSprite.height = _height;
				this.graphics.drawRect(0, 0, _width, _height);
				this.graphics.endFill();
				_centerSprite.x = (_width - _centerSprite.width) * 0.5;
				_centerSprite.y = (_height - _centerSprite.height) * 0.5;

				this.addChild(_centerSprite);
			}

		}

		private function onAddedToStage(event:Event):void
		{
			if (_width == 0 && _height == 0)
			{
				_centerSprite = new UIStyle.loading();

				this.graphics.clear();
				this.graphics.beginFill(0x000000, 0.3);
				if (_centerSprite.width > parent.width)
					_centerSprite.width = parent.width;
				if (_centerSprite.height > parent.height)
					_centerSprite.height = parent.height;
				this.graphics.drawRect(0, 0, parent.width, parent.height);
				this.graphics.endFill();
				_centerSprite.x = (parent.width - _centerSprite.width) * 0.5;
				_centerSprite.y = (parent.height - _centerSprite.height) * 0.5;

				this.addChild(_centerSprite);
			}
			if (_centerSprite is MovieClip)
			{
				MovieClip(_centerSprite).play();
			}
		}

		private function onRemovedFromStage(event:Event):void
		{
			if (_centerSprite is MovieClip)
			{
				MovieClip(_centerSprite).stop();
			}
		}

		public function set centerSprite(value:DisplayObject):void
		{
			if (_centerSprite)
				this.removeChild(_centerSprite);
			_centerSprite = value;

			_centerSprite.x = (_width - _centerSprite.width) * 0.5;
			_centerSprite.y = (_height - _centerSprite.height) * 0.5;
			this.addChild(_centerSprite);
		}
	}
}
