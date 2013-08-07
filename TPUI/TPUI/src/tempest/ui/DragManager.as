package tempest.ui
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;

	import tempest.common.staticdata.CursorPriority;
	import tempest.ui.components.TComponent;
	import tempest.ui.components.TDragableImage;
	import tempest.ui.events.DragEvent;
	import tempest.ui.interfaces.IDragable;
	import tempest.ui.interfaces.IMouseOperator;

	public class DragManager
	{
		private static var _fromParams:Object;
		private static var _dragComponentFrom:IDragable;
		private static var _dragingData:Object;
		private static var _dragSprite:Sprite;
		private static var _eventDispatcher:EventDispatcher;

		/**
		 * 是否有图片正被拾起
		 * @return
		 *
		 */
		public static function isDraging():Boolean
		{
			return _dragingData ? true : false;
		}

		public static function get dragingData():Object
		{
			return _dragingData; //_dragImageFrom ? _dragImageFrom.data : null;
		}

		public static function get fromParams():Object
		{
			return _fromParams;
		}

		public static function get eventDispatcher():EventDispatcher
		{
			if (!_eventDispatcher)
			{
				_eventDispatcher = new EventDispatcher(null);
			}
			return _eventDispatcher;
		}

		/**
		 * 当前被拾起的图片
		 * @return
		 *
		 */
		public static function get dragFrom():IDragable
		{
			return _dragComponentFrom;
		}

		public static function dragable(component:IDragable):void
		{
			component.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			component.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}

		public static function unDragable(component:IDragable):void
		{
			component.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			component.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}

		public static function dropable(component:TComponent):void
		{
			component.addEventListener(MouseEvent.CLICK, onDragDrop);
		}

		public static function unDropable(component:TComponent):void
		{
			component.removeEventListener(MouseEvent.CLICK, onDragDrop);
		}

		/**
		 * 监听掉落
		 * @param event
		 *
		 */
		private static function onDragDrop(event:MouseEvent):void
		{
			DragManager.processDragDrop(TComponent(event.currentTarget));
		}

		private static function onMouseDown(event:MouseEvent):void
		{
			if (FetchHelper.instance.isFetching) //提取状态下不响应拾起
				return;
			var component:IDragable = event.currentTarget as IDragable;
			if (!component.hasEventListener(MouseEvent.MOUSE_MOVE))
				component.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			if (!component.hasEventListener(MouseEvent.ROLL_OUT))
				component.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
		}

		private static function onMouseUp(event:MouseEvent):void
		{
			var component:IDragable = event.currentTarget as IDragable;
			if (component.hasEventListener(MouseEvent.MOUSE_MOVE))
				component.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			if (component.hasEventListener(MouseEvent.ROLL_OUT))
				component.removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
		}

		private static function onMouseMove(event:MouseEvent):void
		{
			var component:IDragable = event.currentTarget as IDragable;
			component.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			component.removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
//			if (!_dragComponentFrom)
//			{
			//拿起流程
			if (component.isEmpty())
			{
				return;
			}
			component.addEventListener(DragEvent.PICK_UP, onDefaultPickUp, false, -50);
			component.dispatchEvent(new DragEvent(DragEvent.PICK_UP, component, null, false, true));
//			}
		}

		private static function onRollOut(event:MouseEvent):void
		{
			var component:IDragable = event.currentTarget as IDragable;
			component.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			component.removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
			if (!_dragComponentFrom)
			{
				//拿起流程
				if (component.isEmpty())
				{
					return;
				}
				component.addEventListener(DragEvent.PICK_UP, onDefaultPickUp, false, -50);
				component.dispatchEvent(new DragEvent(DragEvent.PICK_UP, component, null, false, true));
			}
		}

		/**
		 *
		 * @param event
		 *
		 */
		private static function onDefaultPickUp(event:DragEvent):void
		{
			var component:IDragable = event.currentTarget as IDragable;
			component.removeEventListener(DragEvent.PICK_UP, onDefaultPickUp);
			if (event.isDefaultPrevented())
			{
				return;
			}
			pickUp(component);
		}

		/**
		 * 拾起图片
		 *
		 */
		public static function pickUp(dragComponent:IDragable, fromParams:Object = null, selectedSet:Boolean = true, pickUpData:Object = null):void
		{
			var component:IDragable = dragComponent as IDragable;
			//设置拾起操作，设置失败则返回
			if (!MouseStateHolder.instance.setOperater(dragComponent, component.data))
				return;
			//设置鼠标图片
			if (component.setMouseSkinHandler != null)
			{
				component.setMouseSkinHandler();
			}
			if (selectedSet)
			{
				setSelected(component, true);
			}
			setDraging(component, true, pickUpData);
			_fromParams = fromParams;
			removeDropOutListerner(component);
			addDropOutListerner(component);
			component.dispatchEvent(new DragEvent(DragEvent.DO_PICK_UP, component, null));
			eventDispatcher.dispatchEvent(new DragEvent(DragEvent.DO_PICK_UP, component, null));
		}

		public static function setDraging(component:IDragable, value:Boolean, pickUpData:Object):void
		{
			if (value)
			{
				_dragComponentFrom = component;
				_dragingData = pickUpData ? pickUpData : _dragComponentFrom.data;
			}
			else
			{
				_dragComponentFrom = null;
				_fromParams = null;
				_dragingData = null;
			}
		}

		/**
		 * 移除DropOut监听
		 *
		 */
		public static function removeDropOutListerner(component:IDragable):void
		{
			component.removeEventListener(Event.ENTER_FRAME, onDelayAddStageDropOut);
			dropOutTarget.removeEventListener(MouseEvent.MOUSE_DOWN, onStageDropOut);
		}
		public static var dropOutTarget:InteractiveObject;

		private static function onStageDropOut(event:MouseEvent):void
		{
			if (!_dragComponentFrom)
			{
				return;
			}
			//点在其他地方
			removeDropOutListerner(_dragComponentFrom);
			if (dropOutTarget && event.target == dropOutTarget)
			{
				//点到范围外
				_dragComponentFrom.addEventListener(DragEvent.DROP_OUT, onDefaultDropOut, false, -50);
				_dragComponentFrom.dispatchEvent(new DragEvent(DragEvent.DROP_OUT, _dragComponentFrom, null, false, true));
			}
			else
			{
				var dropBack:Boolean = false;
				if (_dragComponentFrom.dropBackAreaArray)
				{
					//如果有设置掉回范围，那么在掉回范围外的区域都触发DROP_OUT
					for each (var dropBackTarget:DisplayObject in _dragComponentFrom.dropBackAreaArray)
					{
						if (inParent(event.target as DisplayObject, dropBackTarget))
						{
							dropBack = true;
							break;
						}
					}
				}
				else
				{
					dropBack = true;
				}
				if (dropBack)
				{
					//点在范围内
					_dragComponentFrom.addEventListener(DragEvent.DROP_BACK, onDefaultDropBack, false, -50);
					_dragComponentFrom.dispatchEvent(new DragEvent(DragEvent.DROP_BACK, _dragComponentFrom, null, false, true));
				}
				else
				{
					//点到范围外
					_dragComponentFrom.addEventListener(DragEvent.DROP_OUT, onDefaultDropOut, false, -50);
					_dragComponentFrom.dispatchEvent(new DragEvent(DragEvent.DROP_OUT, _dragComponentFrom, null, false, true));
				}
			}
		}

		private static function inParent(child:DisplayObject, target:DisplayObject):Boolean
		{
			while (child)
			{
				if (child == target)
				{
					return true;
				}
				child = child.parent;
			}
			return false;
		}

		private static function cleanMouseSkin():void
		{
			CursorManager.instance.removeCursor2(CursorPriority.DRAG);
			_dragSprite = null;
		}

		/**
		 * 取消拖放
		 *
		 */
		public static function cancelDrag():void
		{
			cleanMouseSkin();
			removeDropOutListerner(_dragComponentFrom);
			setSelected(_dragComponentFrom, false);
			setDraging(_dragComponentFrom, false, null);
			//清除拾起操作
			MouseStateHolder.instance.cleanOperater();
		}

		/**
		 * 添加DropOut监听
		 *
		 */
		private static function addDropOutListerner(dragComponent:IDragable):void
		{
			dragComponent.addEventListener(Event.ENTER_FRAME, onDelayAddStageDropOut);
		}

		private static function onDelayAddStageDropOut(event:Event):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			dropOutTarget.addEventListener(MouseEvent.MOUSE_DOWN, onStageDropOut);
		}

		private static function onDefaultDropOut(event:DragEvent):void
		{
			event.currentTarget.removeEventListener(DragEvent.DROP_DOWN, onDefaultDropOut);
			if (!event.isDefaultPrevented())
			{
				eventDispatcher.dispatchEvent(new DragEvent(DragEvent.DROP_OUT, _dragComponentFrom, null, false, true));
				DragManager.cancelDrag();
			}
		}

		protected static function onDefaultDropBack(event:DragEvent):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			if (!event.isDefaultPrevented())
			{
				eventDispatcher.dispatchEvent(new DragEvent(DragEvent.DROP_BACK, _dragComponentFrom, null, false, true));
				cancelDrag();
			}
		}

		public static function dropOut():void
		{
			_dragComponentFrom.addEventListener(DragEvent.DROP_OUT, onDefaultDropOut, false, -50);
			_dragComponentFrom.dispatchEvent(new DragEvent(DragEvent.DROP_OUT, _dragComponentFrom, null, false, true));
		}

		/**
		 * 选中后的效果
		 * @param value
		 *
		 */
		private static function setSelected(dragComponent:IDragable, value:Boolean):void
		{
			dragComponent.bePickedUp = value;
			dragComponent.dispatchEvent(new DragEvent(DragEvent.SELECT, dragComponent, null));
		}

		/**
		 *
		 * @param target
		 *
		 */
		public static function processDragDrop(target:TComponent):void
		{
			if (isDraging())
			{
				if (MouseOperatorLock.instance.isLocked())
					return;
				//掉落操作实行之后，加锁避免该帧内其他操作进行
				MouseOperatorLock.instance.lock();
				//已经找到掉落对象, 去除DropOut监听
				removeDropOutListerner(_dragComponentFrom);
				//检查当前是不是在targetPlaces中,在其中则为掉落
				if (target.dragAccpetPlaces && (target.dragAccpetPlaces.indexOf(_dragComponentFrom.place) != -1 || target.dragAccpetPlaces.indexOf(0 /*DragImagePlaces.ALL*/) != -1)
					&& (_dragComponentFrom.dropBackAreaArray == null || _dragComponentFrom.dropBackAreaArray.indexOf(target) == -1))
				{
					target.stage.addEventListener(DragEvent.DROP_DOWN, onDefaultDropDown, false, -50);
					target.dispatchEvent(new DragEvent(DragEvent.DROP_DOWN, _dragComponentFrom, target, true /*冒泡*/, true));
				}
				else
				{
					//不接受的物品，执行掉回操作
					_dragComponentFrom.addEventListener(DragEvent.DROP_BACK, onDefaultDropBack, false, -50);
					_dragComponentFrom.dispatchEvent(new DragEvent(DragEvent.DROP_BACK, _dragComponentFrom, null, false, true));
//					_dragComponentFrom.addEventListener(DragEvent.DROP_OUT, onDefaultDropOut, false, -50);
//					_dragComponentFrom.dispatchEvent(new DragEvent(DragEvent.DROP_OUT, _dragComponentFrom, null, false, true));
				}
			}
		}

		/**
		 * 默认的 DropDown处理，可以用preventDefault屏蔽
		 * @param event
		 *
		 */
		private static function onDefaultDropDown(event:DragEvent):void
		{
			event.currentTarget.removeEventListener(DragEvent.DROP_DOWN, onDefaultDropDown);
			if (!event.isDefaultPrevented())
			{
				eventDispatcher.dispatchEvent(new DragEvent(DragEvent.DROP_DOWN, DragManager.dragFrom, event.dragTarget, true, true));
				cancelDrag();
			}
		}
	}
}
