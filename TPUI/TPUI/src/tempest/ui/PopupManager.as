package tempest.ui
{
	import com.adobe.utils.ArrayUtil;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import tempest.manager.KeyboardManager;
	import tempest.ui.components.TWindow;
	import tempest.ui.events.TWindowEvent;
	import tempest.utils.Geom;

	public final class PopupManager
	{
		private static var _instance:PopupManager = null;
//		private var _app:TPApp = null;
		private static var _appEnable:Boolean = true;
		private var _popupLayer:DisplayObjectContainer;
		private var _application:DisplayObjectContainer;
		private var _applicationEnabled:Boolean = true;
		private static var _backCount:int = 0;
//		/**
//		 * 定义进入激活状态的Oper，用于显示过渡效果
//		 */
//		public var applicationEnabledOper:IEffect;
//		
//		/**
//		 * 定义进入非激活状态的Oper，用于显示过渡效果
//		 */
//		public var applicationDisabledOper:IEffect;
		/**
		 * 是否自動禁用非活动窗口
		 */
		public var autoDisibledBackgroundPopup:Boolean;
		private var _window_name_map:Dictionary = new Dictionary();
		/**
		 * 模态窗口数组
		 */
		private var _popups:Array = [];

		public function get popups():Array
		{
			return _popups;
		}

		public function PopupManager()
		{
			if (_instance != null)
				throw(new Error("该类不能重复实例化"));
			_instance = this;
		}

		public static function get instance():PopupManager
		{
			if (_instance == null)
				new PopupManager();
			return _instance;
		}
		private static var _coverChangeSignal:ISignal;

		/**
		 * 是否有蒙板存在状态变更时触发
		 * 有蒙板时参数为true
		 * @return
		 *
		 */
		public static function get coverChangeSignal():ISignal
		{
			return _coverChangeSignal ||= new Signal();
		}

		/**
		 * 显示一个临时的背景遮罩在对象后面作为遮挡，并会和对象一起被删除
		 *
		 * @param v - 目标
		 * @param color	- 颜色
		 * @param alpha	- 透明度
		 * @param mouseEnabled	- 是否遮挡下面的鼠标事件
		 *
		 */
		public static function showSolidCover(v:DisplayObject, color:uint = 0x0, alpha:Number = 0.5, mouseEnabled:Boolean = false):Sprite
		{
			var back:Sprite = new Sprite();
			drawCover(back, color, alpha);
			back.mouseEnabled = mouseEnabled;
			addCover(v, back, v.parent, v.parent.getChildIndex(v), color, alpha, mouseEnabled, onResize);
			function onResize(event:Event):void
			{
				drawCover(back, color, alpha);
			}
			return back;
		}

		private static function drawCover(cover:Sprite, color:uint, alpha:Number):void
		{
			cover.graphics.clear();
			cover.graphics.beginFill(color, alpha);
			var rect:Rectangle = new Rectangle(0, 0, TPUGlobals.stage.stageWidth, TPUGlobals.stage.stageHeight);
			cover.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			cover.graphics.endFill();
		}

		/**
		 * 添加蒙板
		 * 当蒙板存在时键盘会被禁用
		 * @param v 蒙板添加的目标，蒙板将随目标移除而移除，可以为null
		 * @param back 蒙板对象
		 * @param parent 蒙板添加到的父级
		 * @param childIndex 添加到父级中的索引
		 * @param color
		 * @param alpha
		 * @param mouseEnabled
		 * @param resizeHandler 舞台RESIZE时触发的回调
		 *
		 */
		public static function addCover(target:DisplayObject, back:Sprite, parent:DisplayObjectContainer, childIndex:int, color:uint = 0x0, alpha:Number = 0.5,
			mouseEnabled:Boolean = false, resizeHandler:Function = null):void
		{
			//背景遮罩
			parent.addChildAt(back, childIndex);
			if (resizeHandler != null)
			{
				TPUGlobals.stage.addEventListener(Event.RESIZE, resizeHandler);
			}
			if (_backCount >= 0)
			{
				KeyboardManager.disable(); //禁用键盘
				coverChangeSignal.dispatch(true);
			}
			if (target)
			{
				target.addEventListener(Event.REMOVED_FROM_STAGE, removeHandler);
			}
			back.addEventListener(Event.REMOVED_FROM_STAGE, backRemoveHandler);
			FetchHelper.instance.registerUnAcceptTarget(back);
			_backCount++;
			function removeHandler(event:Event):void
			{
				target.removeEventListener(Event.REMOVED_FROM_STAGE, removeHandler);
				if (back.parent)
				{
					back.parent.removeChild(back);
				}
			}
			function backRemoveHandler(event:Event):void
			{
				FetchHelper.instance.unRegisterUnAcceptTarget(back);
				_backCount--;
				if (resizeHandler != null)
				{
					TPUGlobals.stage.removeEventListener(Event.RESIZE, resizeHandler);
				}
				if (_backCount <= 0)
				{
					KeyboardManager.enable(); //启用键盘
					coverChangeSignal.dispatch(false);
				}
			}
		}

		/**
		 * 显示一个中空的蒙板
		 * @param v
		 * @param parent
		 * @param childIndex
		 * @param color
		 * @param alpha
		 * @param mouseEnabled
		 *
		 */
		public static function showHollowCover(v:DisplayObject, parent:DisplayObjectContainer, childIndex:int, color:uint = 0x0, alpha:Number = 0.5, mouseEnabled:Boolean = false):Sprite
		{
			var _back:Sprite = new Sprite();
			drawCover2(_back, color, alpha, v);
			_back.mouseEnabled = mouseEnabled;
			addCover(v, _back, parent, childIndex, color, alpha, mouseEnabled, onResize);
			function onResize(event:Event):void
			{
				drawCover2(_back, color, alpha, v);
			}
			return _back;
		}

		private static function drawCover2(cover:Sprite, color:uint, alpha:Number, cellSp:DisplayObject):void
		{
			cover.graphics.clear();
			cover.graphics.beginFill(color, alpha);
			var rect:Rectangle = new Rectangle(0, 0, TPUGlobals.stage.stageWidth, TPUGlobals.stage.stageHeight);
			cover.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			var vRect:Rectangle = cellSp.getBounds(TPUGlobals.stage);
			cover.graphics.drawRect(vRect.x, vRect.y, vRect.width, vRect.height);
			cover.graphics.endFill();
		}

		/**
		 * 最好手动执行此方法，如果不执行，将会以RootManager的属性为准。RootManager也没有初始化则无法使用。
		 *
		 * @param application	主程序
		 * @param popupLayer	弹出窗口层
		 *
		 */
		public function register(application:DisplayObjectContainer, popupLayer:DisplayObjectContainer):void
		{
			this.application = application;
			this.popupLayer = popupLayer;
//			this.effectTarget = this.application;
		}

		/**
		 * 显示一个窗口
		 *
		 * @param obj	窗口实例
		 * @param modal	是否是模态窗口
		 * @param center	居中模式（CenterMode）
		 */
		public function showPopup(parentWindow:TWindow, obj:DisplayObject, modal:Boolean = true, offest:Point = null):DisplayObject
		{
//			if (owner == null)
//				owner = this._app;
			if (offest)
			{
				obj.x = offest.x;
				obj.y = offest.y;
			}
			popupLayer.addChild(obj);
			//添加子级窗口
			if (parentWindow && parentWindow is TWindow && obj is TWindow)
			{
				parentWindow.addChildWindow(TWindow(obj));
			}
			obj.addEventListener(TWindowEvent.WINDOW_CLOSE, onClose);
//			owner.addChildAt(obj, owner.numChildren - 1);
//			obj.addEventListener(Event.REMOVED_FROM_STAGE, popupCloseHandler);
			if (modal)
			{
				popups.push(obj);
				if (popups.length > 0)
					applicationEnabled = false;
				obj.addEventListener(Event.REMOVED_FROM_STAGE, modulePopupCloseHandler);
				if (autoDisibledBackgroundPopup)
					disibledBackgoundPopup();
				if (obj is InteractiveObject)
					TPUGlobals.stage.focus = InteractiveObject(obj); //模态窗口弹出后获取焦点
			}
			return obj;
		}

		private function onClose(event:Event):void
		{
			PopupManager.instance.removePopup(event.currentTarget as DisplayObject);
		}

		public function showPopup2(parentWindow:TWindow, obj:DisplayObject, modal:Boolean = false, useCover:Boolean = false, offset:Point = null):DisplayObject
		{
			showPopup(parentWindow, obj, modal, offset);
			if (useCover)
			{
				showSolidCover(obj, 0x0, UIStyle.COVER_ALPHA, true);
			}
			else
			{
				if (modal)
				{
					showSolidCover(obj, 0x0, 0, true);
				}
			}
			return obj;
		}

		public function findPopup(name:String):DisplayObject
		{
			for (var i:int = 0; i < popupLayer.numChildren; ++i)
			{
				var obj:DisplayObject = popupLayer.getChildAt(i);
				if (obj.name == name)
				{
					return obj;
				}
			}
			return null;
		}

		/**
		 * 根据name属性移出窗口
		 * @param name
		 *
		 */
		public function removePopupByName(name:String):void
		{
			var displayObj:DisplayObject = findPopup(name);
			if (displayObj)
			{
				removePopup(displayObj);
			}
		}

		/**
		 * 删除一个窗口
		 * @param obj
		 *
		 */
		public function removePopup(obj:DisplayObject):void
		{
			if (obj.parent == popupLayer)
			{
				popupLayer.removeChild(obj);
			}
		}

		/**
		 * 获取弹出窗口数
		 * @return
		 *
		 */
		public function getPopupNum():int
		{
			return popupLayer.numChildren;
		}

		/**
		 * 删除所有窗口
		 * @param obj
		 *
		 */
		public function removeAllPopup():void
		{
			while (popupLayer.numChildren)
			{
				removePopup(popupLayer.getChildAt(0));
			}
		}

//		/**
//		 * 窗口关闭
//		 * @param event
//		 *
//		 */
//		protected function popupCloseHandler(event:Event):void
//		{
//			var obj:DisplayObject = event.currentTarget as DisplayObject;
//			event.currentTarget.removeEventListener(Event.REMOVED_FROM_STAGE, popupCloseHandler);
//		}
		/**
		 * 主程序是否激活
		 * @return
		 *
		 */
		public function get applicationEnabled():Boolean
		{
			return _applicationEnabled;
		}

		public function set applicationEnabled(v:Boolean):void
		{
			if (_applicationEnabled == v)
				return;
			_applicationEnabled = v;
			application.mouseEnabled = application.mouseChildren = v;
//			application.filters = v ? null : applicationDisabledFilters;
//			if (applicationEnabledOper)
//				applicationEnabledOper.halt()
//			
//			if (applicationDisabledOper)
//				applicationDisabledOper.halt()
//			if (v)
//			{
//				if (applicationEnabledOper)
//				{
//					if (!applicationEnabledOper.target)
//						applicationEnabledOper.target = effectTarget;
//					applicationEnabledOper.addEventListener(OperationEvent.OPERATION_COMPLETE,enabledOperCompleteHandler);
//					applicationEnabledOper.execute();
//				}
//			}
//			else
//			{
//				if (applicationDisabledOper)
//				{
//					if (!applicationDisabledOper.target)
//						applicationDisabledOper.target = effectTarget;
//					applicationDisabledOper.execute();
//				}
//			}
		}

		/**
		 * 模态窗口关闭方法
		 * @param event
		 *
		 */
		protected function modulePopupCloseHandler(event:Event):void
		{
			ArrayUtil.removeValueFromArray(popups, event.currentTarget);
			if (popups.length <= 0)
				applicationEnabled = true;
			event.currentTarget.removeEventListener(Event.REMOVED_FROM_STAGE, modulePopupCloseHandler);
			if (autoDisibledBackgroundPopup)
				disibledBackgoundPopup();
		}

		/**
		 * 禁用最高層之外的窗體
		 *
		 */
		protected function disibledBackgoundPopup():void
		{
			for (var i:int = 0; i < popups.length; i++)
			{
				var w:Sprite = popups[i] as Sprite;
				if (w)
					w.mouseEnabled = w.mouseChildren = (i == popups.length - 1);
			}
		}

		/**
		 * 弹出窗口容器
		 * @return
		 *
		 */
		public function get popupLayer():DisplayObjectContainer
		{
			return _popupLayer;
		}

		public function set popupLayer(v:DisplayObjectContainer):void
		{
			_popupLayer = v;
		}

		/**
		 * 主程序（模态弹出时将被禁用）
		 * @return
		 *
		 */
		public function get application():DisplayObjectContainer
		{
			return _application;
		}

		public function set application(v:DisplayObjectContainer):void
		{
			_application = v;
		}
	}
}
