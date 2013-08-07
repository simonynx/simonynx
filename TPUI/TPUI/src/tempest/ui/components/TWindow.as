package tempest.ui.components
{
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.GTweener;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventPhase;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;

	import mx.containers.Form;

	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.ui.TPUGlobals;
	import tempest.ui.effects.BaseEffect;
	import tempest.ui.effects.IEffect;
	import tempest.ui.effects.IWindowEffect;
	import tempest.ui.effects.WindowEffectA;
	import tempest.ui.effects.WindowEffectB;
	import tempest.ui.effects.WindowEffectEvent;
	import tempest.ui.events.EffectEvent;
	import tempest.ui.events.TComponentEvent;
	import tempest.ui.events.TWindowEvent;

	[Event(name = "windowClose", type = "tempest.ui.events.TWindowEvent")]
	[Event(name = "windowShow", type = "tempest.ui.events.TWindowEvent")]
	[Event(name = "register", type = "tempest.ui.events.TWindowEvent")]
	public class TWindow extends TContainer
	{
		public var bg:MovieClip;
//		public var title:TextField;
		private var _isShow:Boolean = false; //窗口是否在舞台显示
		//-----------------------------------------------
		protected var _btn_close:TButton;
		protected var _dragable:Boolean = true;
		public var useEffect:Boolean = true; //是否使用缓动窗口
		protected var _effect:IWindowEffect = null;
		private var _childWindowVec:Vector.<TWindow>;
		private var _mc_title:Sprite;
		private static const log:ILogger = TLog.getLogger(TWindow);
		private var invalidPosEnabledWhenAdd:Boolean = true; //是否在添加到舞台时invalidatePos

		/**
		 *
		 * @param constraint 约束
		 *  例如:{left: 0, right: 0, top: 0, bottom: 0, horizontalCenter: 0, verticalCenter: 0}
		 * @param proxy
		 * @param name
		 *
		 */
		public function TWindow(constraints:Object = null, proxy:* = null, name:String = "")
		{
			super(constraints, proxy);
			//关闭按钮
			if (_proxy && _proxy.hasOwnProperty("btn_close") && _proxy.btn_close != null)
			{
				_btn_close = new TButton(null, _proxy.btn_close, null, onClose);
			}
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			super.name = name;
			this.addEventListener(TComponentEvent.SHOW, onShow);
			this.addEventListener(TComponentEvent.HIDE, onHide);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			_childWindowVec = new Vector.<TWindow>();
			this.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			this.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			this.addEventListener(Event.ADDED, onAdded);
			this.addEventListener(Event.REMOVED, onRemoved);
//			effect = new WindowEffectA(this); //默认窗口效果
			effect = new WindowEffectB(this);
		}

		private function onAdded(event:Event):void
		{
			if (event.eventPhase == EventPhase.BUBBLING_PHASE ||
				event.eventPhase == EventPhase.AT_TARGET)
			{
				this.measureChildren(false); //子级被添加时，重新测量大小
			}
		}

		private function onRemoved(event:Event):void
		{
			if (event.eventPhase == EventPhase.BUBBLING_PHASE ||
				event.eventPhase == EventPhase.AT_TARGET)
			{
				this.measureChildren(false); //子级被移除时，重新测量大小
			}
		}

		private function onRollOver(event:MouseEvent):void
		{
			this.mouseChildren = true;
		}

		private function onRollOut(event:MouseEvent):void
		{
			this.mouseChildren = false;
		}

		private function onRemovedFromStage(event:Event):void
		{
			TPUGlobals.app.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}

		public function get isShow():Boolean
		{
			return _isShow && (!effect || !effect.closeEffect.playing); //如果关闭效果正在播放，也认为不在显示中
		}

		public function set isShow(value:Boolean):void
		{
			_isShow = value;
		}

		/**
		 * 设置标题
		 * @param titleClass
		 *
		 */
		public function setTitle(titleClass:Class):void
		{
			var mc_title:Sprite = titleClass ? Sprite(new titleClass()) : null;
			if (_mc_title)
			{
				this.removeChild(_mc_title);
			}
			_mc_title = mc_title;
			_mc_title.mouseEnabled = _mc_title.mouseChildren = false;
			if (_mc_title)
			{
				if (_proxy.hasOwnProperty("mc_title_pos"))
				{
					_mc_title.y = _proxy.mc_title_pos.y - _mc_title.height * 0.5;
				}
				else
				{
					_mc_title.y = 12;
				}
				_mc_title.x = (this.width - _mc_title.width) * 0.5;
				this.addChild(_mc_title);
			}
		}

//		override protected function addChildren():void
//		{
//			super.addChildren();
//			this.invalidateNow();
//		}
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		private function onShow(event:Event):void
		{
			this.isShow = true;
			if (effect)
			{
				effect.playOpenEffect();
			}
		}

		private function onHide(event:Event):void
		{
			this.isShow = false;
			//关闭后焦点设置到场景
//			TPUGlobals.stage.focus = TPUGlobals.stage;
//			StageReference.stage.focus = TScene.instance.interactiveLayer;
		}
		private var mX:Number;
		private var mY:Number;

		private function onMouseDown(event:MouseEvent):void
		{
			if (!_dragable)
			{
				return;
			}
			if (event.target == _proxy || isBg(event.target as DisplayObject))
			{
				this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				TPUGlobals.app.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				mX = mouseX;
				mY = mouseY;
//				this.startDrag();
			}
			//置顶本窗口
			moveToTop();
		}

		public function stopDraging():void
		{
			onMouseUp(null);
		}

		private function onMouseMove(event:MouseEvent):void
		{
			this.x = stage.mouseX - mX;
			this.y = stage.mouseY - mY;
		}

		private function onMouseUp(event:MouseEvent):void
		{
			TPUGlobals.app.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
//			this.stopDrag();
		}

		/**
		 * 获取窗口的背景，用来作为拖动的触发点
		 * @return
		 *
		 */
		protected function getBg():DisplayObject
		{
			if (_proxy.hasOwnProperty("bg"))
				return _proxy["bg"];
			else
				return null;
		}

		protected function isBg(target:DisplayObject):Boolean
		{
			return target && (target == getBg() || target.name.indexOf("bg") == 0);
		}

		/**
		 * 点击关闭按钮处理
		 * @param event
		 *
		 */
		protected function onClose(event:MouseEvent):void
		{
			closeWindow();
		}

		/**
		 * 关闭窗口，如果有效果则播放效果
		 * 需要用此方法替代 this.parent.removeChild(this);
		 *
		 */
		public function closeWindow():void
		{
			if (!stage)
			{
				return;
			}
			dispatchEvent(new TWindowEvent(TWindowEvent.WINDOW_CLOSE_START));
			if (effect)
			{
				effect.playCloseEffect();
			}
			else
			{
				onCloseComplete(null);
			}
			if (stage)
			{
				TPUGlobals.app.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			}
			//关闭子级窗口
			for (var i:int = 0; i < _childWindowVec.length; i++)
			{
				var childWindow:TWindow = _childWindowVec[i] as TWindow;
				childWindow.closeWindow();
			}
			_childWindowVec = new Vector.<TWindow>();
		}

		/**
		 * 添加子级窗口
		 * @param window
		 *
		 */
		public function addChildWindow(window:TWindow):void
		{
			_childWindowVec.push(window);
			//监听子级窗口关闭，删除窗口引用
			window.addEventListener(TWindowEvent.WINDOW_CLOSE, onChildWindowClose);
		}

		private function onChildWindowClose(event:TWindowEvent):void
		{
			var childWindow:TWindow = TWindow(event.currentTarget);
			_childWindowVec.splice(_childWindowVec.indexOf(childWindow), 1);
		}

		private function onCloseComplete(event:Event):void
		{
			dispatchEvent(new TWindowEvent(TWindowEvent.WINDOW_CLOSE));
		}

		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		public function set dragable(value:Boolean):void
		{
			_dragable = value;
		}

		public function get dragable():Boolean
		{
			return _dragable;
		}

		public override function dispose():void
		{
			if (effect)
				effect.stop();
		}

		/**
		 * 设置窗口的开启关闭效果
		 * @param value
		 *
		 */
		public function set effect(value:IWindowEffect):void
		{
			if (useEffect)
			{
				if (_effect)
				{
					_effect.removeEventListener(WindowEffectEvent.CLOSE_WINDOW, onCloseComplete);
				}
				_effect = value;
				if (_effect)
				{
					_effect.addEventListener(WindowEffectEvent.CLOSE_WINDOW, onCloseComplete);
				}
			}
		}

		public function get effect():IWindowEffect
		{
			return useEffect ? _effect : null;
		}

		protected var oldParentWidth:Number; //上次的父级宽高
		protected var oldParentHeight:Number;

		/**
		 * 清除父级大小历史记录
		 * 之后invalidatePosition会重新定位窗口
		 *
		 */
		public function cleanParentSizeHistory():void
		{
			oldParentWidth = 0;
			oldParentHeight = 0;
		}

		/**
		 * 置顶窗口
		 *
		 */
		public function moveToTop():void
		{
			if (this.parent)
			{
				this.parent.setChildIndex(this, this.parent.numChildren - 1);
				//置顶所有子窗口
				for each (var childWindow:TWindow in _childWindowVec)
				{
					this.parent.setChildIndex(childWindow, this.parent.numChildren - 1);
				}
				dispatchEvent(new TWindowEvent(TWindowEvent.MOVE_TO_TOP));
			}
		}

		override public function invalidatePosition():void
		{
			//父级宽高如果没有改变，不重新定位\
			if (!this.parent)
			{
				return;
			}
			if (oldParentWidth != this.parent.width || oldParentHeight != this.parent.height)
			{
				super.invalidatePosition();
			}
			oldParentWidth = this.parent.width;
			oldParentHeight = this.parent.height;
		}

		public function invalidatePositionNow():void
		{
			super.invalidatePosition();
		}

		public function get tbtn_close():TButton
		{
			return _btn_close;
		}
	}
}


