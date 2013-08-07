package fj1.common.helper
{
	import fj1.common.data.dataobject.DataObject;
	import fj1.common.staticdata.ObjectUpdateConst;

	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	import mx.core.IFactory;

	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.utils.AttributeManager;

	public class ObjectCreateHelper
	{
		private static const log:ILogger = TLog.getLogger(ObjectCreateHelper);
		private static var conditionIdIndexDic:Dictionary = new Dictionary(); //class和模板id之间的映射集合

		/**
		 * 获取模板ID
		 * @param props 索引-属性值列表
		 * @param templateProperty
		 * @param objClass
		 * @return
		 *
		 */
		public static function getTemplateId(props:Array, templateProperty:String, objClass:Class):int
		{
			var propIndex:int = getAttrIndex(objClass, templateProperty, ObjectUpdateConst.REPLACE);
			//取出模板id
			var templateId:int = findProperty(props, propIndex) as int;
			return templateId;
		}

		private static function getAttrIndex(objClass:Class, attrName:String, replace:Object = null):int
		{
			var propIndex:int = conditionIdIndexDic[objClass];
			if (!propIndex)
			{
				propIndex = AttributeManager.getAttrIndex(objClass, attrName, replace);
				conditionIdIndexDic[objClass] = propIndex;
			}
			return propIndex;
		}

		/**
		 * 查找属性列表中的某属性
		 * @param props
		 * @param index
		 * @return
		 *
		 */
		public static function findProperty(props:Array, index:int):Object
		{
			for each (var prop:Object in props)
			{
				if (prop.index == index)
				{
					return prop.value;
				}
			}
			return null;
		}

		/**
		 * 更新对象
		 * @param obj
		 * @param props
		 * @param collectEvent 是否搜集变更事件, 在变更完成后集中抛出
		 *
		 */
		public static function updateObj(obj:*, props:Array, collectEvent:Boolean = false):void
		{
			if (collectEvent)
			{
				//搜集属性变更事件
				var updateWatcher:ObjectUpdateWatcher;
				if (obj is EventDispatcher && props.length > 0)
				{
					updateWatcher = new ObjectUpdateWatcher(EventDispatcher(obj));
				}
				updateProps(obj, props);
				if (updateWatcher)
				{
					updateWatcher.complete(); //抛出
				}
			}
			else
			{
				updateProps(obj, props);
			}
		}

		private static function updateProps(obj:*, props:Array):void
		{
			for (var i:int = 0; i != props.length; i++)
			{
				AttributeManager.update(obj, props[i].index, props[i].value, ObjectUpdateConst.REPLACE);
			}
		}
	}
}
import fj1.common.events.ObjectUpdateEvent;
import flash.events.EventDispatcher;
import mx.events.PropertyChangeEvent;

class ObjectUpdateWatcher
{
	private var eventList:Array;
	private var _target:EventDispatcher

	public function ObjectUpdateWatcher(target:EventDispatcher)
	{
		eventList = [];
		//搜集属性变更事件
		_target = target;
		if (_target)
			_target.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onPropertyChange);
	}

	private function onPropertyChange(event:PropertyChangeEvent):void
	{
		eventList.push(event);
	}

	public function complete():void
	{
		if (!_target)
			return;
		//抛出搜集的事件
		if (eventList.length > 0)
		{
			_target.dispatchEvent(new ObjectUpdateEvent(ObjectUpdateEvent.UPDATE, eventList));
		}
		_target.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onPropertyChange);
	}
}
