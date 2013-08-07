package tempest.ui.components.ttree
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	import mx.events.PropertyChangeEvent;

	import tempest.ui.UIConst;
	import tempest.ui.components.IList;

	public class TreeModel extends EventDispatcher
	{
		protected var _childList:IList;
		protected var _data:*;
		protected var _isRoot:Boolean;
		private var _label:String;
		private var _expendMode:String;
		public var dataExtend:int;
		public static const EXPEND_AUTO:String = "auto"; //自动根据当前节点是否有子级，来决定是否可以展开
		public static const EXPEND_FIXED:String = "fixed"; //节点固定为可展开模式

		/**
		 *
		 * @param data
		 * @param childList 子集节点数据源，必须是TreeModel的集合对象
		 * @param isRoot 是否为根节点
		 * @param expendMode 节点展开模式
		 * EXPEND_AUTO : 自动根据当前节点是否有子级，来决定是否可以展开
		 * EXPEND_FIXED : 节点固定为可展开模式
		 * @param Extend  用于节点排序
		 *
		 */
		public function TreeModel(data:*, childList:IList, isRoot:Boolean = false, expendMode:String = EXPEND_AUTO, Extend:int = 0)
		{
			this._data = data;
			setLabel(data);
			this._childList = childList;
			this._isRoot = isRoot;
			_expendMode = expendMode;
			this.dataExtend = Extend;
		}

		public function get expendMode():String
		{
			return _expendMode;
		}

		public function get label():String
		{
			return _label;
		}

		public function set label(value:String):void
		{
			_label = value;
		}

		public function isRoot():Boolean
		{
			return _isRoot;
		}

		public function hasChild():Boolean
		{
			if (!_childList || _childList.length == 0)
				return false;
			else
				return true;
		}

		public function get data():*
		{
			return _data;
		}

		public function set data(value:*):void
		{
			if (_data != value)
			{
				var objEvent:PropertyChangeEvent = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
				objEvent.property = "data";
				objEvent.oldValue = _data;
				objEvent.newValue = value;
				dispatchEvent(objEvent);
				setLabel(data);
			}
		}

		private function setLabel(value:*):void
		{
			if (!value)
			{
				_label = "";
				return;
			}
			if (value.hasOwnProperty("label"))
			{
				_label = value.label;
			}
			else
			{
				_label = value as String;
				if (!_label)
					_label = "";
			}
		}

		public function get childList():IList
		{
			return _childList;
		}

		public function set childList(value:IList):void
		{
			_childList = value;
		}

		public function expendTree():void
		{
			dispatchEvent(new Event("expend"));
		}

		public function dispendTree():void
		{
			dispatchEvent(new Event("dispend"));
		}
	}
}
