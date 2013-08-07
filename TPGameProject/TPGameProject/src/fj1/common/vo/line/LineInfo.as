package fj1.common.vo.line
{
	import fj1.common.res.lan.LanguageManager;

	public class LineInfo
	{
		public static const PVP:int = 0;
		public static const PVE:int = 1;
		public var id:int;
		public var name:String;
		public var host:String;
		public var port:int;
		public var state:int;
		public var type:int = 0;

		public function get alertStr():String
		{
			if (type == PVE)
			{
				return LanguageManager.translate(45010, "你当前选择的是天堂模式(PVE)线路，该服务器游戏过程中你将不会受到来自其他玩家的攻击。是否继续？");
			}
			else
			{
				return LanguageManager.translate(45009, "你当前选择的是地狱模式(PVP)线路，该服务器游戏过程中你将可能受到来自其他玩家的攻击。是否继续？");
			}
		}
	}
}
