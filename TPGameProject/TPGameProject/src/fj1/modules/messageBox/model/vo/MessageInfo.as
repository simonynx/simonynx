package fj1.modules.messageBox.model.vo
{

	[Bindable]
	public class MessageInfo
	{
		public var id:int;
		public var name:String;
		public var kind:int;
		public var messageStr:String;
		public var agreeFun:Function;
		public var disagreeFun:Function;
		public var teamName:String;
		public var guildID:int; //公会id
		static public const MESSAGE_KIND_FRIEND:int = 0; //好友
		static public const MESSAGE_KIND_TEAM:int = 1; //队伍
		static public const MESSAGE_KIND_TRADE:int = 2; //交易
		static public const MESSAGE_KIND_SKILL:int = 3; //技能
		static public const MESSAGE_KIND_POINT:int = 4; //属性
		static public const MESSAGE_KIND_GUILD:int = 5; //公会
		static public const MESSAGE_ALL_AGREE:int = 0; //全部接受
		static public const MESSAGE_ALL_DISAGREE:int = 1; //全部拒绝

		public function MessageInfo(guid:int, name:String, kind:int, messageStr:String, agreeFun:Function = null, disagreeFun:Function = null, teamName:String = "", guildID:int = 0)
		{
			this.id = guid;
			this.name = name;
			this.kind = kind;
			this.messageStr = messageStr;
			this.agreeFun = agreeFun;
			this.disagreeFun = disagreeFun;
			this.teamName = teamName;
			this.guildID = guildID;
		}
	}
}
