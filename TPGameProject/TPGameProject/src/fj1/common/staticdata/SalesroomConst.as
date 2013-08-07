package fj1.common.staticdata
{

	public class SalesroomConst
	{
		/**********************商品查询类型**********************/
		public static const RESULT_TYPE_ALL_SALE:int = 1; //所有商品
		public static const RESULT_TYPE_MY_SALE:int = 2; //自己的商品
		public static const RESULT_TYPE_TRADE_SALE:int = 3; //查询交易市场所有交易
		public static const RESULT_TYPE_TRADE_OWN:int = 4; //查询交易市场自己的交易
		/*********************商品分类主类型*********************/
		public static const SORT_WEAPON:int = 1; //武器
		public static const SORT_DEFEND:int = 2; //防具
		public static const SORT_PET:int = 3; //宠物
		public static const SORT_RIDE:int = 4; //坐骑
		public static const SORT_STONE:int = 5; //宝石
		public static const SORT_MEDICINE:int = 6; //药品
		public static const SORT_OTHER:int = 7; //其他
		public static const SORT_SKILL_BOOK:int = 8; //技能书
		public static const GT_BELIEFTRADE:int = 9; //信仰力罐
		public static const GT_BELIEFTRADE2:int = 10; //信仰力罐(拍卖行)
		/**
		 * 系统出售
		 */
		public static const GT_BELIEFTRADE_SYS:int = 101;
		/**
		 * 玩家出售
		 */
		public static const GT_BELIEFTRADE_PLAYER:int = 102;
		/*********************商品分类子类型*********************/
		//武器子类型
		public static const SUB_SORT_WST_SWORD:int = 1; //大剑
		public static const SUB_SORT_WST_STAFF:int = 2; //长杖
		public static const SUB_SORT_WST_SHORT_STAFF:int = 3; //短杖
		public static const SUB_SORT_WST_TELSON:int = 4; //刺
		//装备子类型
		public static const SUB_SORT_DST_BODY:int = 5; //胸甲
		public static const SUB_SORT_DST_FINGER:int = 6; //戒指
		public static const SUB_SORT_DST_FEET:int = 7; //鞋子
		public static const SUB_SORT_DST_WAIST:int = 8; //腰带
		public static const SUB_SORT_DST_HAND:int = 9; //护手
		public static const SUB_SORT_DST_NECK:int = 10; //项链
		public static const SUB_SORT_DST_ARMET:int = 11; //头盔
		public static const SUB_SORT_DST_MEDAL:int = 12; //勋章
		//宠物子类型
		public static const SUB_SORT_PST_EGG:int = 13; //未孵化
		public static const SUB_SORT_PST_BECOME_EGG:int = 14; //孵化后又被封印成蛋
		//宝石子类型
		public static const SUB_SORT_SST_MAGIC:int = 15; //魔法晶核
		public static const SUB_SORT_SST_SKILLFUL:int = 16; //精通宝石
		public static const SUB_SORT_SST_GODHOOD:int = 17; //神格宝石
		//药水子类型
		public static const SUB_SORT_MST_NORMAL:int = 18; //普通药剂
		public static const SUB_SORT_MST_BATTLE:int = 19; //战斗药剂
		//其他
		public static const SUB_SORT_OTHER:int = 20;
		//技能书子类型
		public static const SUB_SORT_SKT_GLADIATOR:int = 21; //角斗士技能书
		public static const SUB_SORT_SKT_DARKMAGE:int = 22; //暗法师技能书
		public static const SUB_SORT_SKT_LUNA:int = 23; //月神使技能书
		public static const SUB_SORT_SKT_AVENGER:int = 24; //复仇者技能书
		//坐骑
		public static const SUB_SORT_RIDE:int = 25;
		//信仰力市场
		public static const ST_BELIEFTRADE_SMALL:int = 26; //小信仰力罐
		public static const ST_BELIEFTRADE_MIDDLE:int = 27; //中信仰力罐
		public static const ST_BELIEFTRADE_BIG:int = 28; //大信仰力罐
		//拍卖行中的信仰力罐
		public static const ST_BELIEFTRADE_SMALL2:int = 29; //大信仰力罐
		public static const ST_BELIEFTRADE_MIDDLE2:int = 30; //中信仰力罐
		public static const ST_BELIEFTRADE_BIG2:int = 31; //大信仰力罐
		/***********************商品等级类型**********************/
		public static const LEVEL_TYPE_1:int = 1; //1 - 9
		public static const LEVEL_TYPE_2:int = 2; //10 - 19
		public static const LEVEL_TYPE_3:int = 3; //20 - 29
		public static const LEVEL_TYPE_4:int = 4; //30 - 39
		public static const LEVEL_TYPE_5:int = 5; //40 - 49
		public static const LEVEL_TYPE_6:int = 6; //50 - 59
		public static const LEVEL_TYPE_7:int = 7; //60 - 69
		public static const LEVEL_TYPE_8:int = 8; //70 - 79
		/***********************商品职业类型**********************/
		public static const PROFESSION_TYPE_GLADIATOR:int = 1; //角斗士 
		public static const PROFESSION_TYPE_DARKMAGE:int = 2; //暗法师
		public static const PROFESSION_TYPE_LUNA:int = 3; //月神使
		public static const PROFESSION_TYPE_AVENGER:int = 4; //复仇者
		/***********************商品品质类型**********************/
		public static const QULITY_TYPE_WHITE:int = 1; //普通以上
		public static const QULITY_TYPE_GREEN:int = 2; //优秀以上
		public static const QULITY_TYPE_BLUE:int = 3; //精良以上
		public static const QULITY_TYPE_PURPLE:int = 4; //史诗以上
		public static const QULITY_TYPE_ORANGE:int = 5; //传说以上
	}
}
