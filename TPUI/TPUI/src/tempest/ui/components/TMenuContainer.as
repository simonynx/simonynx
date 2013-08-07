package tempest.ui.components
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventPhase;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import tempest.ui.PopupManager;
	import tempest.ui.TPUGlobals;
	import tempest.ui.effects.BaseEffect;
	import tempest.ui.effects.MenuEffect;
	import tempest.ui.events.EffectEvent;
	import tempest.ui.events.MenuEffectEvent;
	import tempest.ui.events.TWindowEvent;

	public class TMenuContainer extends TAutoSizeComponent
	{
		protected var _menuEffect:MenuEffect;
		protected var _hideWhenClickSelf:Boolean;
		protected var _notAutoHideTargetArray:Array = [];
		private var _target:DisplayObject;
		private var _xOffset:Number = 0;
		private var _yOffsetUp:Number = 0;
		private var _yOffsetDown:Number = 0;
		private var _mouseFlow:Boolean;
		private var _useMenuEffect:Boolean;
		private var _direct:int;
		public var addToStage:Boolean = true;
		private var _shower:DisplayObject;
		private var _windowAttached:DisplayObject;

		/**
		 *
		 * @param _proxy 菜单背景资源。
		 * @param target 菜单所属的控件，用于定位，如果为null，则菜单在鼠标位置打开。
		 * @param notAutoHideTargetArray 设置点击到某些控件，不自动收起菜单。
		 * @param hideWhenClickSelf 需要菜单可以触发点击的话，该值需保持默认的false
		 *
		 */
		public function TMenuContainer(constraints:Object = null, proxy:* = null, target:DisplayObject = null, useMenuEffect:Boolean = false, notAutoHideTargetArray:Array = null, hideWhenClickSelf:Boolean =
			false, direct:int = MenuEffect.DERECT_DOWN, shower:DisplayObject = null)
		{
			_notAutoHideTargetArray = notAutoHideTargetArray;
			_direct = direct;
			this._target = target;
			_useMenuEffect = useMenuEffect;
			this.shower = shower;
			if (!_notAutoHideTargetArray)
			{
				_notAutoHideTargetArray = [];
			}
			_hideWhenClickSelf = hideWhenClickSelf;
			if (!_hideWhenClickSelf)
			{
				_notAutoHideTargetArray.push(this); //点击到自身不收起菜单
			}
			super(constraints, proxy);
		}

		/**
		 * 关联一个窗口，监听 TWindowEvent.MOVE_TO_TOP事件，以将自身随窗口置顶而置顶
		 * @param window
		 *
		 */
		public function attachToWindow(window:DisplayObject):void
		{
			if (_windowAttached)
			{
				_windowAttached.removeEventListener(TWindowEvent.MOVE_TO_TOP, onTargetMoveToTopEvent);
			}
			_windowAttached = window;
			if (_windowAttached)
			{
				_windowAttached.addEventListener(TWindowEvent.MOVE_TO_TOP, onTargetMoveToTopEvent);
			}
		}

		private function onTargetMoveToTopEvent(event:Event):void
		{
			if (this.parent)
			{
				this.parent.setChildIndex(this, this.parent.numChildren - 1);
			}
		}

		override protected function addChildren():void
		{
			super.addChildren();
			if (_useMenuEffect)
			{
				_menuEffect = new MenuEffect(10, this, direct);
				_menuEffect.addEventListener(MenuEffectEvent.DEPLOY, onDeploy);
				_menuEffect.addEventListener(MenuEffectEvent.RETRACTION, onRetraction);
			}
			else
			{
				this.visible = false;
			}
			this.addEventListener(Event.ADDED, onAdded);
		}

		/**
		 * 弹出菜单
		 *
		 */
		public function play():void
		{
			if (!shower.stage)
			{
				return;
			}

			if (_menuEffect)
			{
				if (_menuEffect.hiding)
				{
					if (addToStage)
					{
						this.addThisToStage();
					}
					addClickListenerToStage();
					_shower.addEventListener(Event.REMOVED_FROM_STAGE, onShowerRemoveFromStage);
				}
				else if (_menuEffect.showing)
				{
					removeClickListenerFromStage();
					_menuEffect.addEventListener(EffectEvent.END, onComboInEnd);
					_shower.removeEventListener(Event.REMOVED_FROM_STAGE, onShowerRemoveFromStage);
				}
				_menuEffect.play();
			}
			else
			{
				this.visible = !this.visible;
				if (this.visible)
				{
					this.addThisToStage();
					addClickListenerToStage();
					_shower.addEventListener(Event.REMOVED_FROM_STAGE, onShowerRemoveFromStage);
				}
				else
				{
					removeClickListenerFromStage();
					PopupManager.instance.removePopup(this);
//					StageReference.stage.removeChild(this);
					_shower.removeEventListener(Event.REMOVED_FROM_STAGE, onShowerRemoveFromStage);
				}
			}
		}

		/**
		 * 展开菜单
		 *
		 */
		public function expend():void
		{
			if (!shower.stage)
			{
				return;
			}
			if (_menuEffect)
			{
				if (_menuEffect.hiding)
				{
					if (addToStage)
					{
						this.addThisToStage();
					}
					addClickListenerToStage();
					_shower.addEventListener(Event.REMOVED_FROM_STAGE, onShowerRemoveFromStage);
					_menuEffect.expend();
				}
			}
			else
			{
				if (!this.visible)
				{
					this.visible = true;
					this.addThisToStage();
					addClickListenerToStage();
					_shower.addEventListener(Event.REMOVED_FROM_STAGE, onShowerRemoveFromStage);
				}
			}
		}

		/**
		 * 收起菜单
		 *
		 */
		public function dispend():void
		{
			if (!shower.stage)
			{
				return;
			}
			if (_menuEffect)
			{
				if (_menuEffect.showing)
				{
					removeClickListenerFromStage();
					_menuEffect.addEventListener(EffectEvent.END, onComboInEnd);
					_shower.removeEventListener(Event.REMOVED_FROM_STAGE, onShowerRemoveFromStage);
					_menuEffect.dispend();
				}
			}
			else
			{
				if (this.visible)
				{
					removeClickListenerFromStage();
					PopupManager.instance.removePopup(this);
					//					StageReference.stage.removeChild(this);
					_shower.removeEventListener(Event.REMOVED_FROM_STAGE, onShowerRemoveFromStage);
					this.visible = false;
				}
			}
		}

		/**
		 * 菜单是否在弹出中
		 * @return
		 *
		 */
		public function get showing():Boolean
		{
			return _menuEffect.showing;
		}

		private function onAdded(event:Event):void
		{
			if (event.eventPhase == EventPhase.AT_TARGET)
			{
				return;
			}
			measureChildren();
//			this.setSize($width, $height);
		}

		private function addThisToStage():void
		{
			var point:Point = getShowPoint(_direct);
			//检查菜单方向，超出边界则修改方向 
			if (!valideDirect(point))
			{
				//如果方向需要调整，用新方向重新计算菜单位置
				point = getShowPoint(_direct);
			}
			this.x = point.x;
			this.y = point.y;
			PopupManager.instance.showPopup(null, this, false);
//			if (_target is DisplayObjectContainer)
//			{
//				(_target as DisplayObjectContainer).addChild(this);
//			}
//			else
//			{
//				PopupManager.instance.showPopup(null, this, false);
//			}
		}

		/**
		 * 根据偏移等因素计算显示位置
		 * @param direct
		 * @return
		 *
		 */
		private function getShowPoint(direct:int):Point
		{
			var yOffset:Number = _direct == MenuEffect.DERECT_DOWN ? _yOffsetDown : _yOffsetUp;
			var point:Point;
			if (_target)
			{
				point = _target.localToGlobal(new Point(_xOffset, yOffset));
//				point = new Point(_xOffset, yOffset);
			}
			else
			{
				point = new Point(TPUGlobals.stage.mouseX + _xOffset, TPUGlobals.stage.mouseY + yOffset);
			}
			point.y = _direct == MenuEffect.DERECT_DOWN ? point.y : point.y - this.height;
			return point;
		}

		/**
		 * 检查菜单方向，超出边界则修改方向
		 *
		 */
		private function valideDirect(pos:Point):Boolean
		{
			if (this.direct == MenuEffect.DERECT_DOWN && pos.y + this.height > TPUGlobals.stage.height)
			{
				this.direct = MenuEffect.DERECT_UP;
				return false;
			}
			else if (this.direct == MenuEffect.DERECT_UP && pos.y < 0)
			{
				this.direct = MenuEffect.DERECT_DOWN;
				return false;
			}
			return true;
		}

		private function addClickListenerToStage():void
		{
			TPUGlobals.app.addEventListener(Event.ENTER_FRAME, delayAddStageListener);
		}

		private function removeClickListenerFromStage():void
		{
			TPUGlobals.app.removeEventListener(Event.ENTER_FRAME, delayAddStageListener);
			TPUGlobals.app.signals.mouseDown.remove(onStageClick);
		}

		private function delayAddStageListener(event:Event):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			TPUGlobals.app.signals.mouseDown.add(onStageClick);
		}

		private function onComboInEnd(event:Event):void
		{
			_menuEffect.removeEventListener(EffectEvent.END, onComboInEnd);
			if (addToStage)
			{
				PopupManager.instance.removePopup(this);
			}
//			StageReference.stage.removeChild(this);
		}

		private function onStageClick(event:MouseEvent):void
		{
			if (!stage)
			{
				removeClickListenerFromStage();
				return;
			}
			for each (var _notAutoHideTarget:DisplayObject in _notAutoHideTargetArray)
			{
				if (_notAutoHideTarget.hitTestPoint(stage.mouseX, stage.mouseY))
				{
					return;
				}
			}
			removeClickListenerFromStage();
			if (_menuEffect)
			{
				_menuEffect.play();
				_menuEffect.addEventListener(EffectEvent.END, onComboInEnd);
			}
			else
			{
				this.visible = false;
			}
		}

		private function onDeploy(event:Event):void
		{
			this.dispatchEvent(event);
		}

		private function onRetraction(event:Event):void
		{
			this.dispatchEvent(event);
		}

		public function set xOffset(value:Number):void
		{
			this._xOffset = value;
		}

		public function set yOffsetUp(value:Number):void
		{
			this._yOffsetUp = value;
		}

		public function set yOffsetDown(value:Number):void
		{
			this._yOffsetDown = value;
		}

		public function set yOffset(value:Number):void
		{
			yOffsetUp = -value;
			yOffsetDown = value;
		}

		public function set direct(value:int):void
		{
			this._direct = value;
			if (_menuEffect)
				_menuEffect.direct = value;
		}

		public function get direct():int
		{
			return this._direct;
		}

		public function get menuEffect():MenuEffect
		{
			return _menuEffect;
		}

		public function set notAutoHideTargetArray(value:Array):void
		{
			_notAutoHideTargetArray = value;
			if (!_hideWhenClickSelf)
			{
				_notAutoHideTargetArray.push(this); //点击到自身不收起菜单
			}
		}

		/**
		 * 设置菜单展开的参考控件
		 * 菜单展开的位置将以该控件在stage中的x，y为参照
		 * @param value
		 *
		 */
		public function set container(value:DisplayObject):void
		{
			_target = value;
		}

		public function get container():DisplayObject
		{
			return _target;
		}

		public function set shower(value:DisplayObject):void
		{
			_shower = value;
		}

		public function get shower():DisplayObject
		{
			return _shower;
		}

		private function onShowerRemoveFromStage(event:Event):void
		{
			_shower.removeEventListener(Event.REMOVED_FROM_STAGE, onShowerRemoveFromStage);
			removeClickListenerFromStage();
			if (_menuEffect)
			{
				if (_menuEffect.showing)
				{
					_menuEffect.addEventListener(EffectEvent.END, onComboInEnd);
					_menuEffect.dispend();
				}
//				else
//				{
//					this.visible = false;
//				}
			}
			else
			{
				PopupManager.instance.removePopup(this);
				this.visible = false;
			}
		}
	}
}
