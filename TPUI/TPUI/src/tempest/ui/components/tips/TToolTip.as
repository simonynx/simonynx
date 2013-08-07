package tempest.ui.components.tips
{
	import flash.display.DisplayObject;
	import flash.events.Event;

	import tempest.ui.components.TPanel;
	import tempest.ui.events.TComponentEvent;

	public class TToolTip extends TPanel
	{
		protected var _mouseFollow:Boolean;

		protected var _yOffset:Number;
		protected var _xOffset:Number;
		private var _shower:DisplayObject;
		protected var _showParams:Object;

		public function TToolTip(_proxy:* = null, mouseFollow:Boolean = false, yOffset:Number = 4, xOffset:Number = 0)
		{
			super(null, _proxy);

			this._mouseFollow = mouseFollow;
			this._yOffset = yOffset;
			this._xOffset = xOffset;

			this.mouseChildren = this.mouseEnabled = false;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

		private function onAddedToStage(event:Event):void
		{
			if (_shower)
			{
				_shower.addEventListener(Event.REMOVED_FROM_STAGE, onShowerRemoveFromStage);
			}
		}

		private function onRemovedFromStage(event:Event):void
		{
			if (_shower)
			{
				_shower.removeEventListener(Event.REMOVED_FROM_STAGE, onShowerRemoveFromStage);
			}
		}

		private function onShowerRemoveFromStage(event:Event):void
		{
			this.dispatchEvent(new Event("ShowerHide"));
		}

		public function get shower():DisplayObject
		{
			return _shower;
		}

		public function set shower(value:DisplayObject):void
		{
			_shower = value;
		}

		public function get showParams():Object
		{
			return _showParams;
		}

		public function set showParams(value:Object):void
		{
			_showParams = value;
		}

		override protected function init():void
		{
//			if(!_proxy)
//			{
//				this._width = 100;
//			}

			super.init();
		}

		public function get mouseFollow():Boolean
		{
			return _mouseFollow;
		}

		public function get yOffset():Number
		{
			return _yOffset;
		}

		public function get xOffset():Number
		{
			return _xOffset;
		}
	}
}
