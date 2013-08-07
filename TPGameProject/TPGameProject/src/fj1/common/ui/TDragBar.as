package fj1.common.ui
{
	import assets.CursorLib;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import tempest.ui.CursorManager;
	import tempest.ui.TPUGlobals;
	import tempest.ui.UIConst;
	import tempest.ui.components.TComponent;


	public class TDragBar extends TComponent
	{
		private var _target:DisplayObjectContainer;
		private static var _dragingBar:TDragBar;
		private var _type:int;

		private var _dragingSignal:ISignal;
		private var _stopDragSignal:ISignal;

		private var _useCursor:Boolean;

		public function get dragingSignal():ISignal
		{
			return _dragingSignal ||= new Signal();
		}

		public function get stopDragSignal():ISignal
		{
			return _stopDragSignal ||= new Signal();
		}

		public function TDragBar(constraints:Object, proxy:*, target:DisplayObjectContainer, useCursor:Boolean = true)
		{
			super(constraints, proxy);
			_useCursor = useCursor;
			_target = target;
			_target.addChild(this);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			this.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
		}

		public function get draging():Boolean
		{
			return _dragingBar && _dragingBar == this;
		}

		private function onRollOver(event:MouseEvent):void
		{
			if (!_dragingBar)
			{
				showCursor();
			}
		}

		private function onRollOut(event:MouseEvent):void
		{
			if (!event.buttonDown)
			{
				hideCursor();
			}
		}

		private function onMouseDown(event:MouseEvent):void
		{
			if (!_dragingBar)
			{
				TPUGlobals.stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
				TPUGlobals.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				_dragingBar = this;
			}
		}

		private function onStageMouseUp(event:MouseEvent):void
		{
			TPUGlobals.stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			TPUGlobals.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_dragingBar = null;
			hideCursor();
			stopDragSignal.dispatch(this);
		}

		private function onMouseMove(event:MouseEvent):void
		{
			if (_dragingBar == this)
			{
				dragingSignal.dispatch(_target.mouseX + 1, _target.mouseY + 1);
			}
		}

		/**
		 * 显示光标
		 *
		 */
		private function showCursor():void
		{
			if (_useCursor)
			{
				if (_constraints.hasOwnProperty("top") && _constraints.hasOwnProperty("bottom"))
				{
					CursorManager.instance.setCursor(CursorLib.SIZE_CHANGE_HORIZON);
				}
				else if (_constraints.hasOwnProperty("left") && _constraints.hasOwnProperty("right"))
				{
					CursorManager.instance.setCursor(CursorLib.SIZE_CHANGE_VERTICAL);
				}
				else
				{
					CursorManager.instance.setCursor(CursorLib.SIZE_CHANGE_CORNER);
				}
			}
		}

		/**
		 * 隐藏光标
		 *
		 */
		private function hideCursor():void
		{
			if (_useCursor)
			{
				if (_constraints.hasOwnProperty("top") && _constraints.hasOwnProperty("bottom"))
				{
					CursorManager.instance.removeCursor(CursorLib.SIZE_CHANGE_HORIZON);
				}
				else if (_constraints.hasOwnProperty("left") && _constraints.hasOwnProperty("right"))
				{
					CursorManager.instance.removeCursor(CursorLib.SIZE_CHANGE_VERTICAL);
				}
				else
				{
					CursorManager.instance.removeCursor(CursorLib.SIZE_CHANGE_CORNER);
				}
			}
		}

	}
}
