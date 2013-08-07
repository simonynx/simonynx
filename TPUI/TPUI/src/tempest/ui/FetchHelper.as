package tempest.ui
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	import tempest.common.staticdata.MouseOperatePriority;
	import tempest.common.staticdata.MouseOperatorType;
	import tempest.ui.events.FetchEvent;
	import tempest.ui.interfaces.IMouseOperator;

//	[Event(name="data", type="tempest.ui.events.DataEvent")]
	public class FetchHelper implements IMouseOperator
	{
		private static var _instance:FetchHelper;
		private var _isFetching:Boolean;
		private var _cursorName:String;
		private var _fetchType:int;
		private var _cancelAfterFetch:Boolean;
		private var _delayTimer:Timer;
		private var _pause:Boolean;
		private var _autoCancel:Boolean;
		private var _parms:Object;
		private var _globalDispatcher:EventDispatcher;
		private var _unAcceptTargetArray:Array;

		public function get isFetching():Boolean
		{
			return _isFetching;
		}

		public function get fetchType():int
		{
			return _fetchType;
		}

		public function get parms():Object
		{
			return _parms;
		}

		public static function get instance():FetchHelper
		{
			if (_instance == null)
				_instance = new FetchHelper();
			return _instance;
		}

		public function FetchHelper()
		{
			if (_instance)
				throw new Error("该类只能有一个实例");
			_instance = this;
			_unAcceptTargetArray = [];
		}

		public function begingFetch(fetchType:int, cursorName:String, autoCancel:Boolean = true, parms:Object = null):EventDispatcher
		{
			//该帧中，是否已经有执行过一次操作（lock状态）
			if (MouseOperatorLock.instance.isLocked())
				return null;
			if (fetchType != 0)
				//掉落操作进入实行之后，加锁避免该帧内其他操作在之后进行
				MouseOperatorLock.instance.lock();
			if (_isFetching)
			{
				cancelFetch();
			}
			_autoCancel = autoCancel;
			_cursorName = cursorName;
			CursorManager.instance.setCursor(_cursorName);
			if (_autoCancel)
			{
				addDelayFetchFail(); //延迟一帧添加FetchFail监听
			}
			_fetchType = fetchType;
			_parms = parms;
			_isFetching = true;
			_globalDispatcher = new EventDispatcher();
			return _globalDispatcher;
		}

		/**
		 * 注册一个显示对象，当鼠标点击该显示对象时，不会取消拾取状态
		 * @param dispObj
		 *
		 */
		public function registerUnAcceptTarget(dispObj:InteractiveObject):void
		{
			_unAcceptTargetArray.push(dispObj);
		}

		/**
		 * 取消显示对象的注册
		 * @param dispObj
		 *
		 */
		public function unRegisterUnAcceptTarget(dispObj:InteractiveObject):void
		{
			_unAcceptTargetArray.splice(_unAcceptTargetArray.indexOf(dispObj), 1);
		}

		/**
		 *  延迟一帧添加FetchFail监听到stage
		 * 避免第一次click就触发FetchFail
		 *
		 */
		private function addDelayFetchFail():void
		{
			if (!_delayTimer)
			{
				_delayTimer = new Timer(1, 1);
			}
			_delayTimer.addEventListener(TimerEvent.TIMER, onDelayFetchFail); //延迟一帧添加FetchFail监听
			_delayTimer.start();
		}

		/**
		 * 从stage删除 FetchFail监听
		 *
		 */
		private function removeDelayFetchFail():void
		{
			if (_delayTimer && _delayTimer.hasEventListener(TimerEvent.TIMER))
			{
				_delayTimer.removeEventListener(TimerEvent.TIMER, onDelayFetchFail);
			}
			TPUGlobals.stage.removeEventListener(MouseEvent.CLICK, onFetchFail);
		}

		private function onDelayFetchFail(event:Event):void
		{
			_delayTimer.stop();
			_delayTimer.removeEventListener(TimerEvent.TIMER, onDelayFetchFail);
			TPUGlobals.stage.addEventListener(MouseEvent.CLICK, onFetchFail);
		}

		/**
		 *
		 * @param target
		 *
		 */
		public function processFetch(target:DisplayObject):void
		{
			//该帧中，是否已经有执行过一次操作（lock状态）
			if (MouseOperatorLock.instance.isLocked())
				return;
			if (!_isFetching)
				return;
			if (_pause) //暂停状态下
				return;
			if (this.fetchType != 0)
				//掉落操作进入实行之后，加锁避免该帧内其他操作在之后进行
				MouseOperatorLock.instance.lock();
//			dispatchEvent(new FetchEvent(FetchEvent.FETCH, this.fetchType, fetchedItem));
			target.dispatchEvent(new FetchEvent(FetchEvent.FETCH, this.fetchType, _parms));
		}

		/**
		 * 保持提取状态，处理完 FetchEvent.FETCH 如想继续保持提取状态，则需调用此函数
		 *
		 */
		public function keepFetching():void
		{
			if (pause)
				return;
			//先删除onFetchFail事件，下一帧再加回，避免提取状态被撤销
			removeDelayFetchFail();
			addDelayFetchFail();
		}

		private function onFetchFail(event:MouseEvent):void
		{
			if (isUnAcceptTarget(event.target))
			{
				return;
			}
			cancelFetch();
		}

		private function isUnAcceptTarget(dispObj:Object):Boolean
		{
			return _unAcceptTargetArray.indexOf(dispObj) >= 0;
		}

		public function cancelFetch():void
		{
			if (pause)
				pause = false;
			_isFetching = false;
			removeDelayFetchFail();
			CursorManager.instance.removeCursor(_cursorName);
			_globalDispatcher.dispatchEvent(new FetchEvent(FetchEvent.CANCEL, this.fetchType, null));
			MouseStateHolder.instance.cleanOperater();
		}

		/**
		 * 设置暂停状态，暂停状态下鼠标将被还原，并不触发FetchEvent.CANCEL和FetchEvent.FETCH事件
		 * 暂停结束后可以恢复原来状态
		 * @param value
		 *
		 */
		public function set pause(value:Boolean):void
		{
			if (!_isFetching)
				return;
			if (_pause == value)
				return;
			_pause = value;
			if (_pause)
			{
				if (_autoCancel)
				{
					removeDelayFetchFail();
				}
				CursorManager.instance.removeCursor(_cursorName);
			}
			else
			{
				if (_autoCancel)
				{
					addDelayFetchFail();
				}
				CursorManager.instance.setCursor(_cursorName);
			}
		}

		public function get pause():Boolean
		{
			return _pause;
		}

		public function get type():int
		{
			return MouseOperatorType.FETCH;
		}

		public function cancelOperate():void
		{
			this.cancelFetch();
		}

		public function get priority():int
		{
			return MouseOperatePriority.DRAG_DROP;
		}
	}
}
