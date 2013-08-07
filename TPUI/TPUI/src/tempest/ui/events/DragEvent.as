package tempest.ui.events
{
	import flash.events.Event;

	import tempest.ui.DragManager;
	import tempest.ui.components.TComponent;
	import tempest.ui.components.TDragableImage;
	import tempest.ui.interfaces.IDragable;

	public class DragEvent extends Event
	{
		private var _dragTarget:TComponent;
		private var _dragFrom:IDragable;

		public static const PICK_UP:String = "pickUp";
		public static const DROP_DOWN:String = "dropDown";
		public static const DROP_OUT:String = "dropOut";
		public static const DROP_BACK:String = "dropBack";
		public static const SELECT:String = "select";
		public static const DO_PICK_UP:String = "doPickUp";

		public function DragEvent(type:String, dragFrom:IDragable, dragTarget:TComponent, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);

			_dragFrom = dragFrom;
			_dragTarget = dragTarget;
		}

		public function get dragImageTarget():TDragableImage
		{
			return _dragTarget as TDragableImage;
		}

		public function get dragFromImage():TDragableImage
		{
			return _dragFrom as TDragableImage;
		}

		public function get dragFrom():IDragable
		{
			return _dragFrom;
		}

		public function get dragTarget():TComponent
		{
			return _dragTarget;
		}

		public static function get dragingData():Object
		{
			return DragManager.dragingData;
		}

		override public function clone():Event
		{
			return new DragEvent(type, _dragFrom, _dragTarget, bubbles, cancelable);
		}
	}
}
