package fj1.common
{
	import fj1.modules.login.model.vo.RoleInfo;

	public class GameConfig
	{
		/**---帐号相关---*/
		public static var sessionKey:String = "";
		/**---服务器相关---*/
		public static var currentLine:int = 0; //当前线路
		public static var currentCharacter_guid:int = 0; //当前选择角色GUID
		public static var selectRole:RoleInfo;

		public function GameConfig()
		{
		}
	}
}
