package fj1.modules.friend.model.vo
{
	import fj1.modules.friend.interfaces.IEntity;

	[Bindable]
	public class BlackInfo implements IEntity
	{
		public var name:String;
		public var level:int;
		public var online:Boolean;
		private var _id:int;
		public var isCouple:Boolean;
		static public const BLACK_MAX:int = 100; //好友最大人数

		public function BlackInfo(name:String, level:int, online:Boolean, guid:int, isCouple:Boolean = false)
		{
			this.name = name;
			this.level = level;
			this.online = online;
			this.id = guid;
			this.isCouple = isCouple;
		}


		public function set id(value:int):void
		{
			_id = value;
		}

		public function get id():int
		{
			return _id;
		}

	}
}
