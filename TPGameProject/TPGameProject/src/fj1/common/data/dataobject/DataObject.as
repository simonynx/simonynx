package fj1.common.data.dataobject
{
	import fj1.common.data.interfaces.IDataObject;
	import fj1.common.staticdata.DataObjectType;
	import flash.events.EventDispatcher;


	public class DataObject extends EventDispatcher implements IDataObject
	{
		private var _guId:uint = 0;
		[Bindable]
		private var _name:String;
		[Bindable]
		public var cdRatio:Number = 0;

		public function DataObject(guId:uint)
		{
			_guId = guId;
		}

		public function get guId():uint
		{
			return _guId;
		}

		public function set guId(value:uint):void
		{
			_guId = value;
		}

		public function get typeId():uint
		{
			return DataObjectType.UNKNOWN;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get templateId():int
		{
			return 0;
		}
	}
}
