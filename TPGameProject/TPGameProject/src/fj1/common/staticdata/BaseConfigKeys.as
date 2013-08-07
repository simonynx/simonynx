package fj1.common.staticdata
{

	/**
	 * 客户端初始化配置键
	 * 配置值由BaseConfigManager管理
	 * @author linxun
	 *
	 */
	public class BaseConfigKeys
	{
		//和服务端对应的配置
		public static const VIEW_D_LEVEL_TASK_MONEY:int = 33; //透视D级赏金任务金币
		public static const PK_ENABLE_LEVEL:int = 48; //允许PK切换模式的等级
		public static const SALESROOM_6HPAY:int = 54; //寄售，6小时手续费
		public static const SALESROOM_12HPAY:int = 55; //寄售，12小时手续费
		public static const SALESROOM_24HPAY:int = 56; //寄售，24小时手续费
		public static const PET_ANGER_POINT_MAX:int = 57; //召唤兽怒气最大点数
		public static const PET_ANGER_POINT_ADD_INERVAL:int = 58; //召唤兽怒气最大点数
		public static const SALESROOM_BOUNDAGE_PERCENT:int = 60; //寄售税收千分比
		public static const DROPITEM_MILSEC:int = 69; //掉落物品生命期(毫秒)
		public static const COMBO_HIT_DEMAGE_MAX:int = 71; //连斩伤害点上限值
		public static const COMBO_HIT_DEMAGE_ADDITON:int = 72; //连斩增加伤害点
		public static const COMBO_HIT_DEMAGE_MINUS:int = 73; //连斩递减伤害点
		public static const COMBO_HIT_DELAY_TIME:int = 74; //连斩状态持续时间（秒）
		public static const MAIL_SEND_MAX_NUM:int = 78; //每日可发送的邮件数量
		public static const USE_CHONGLING_ADD_POINT:int = 131; //使用一次宠灵药水增加的资质
		public static const USE_CHONGLING_TIMES:int = 132; //每只宠物可使用的宠灵药水次数
		public static const QILING_BELIEF_TRANSMODUL:int = 143; //每只宠物可使用的宠灵药水次数
		public static const PETFOOD_MAGIC_MODUL:int = 148; //宠物喂养低品质魔石时的魔法力转换系数
		public static const LIVENESS_MAXVAL:int = 156; //活跃度最大值
		public static const VIP_ARCHAEOLOGY_ADD_MANUAL:int = 174; //是vip时寻宝兽增加额外的体力值
		public static const FREE_MASTERY_PROTECT_TIMESPAN:int = 179; //免费保星时间间隔（毫秒）
		public static const CONFIG_UINT32_SHENMO_APPLIER_LIMIT:int = 193; //神魔战场报名人数差值限制
		public static const CONFIG_UINT32_SHENMO_MAX_PERSON:int = 194; //神魔战场最大报名人数
		public static const CONFIG_UINT32_SONGOD_LUCK_ITEM_RATE:int = 199; //太阳神luckItem幸运值加成万分比
		public static const EQUIP_STRENGTHEN_ITEM_SUCCESS_RATE:int = 304; //装备强化幸运符道具成功率
		public static const STATUS_ID_JSZD:int = 311; //状态坚守阵地id
		public static const WS_HP:int = 337; //占星生命系数
		public static const WS_ATK:int = 338; //占星攻击系数
		public static const WS_DEF:int = 339; //占星防御系数

		//前端配置
		public static const FIND_MONSTER_HELP_TIMES:int = 10066; //不是vip可使用的显形术次数
		public static const FIND_MONSTER_HELP_TIMES_VIP:int = 10067; //vip玩家可使用的显形术次数
		public static const MINE_GAME_MONSTER_COUNT:int = 10068; //恶魔扫雷恶魔总数量
		public static const MINE_GAME_PEOPLE_COUNT:int = 10069; //恶魔扫雷平民总数量
		public static const SHOOT_GAME_MAX_TIME:int = 10070; //射击游戏持续时间
		public static const AUTO_ENTER_MINXIANG_TIME:int = 10061; //自动进入冥想检查间隔
		public static const GUILD_BADGE_ICON_ARRAY:int = 10071; //拍卖行可用会标资源
		public static const GUILD_LEVEL_AWORD_ICON:int = 10072; //等级奖励提示图标
		public static const TASK_ALERT_TIME_SPAN:int = 10073; //间隔多久提示一次任务
		public static const IMAGE_GUIDE_ARROW_SHOW_TIME_DELAY:int = 10074; //图片引导窗口下，引导箭头显示的延迟时间
		public static const TASK_ALERT_CLOSE:int = 10075; //间隔多久提示任务窗口关闭
		public static const SHOOT_GAME_BULK_COUNT:int = 10078; //托管射击炮弹个数
		public static const SHOOT_GAME_BULK_SHOOT_DELAY:int = 10079; //托管射击每次射击的延时
		public static const MALL_QUERY_CD:int = 10080; //商城分类查询冷却
		public static const ITEM_TIDYUP_CD:int = 10081; //物品整理CD
		public static const SALESROOM_SALE_MAX:int = 10082; //拍卖行出售物品个数上限
		public static const TEMPLEWAR_WINMARK:int = 10083; //神殿战获胜最高积分
		public static const PICK_UP_ROLL_MAX_TIME:int = 10084; //拾取roll点等待时间上限
		public static const QILING_BELIEF_CHANGE_SPEED:int = 10091; //契灵血量转换速度
		public static const QILING_PROP_ICON_ATK:int = 10092; //契灵加成属性图标ID（攻）
		public static const QILING_PROP_ICON_DEF:int = 10093; //契灵加成属性图标ID（防）
		public static const QILING_PROP_ICON_DEX:int = 10094; //契灵加成属性图标ID（敏）
		public static const QILING_PROP_ICON_VIT:int = 10095; //契灵加成属性图标ID（体）
		public static const QILING_PROP_ICON_TOTAL:int = 10096; //契灵加成属性图标ID（盾）
		public static const DOUSHOUCHANG_TIME:int = 144; //斗兽场时间
		public static const ESOTERICA_PANEL_SHOW_LEVEL:int = 10100; //龙曜宝典弹出等级
		public static const REWARD_TASK_REFRESH_TIME:int = 166; //赏金任务免费刷新的冷却时间
		public static const ANIMATION_PRELOAD:int = 10101; //特效资源预加载列表
		public static const GUILDMESSAGE_MAXLEN:int = 10102; //公会信息最大长度
		public static const RANK_CLEAN_HOUR:int = 10103; //清空排行缓存的时间（小时）
		public static const AUTO_RESET_DELAY_TIME:int = 10106; //自动重铸时多长时间一次
		public static const GUILD_MONEY_NEEDED_CONTRIBUTION:int = 10107; //一点个人贡献度所需的公会捐献资金数
		public static const GAME_LEVEL_TIME:int = 10108; //遊戲等級顯示時間間隔

		public static const MAIN_CARD_IDS:int = 10109; //选角武将id
	}
}
