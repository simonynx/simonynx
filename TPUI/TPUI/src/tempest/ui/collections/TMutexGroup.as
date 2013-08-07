package tempest.ui.collections
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**
	 * 容器组件，实现一个父级上的多个显示对象之间的切换
	 * @author linxun
	 *
	 */
	public class TMutexGroup
	{
		private var _parent:DisplayObjectContainer;
		private var _current:DisplayObject;
		private var _objList:Vector.<DisplayObject>;
		private var _currentIndex:int = -1;

		/**
		 * 容器组件，实现一个父级上的多个显示对象之间的切换
		 * @param parent 显示对象要添加到的父级
		 * @param objArray 用于切换的显示对象列表
		 *
		 */
		public function TMutexGroup(parent:DisplayObjectContainer, objArray:Array = null)
		{
			_parent = parent;
			_objList = new Vector.<DisplayObject>();

			if (objArray)
			{
				for (var i:int = 0; i < objArray.length; i++)
				{
					var element:DisplayObject = objArray[i] as DisplayObject;
					add(element);
				}
			}
		}

		public function get objList():Vector.<DisplayObject>
		{
			return _objList;
		}

		/**
		 * 添加一个显示对象
		 * 显示对象将被从原来的父级上移除
		 * @param obj
		 *
		 */
		public function add(obj:DisplayObject):void
		{
			if (obj.parent)
			{
				obj.parent.removeChild(obj);
			}
			_objList.push(obj);
		}

		/**
		 * 当前显示的显示对象的索引
		 * 修改该属性实现显示对象之间的切换
		 * @param value
		 *
		 */
		public function set currentIndex(value:int):void
		{
			if (value < _objList.length && value >= 0)
			{
				current = _objList[value];
			}
			else
			{
				current = null;
			}
		}

		public function get currentIndex():int
		{
			return _currentIndex;
		}

		/**
		 * 当前被添加到父级的显示对象
		 * 修改该属性实现显示对象之间的切换
		 * @param obj
		 *
		 */
		public function set current(obj:DisplayObject):void
		{
			if (!obj)
			{
				if (_current && _current.parent)
				{
					_parent.removeChild(_current);
				}
				_current = null;
				_currentIndex = -1;
			}

			for (var i:int = 0; i < _objList.length; i++)
			{
				var element:DisplayObject = _objList[i] as DisplayObject;
				if (element == obj)
				{
					if (_current && _current.parent)
					{
						_parent.removeChild(_current);
					}
					_current = obj;
					_currentIndex = i;
					_parent.addChild(_current);
					break;
				}
			}
		}

		public function get current():DisplayObject
		{
			return _current;
		}

	}
}
