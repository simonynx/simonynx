package tempest.ui
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.Dictionary;

	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.common.staticdata.CursorPriority;
	import tempest.common.staticdata.CursorType;

	/**
	 * 按优先级管理光标
	 * 相同优先级的光标，设置后会替换旧的
	 * 不同优先级的光标可以同时存在，优先显示优先级高的
	 * @author linxun
	 *
	 */
	public class CursorManager
	{
		private static var log:ILogger = TLog.getLogger(CursorManager);
		private static var _instance:CursorManager;
		private var _current:TCursor = null;
		private var _container:DisplayObjectContainer = null;
		private var _cursors:Dictionary = new Dictionary(); //配置的按名称索引的光标列表
		private var _priorityCursors:Dictionary = new Dictionary(); //按照权限索引的当前光标列表
		private static var defaultCursor:TCursor;

		public function CursorManager()
		{
			if (_instance)
				throw new Error("该类只能有一个实例");
			_instance = this;
			defaultCursor = new TCursor(_container, "default", null, 0, 0, CursorPriority.DEFAULT);
		}

		public static function get instance():CursorManager
		{
			if (_instance == null)
				new CursorManager();
			return _instance;
		}

		public function register(container:DisplayObjectContainer):void
		{
			if ((_container = container))
			{
				_container.addEventListener(MouseEvent.MOUSE_MOVE, onCursorMoveHandler, false, 0, true);
			}
//				_container.addEventListener(Event.ENTER_FRAME,onCursorMoveHandler,false,0,true);
		}

		public function registerCursor(name:String, cousor:*, xOffset:Number = 0, yOffset:Number = 0, priority:int = CursorPriority.NORMAL, type:int = CursorType.HIDE_MOUSE):void
		{
			if (!(cousor is DisplayObject))
			{
				var bitmapData:BitmapData = cousor as BitmapData;
				if (bitmapData)
				{
					cousor = new Bitmap(bitmapData);
				}
				else
				{
					log.error("CursorManager.registerCursor()资源类型错误！name = " + name);
					cousor = null;
				}
			}
			_cursors[name] = new TCursor(_container, name, cousor, xOffset, yOffset, priority, type);
		}

		/**
		 * 获取注册的光标的显示对象
		 * @param name
		 * @return
		 *
		 */
		public function getRegistedCursorSprite(name:String):DisplayObject
		{
			return TCursor(_cursors[name]).sprite;
		}

		public function showCousor():void
		{
			if (_current)
				_current.show();
			else
				Mouse.show();
		}

		public function hideCursor():void
		{
			if (_current)
				_current.hide();
			else
				Mouse.hide();
		}

		/**
		 * 设置光标（只会替换同优先级的光标）
		 * @param name
		 *
		 */
		public function setCursor(name:String):DisplayObject
		{
			if (name == "default")
			{
				setDefaultCursor();
				return null;
			}
			else
			{
				var cursor:TCursor = _cursors[name];
				setPriorityCursors(cursor);
				return cursor.sprite;
			}
		}

		/**
		 * 在当前光标列表中，查找包含该名字的光标
		 * @return
		 *
		 */
		public function getCursorFromPriorityList(name:String):TCursor
		{
			return _priorityCursors[name];
		}

		/**
		 * 设置临时光标（只会替换同优先级的光标）
		 * @param name
		 *
		 */
		public function setTempCursor(cousor:DisplayObject, xOffset:Number = 0, yOffset:Number = 0, priority:int = CursorPriority.NORMAL):void
		{
			var cursor:TCursor = new TCursor(_container, "temp", cousor, xOffset, yOffset, priority);
			setPriorityCursors(cursor);
		}

		/**
		 * 将光标设置为默认光标（会替换优先级为0的光标）
		 *
		 */
		public function setDefaultCursor():void
		{
			setPriorityCursors(defaultCursor);
		}

		/**
		 * 移除光标 （按优先级移除）
		 * @param name
		 *
		 */
		public function removeCursor(name:String):void
		{
			if (hasCursor(name))
				removeCursor2((_cursors[name] as TCursor).priority);
		}

		/**
		 *是否存在手势
		 * @param name
		 * @return
		 *
		 */
		public function hasCursor(name:String):Boolean
		{
			if (_cursors[name])
				return true;
			return false;
		}

		/**
		 * 按优先级移除光标
		 * @param priority
		 *
		 */
		public function removeCursor2(priority:int):void
		{
			delete _priorityCursors[priority];
			//设置当前最高优先级的光标
			var highestCursor:TCursor = getHighestPriorityCursor();
			setCurrent(highestCursor);
		}

		/**
		 *删除所有鼠标手型
		 *
		 */
		public function removeAllCursor():void
		{
			var cursors:Array = [];
			var cursor:TCursor;
			for each (cursor in _priorityCursors)
			{
				cursors.push(cursor);
			}
			for each (cursor in cursors)
			{
				removeCursor2(cursor.priority);
			}
		}

		/**
		 * 将光标设置为默认光标（会替换优先级为0的光标）
		 *
		 */
		public function removeDefaultCursor():void
		{
			removeCursor2(CursorPriority.DEFAULT);
		}

		private function setPriorityCursors(cur:TCursor):void
		{
			var oldCursor:TCursor = _priorityCursors[cur.priority] as TCursor;
			if (oldCursor == cur)
				return;
			_priorityCursors[cur.priority] = cur;
			//设置当前最高优先级的光标
			var highestCursor:TCursor = getHighestPriorityCursor();
			setCurrent(highestCursor);
		}

		/**
		 * 获取当前优先级最高的光标
		 * @return
		 *
		 */
		private function getHighestPriorityCursor():TCursor
		{
			var maxPriority:int = -1;
			var ret:TCursor;
			for each (var cur:TCursor in _priorityCursors)
			{
				if (cur.priority > maxPriority)
				{
					ret = cur;
					maxPriority = cur.priority;
				}
			}
			return ret;
		}

		private function setCurrent(cur:TCursor):void
		{
			if (_container == null || _current == cur)
				return;
			removeCurrent();
			_current = cur;
			if (!_current)
			{
				Mouse.show();
			}
			else
			{
				_current.show();
			}
		}

		private function onCursorMoveHandler(e:MouseEvent):void
		{
			if (_current && _current.name != "default")
			{
//				_current.move(e.localX, e.localY);
				_current.move(_container.mouseX, _container.mouseY);
//				e.updateAfterEvent();
//				Mouse.hide();//右键
			}
		}

//		/**
//		 * 暂时将自定义鼠标隐藏/或复原 
//		 * @param value
//		 * 
//		 */		
//		public function set defaultCursorOnly(value:Boolean):void
//		{
//			setCurrent(value ? null : getHighestPriorityCursor());
//		}
		private function removeCurrent():void
		{
			if (_current)
			{
				if (_current.name != "default")
				{
					_current.hide();
				}
				_current = null;
			}
		}
	}
}
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.ui.Mouse;
import tempest.common.staticdata.CursorPriority;
import tempest.common.staticdata.CursorType;
import tempest.utils.Fun;

