package fj1.modules.newmail.model.vo
{

	[Bindable]
	public class MailInfo
	{
		public var guid:int;
		public var senderName:String; //发送者名字
		public var title:String; //邮箱标题
		public var sendContent:String = ""; //发送的内容
		public var ownTime:int; //剩余时间
		public var sendTime:String; //发送时间
		public var readState:int; //读取状态
		public var mailIcon:int; //图标
		public var sendMoney:int; //邮寄的金钱
		public var sendMoJin:int; //魔金
		public var sendStone:int; //邮寄的魔石
		public var kind:int; //邮件类型
		public var checcked:int; //是否选中
		public var itemArr:Array = []; //物品数组
		static public const MAIL_CHECKED:int = 1; //选中
		static public const MAIL_UNCHECKED:int = 0; //未选中
		static public const MAIL_ICON_TEXT:int = 0; //全文本图标
		static public const MAIL_ICON_MONEY:int = 1; //只有金钱图标
		static public const MAIL_ICON_ITEM:int = 2; //有物品图标
		static public const STATE_READ:int = 1; //读取
		static public const STATE_UNREAD:int = 0; //未读取
		static public const MAIL_PERSONAL:int = 0; //个人邮件
		static public const MAIL_SYSTEM:int = 1; //系统邮件
		static public const MAIL_SALE_BUY:int = 4; //寄售系统（买到物品）
		static public const MAIL_SALE_FAIL:int = 3; //寄售系统（寄售失败，回退物品）
		static public const MAIL_SALE_SUCCESS:int = 2; //寄售系统（寄售成功，获得收益）
		static public const MAIL_MAGICWARD:int = 5; //给魔法创建者收益
		static public const MAIL_GUILD:int = 6; //公会邮件
		static public const MAIL_GUILD_WAR:int = 7; //公会战邮件
		static public const MAIL_TEAM:int = 8; //公会战邮件
		static public const MAIL_TOWER:int = 9; //试练塔邮件
		static public const MAIL_MARKET:int = 10; //信仰力交易所购买邮件
		static public const MAIL_MARKET_SELL:int = 11; //信仰力交易所出售邮件
		static public const MAIL_MARKET_BACK:int = 12; //信仰力交易所取消出售邮件
		static public const MAIL_EXPLORATION_POINT:int = 13; //探索积分奖励
		static public const MAIL_EXPLORATION_RANK:int = 14; //探索排行奖励
		static public const MAIL_EXPLORATION_PRIZE:int = 15; //探索赠送奖励
		static public const POSTAGE:uint = 100; //邮费
		static public const MAIL_LEVEL:uint = 10; //使用邮件的等级
		static public const MAIL_MAX_DAY:uint = 15; //邮件存在最大天数
		static public const MAIL_WATCHSTAR:uint = 16; //占星获得奖励
		static public const MailSort_ShenMoHort:uint = 17; //神魔战场奖励
		static public const MailSort_ZaGuanZi:uint = 18; //砸罐子奖励
		static public const MAIL_SHENMOTOUPIAO:uint = 19; //神魔投票
		static public const MAIL_PK_TAOTAISAI:uint = 20; //PK淘汰赛
		static public const MAIL_PK_JUESAI:uint = 21; //PK决赛

		public function MailInfo()
		{
		}
	}
}
