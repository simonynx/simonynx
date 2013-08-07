package fj1.modules.friend.model.vo
{
	import fj1.modules.friend.interfaces.IEntity;

	[Bindable]
	public class EnemyInfo implements IEntity
	{
		private var _id:int;
		public var name:String;
		public var level:int;
		public var profession:int;
		public var killTime:int;
		public var online:Boolean;
		public static const ENEMY_MAX:int = 100;

		public function EnemyInfo(id:int, name:String, level:int, profession:int, killTime:int, online:Boolean)
		{
			this.id = id;
			this.name = name;
			this.level = level;
			this.profession = profession;
			this.killTime = killTime;
			this.online = online;
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
