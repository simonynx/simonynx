package fj1.modules.formation.view.components
{
	import fj1.common.staticdata.DragImagePlaces;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import tempest.common.staticdata.MouseOperatePriority;
	import tempest.common.staticdata.MouseOperatorType;
	import tempest.ui.DragManager;
	import tempest.ui.components.TComponent;
	import tempest.ui.components.TDragableImage;
	import tempest.ui.events.DragEvent;
	import tempest.ui.interfaces.IDragable;

	public class FormationDragView extends TComponent implements IDragable
	{
		private var _dropBackAreaArray:Array; //拖放放下后，会自动回到原处的范围，范围内不会触发DragEvent.DROP_OUT事件
		private var _dropOutTarget:InteractiveObject;
		private var _pickUpEnable:Boolean = true; //是否开启拾取
		private var _place:int; //标记图片所在的逻辑地点，方便逻辑判断
		private var _bePickedUp:Boolean;

		public function FormationDragView(_proxy:*)
		{
			_proxy.mouseEnabled = _proxy.mouseChildren = false;
			this.place = DragImagePlaces.FORMATION;
			DragManager.dragable(this);
//			DragManager.dropable(this);
			this.fetchEnable = true;
		}

		public function get dropOutTarget():InteractiveObject
		{
			return _dropOutTarget;
		}

		public function set dropOutTarget(value:InteractiveObject):void
		{
			_dropOutTarget = value;
		}

		public function get pickUpEnable():Boolean
		{
			return _pickUpEnable;
		}

		public function set pickUpEnable(value:Boolean):void
		{
			if (value)
			{
				DragManager.dragable(this);
			}
			else
			{
				DragManager.unDragable(this);
			}
			_pickUpEnable = value;
		}

		public function get bePickedUp():Boolean
		{
			return _bePickedUp;
		}

		public function set bePickedUp(value:Boolean):void
		{
			_bePickedUp = value;
		}

		/**
		 * 标记图片所在的逻辑地点，方便逻辑判断
		 * @return
		 *
		 */
		public function get place():int
		{
			return _place;
		}

		public function set place(value:int):void
		{
			_place = value;
		}

		public static function get dragImageFrom():TDragableImage
		{
			return DragManager.dragFrom as TDragableImage;
		}

		/**
		 * 拾起图片
		 *
		 */
		public function pickUp(fromParams:Object = null, selectedSet:Boolean = true):void
		{
			DragManager.pickUp(this, fromParams, selectedSet, data);
		}

		/**
		 * 取消拖放
		 *
		 */
		public function cancelDrag():void
		{
			DragManager.cancelDrag();
		}

		/**
		 * 放下并拾起图片
		 * @param event
		 * @return 重新拾起前，拖动中的数据对象
		 *
		 */
		public function dropAndPick(event:DragEvent):Object
		{
			var dragingData:Object = DragManager.dragingData; //预先缓存dragingData，避免pickUp后被修改
			if (event.dragImageTarget.data)
			{
				DragManager.cancelDrag();
				event.dragImageTarget.pickUp(null, false);
				event.preventDefault();
			}
			return dragingData;
		}

		/**
		 * 丢弃图片，触发丢弃事件DragEvent.DROP_OUT
		 *
		 */
		public function dropOut():void
		{
			DragManager.dropOut();
		}

		/**
		 * 拖放放下后，会自动回到原处的范围，范围内不会触发DragEvent.DROP_OUT事件
		 * @param value
		 *
		 */
		public function set dropBackAreaArray(value:Array):void
		{
			_dropBackAreaArray = value;
		}

		public function get dropBackAreaArray():Array
		{
			return _dropBackAreaArray;
		}

		public function get type():int
		{
			return MouseOperatorType.DRAG;
		}

		public function cancelOperate():void
		{
			this.cancelDrag();
		}

		public function get priority():int
		{
			return MouseOperatePriority.DRAG_DROP;
		}

		public function isEmpty():Boolean
		{
			// TODO Auto Generated method stub
			return false;
		}

		public function set setMouseSkinHandler(value:Function):void
		{
			_setMouseSkinHandler = value;
		}

		public function get setMouseSkinHandler():Function
		{
			return _setMouseSkinHandler;
		}
		private var _setMouseSkinHandler:Function;
	}
}
