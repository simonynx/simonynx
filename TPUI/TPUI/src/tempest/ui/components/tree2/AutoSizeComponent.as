package tempest.ui.components.tree2
{
	import flash.display.DisplayObject;
	import flash.events.Event;

	import tempest.ui.components.TComponent;

	public class AutoSizeComponent extends TComponent
	{
		protected var _proxyAsBackGround:Boolean = true;

		public function AutoSizeComponent(constraints:Object = null, _proxy:* = null)
		{
			super(constraints, _proxy);
		}

		override public function addChild(child:DisplayObject):DisplayObject
		{
			var ret:DisplayObject = super.addChild(child);
			if (ret)
			{
				ret.addEventListener(Event.RESIZE, onChildResize);
				this.measureChildren(_proxyAsBackGround);
			}
			return ret;
		}

		override public function removeChild(child:DisplayObject):DisplayObject
		{
			var ret:DisplayObject = super.removeChild(child);
			if (ret)
			{
				ret.removeEventListener(Event.RESIZE, onChildResize);
				this.measureChildren(_proxyAsBackGround);
			}
			return ret;
		}

		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			var ret:DisplayObject = super.addChildAt(child, index);
			if (ret)
			{
				ret.addEventListener(Event.RESIZE, onChildResize);
				this.measureChildren(_proxyAsBackGround);
			}
			return ret;
		}

		override public function removeChildAt(index:int):DisplayObject
		{
			var ret:DisplayObject = super.removeChildAt(index);
			if (ret)
			{
				ret.removeEventListener(Event.RESIZE, onChildResize);
				this.measureChildren(_proxyAsBackGround);
			}
			return ret;
		}

		private function onChildResize(event:Event):void
		{
			this.measureChildren(_proxyAsBackGround);
		}
	}
}