class TCursor
{
	private var _name:String;
	private var _sprite:DisplayObject;
	private var _xOffset:Number;
	private var _yOffset:Number;
	private var _priority:int;
	private var _type:int;
	private var _container:DisplayObjectContainer;

	public function TCursor(container:DisplayObjectContainer, name:String, cousor:DisplayObject, xOffset:Number = 0, yOffset:Number = 0, priority:int = 0, type:int = CursorType.HIDE_MOUSE)
	{
		_name = name;
		_sprite = cousor;
		_xOffset = xOffset;
		_yOffset = yOffset;
		_priority = priority;
		_type = type;
		_container = container;
		if (this._sprite is DisplayObjectContainer)
		{
			var dispCursor:DisplayObjectContainer = this._sprite as DisplayObjectContainer;
			dispCursor.mouseEnabled = dispCursor.mouseChildren = false;
		}
	}

	public function show():void
	{
		if (_name == "default")
		{
			Mouse.show();
		}
		else
		{
			_container.addChild(this._sprite);
			move(this._sprite.stage.mouseX, this._sprite.stage.mouseY);
			if (this._sprite is MovieClip)
				MovieClip(this._sprite).gotoAndPlay(1);
			if (_type == CursorType.HIDE_MOUSE)
			{
				Mouse.hide();
			}
			else if (_type == CursorType.SHOW_MOUSE)
			{
				Mouse.show();
			}
		}
	}

	public function hide():void
	{
		if (_name == "default")
		{
			Mouse.hide();
		}
		else
		{
			_container.removeChild(this._sprite);
			if (this._sprite is MovieClip)
			{
				Fun.stopMC(this._sprite);
			}
			if (_type == CursorType.HIDE_MOUSE)
			{
				Mouse.show();
			}
			else if (_type == CursorType.SHOW_MOUSE)
			{
				Mouse.hide();
			}
		}
	}

	public function get name():String
	{
		return _name;
	}

	public function get priority():int
	{
		return _priority;
	}

	public function move(x:Number, y:Number):void
	{
		if (_type == CursorType.HIDE_MOUSE)
		{
			_sprite.x = x + _xOffset;
			_sprite.y = y + _yOffset;
		}
		else if (_type == CursorType.SHOW_MOUSE)
		{
			_sprite.x = x + _xOffset + 5;
			_sprite.y = y + _yOffset - 30;
		}
	}

	public function get sprite():DisplayObject
	{
		return _sprite;
	}
}
