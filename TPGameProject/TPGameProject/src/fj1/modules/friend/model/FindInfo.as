package fj1.modules.friend.model
{

	[Bindable]
	public class FindInfo
	{
		public var guid:int;
		public var name:String;
		public var level:int;
		public var profession:int;
		public var online:int;
		public var power:uint;

		public function FindInfo(guid:int, name:String, level:int, profession:int, online:int, power:uint)
		{
			this.guid = guid;
			this.name = name;
			this.level = level;
			this.profession = profession;
			this.online = online;
			this.power = power;
		}
	}
}
