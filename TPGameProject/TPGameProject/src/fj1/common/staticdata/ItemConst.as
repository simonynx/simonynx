package fj1.common.staticdata
{
	import fj1.common.res.lan.LanguageManager;

	public class ItemConst
	{
		public static const BAG_ITEM_NUM:int = 180;
		public static const BAG_PAGE_SIZE:int = 60;
		public static const EQUIP_POS_NUM:int = 12;
		public static const CARD_POS_NUM:int = 30;
		public static const CARD_PAGE_SIZE:int = 30;
		public static const DEPOT_PAGE_SIZE:int = 60;
		public static const DEPOT_ITEM_NUM:int = 180;
		public static const DEPOT_INIT_SIZE:int = 30;
		public static const AWORD_DEPOT_PAGE_SIZE:int = 60;
		public static const AWORD_DEPOT_ITEM_NUM:int = 60;
		public static const AWORD_DEPOT_INIT_SIZE:int = 60;
		public static const LUCK_BOX_SIZE:int = 16; //摇奖宝箱中出现物品个数
		public static const ENHANCE_STONE_MAX:int = 3; //强化精通最大放入宝石数
		public static const ITEM_NUM_ALERT_LIMIT:int = 5; //物品到达提示剩余格子数
		public static const MAX_STONE_SLOT_NUM:int = 5; //最大镶嵌宝石数
		//物品Tip显示位置
		public static const TIP_PLACE_DEFAULT:int = 0;
		public static const TIP_PLACE_NPCSHOP:int = 1;
		public static const TIP_PLACE_SHORT_CUT:int = 2;
		public static const ITEM_WORTH:int = 0; //物品价值
		//放置位置枚举
		public static const CONTAINER_DEFAULT:int = 0;
		public static const CONTAINER_BACKPACK:int = CONTAINER_DEFAULT;
		public static const CONTAINER_CARD:int = 1;
		public static const CONTAINER_DEPOT:int = 2;
		//物品分类（背包筛选）
		public static const FILTER_TYPE_NONE:int = 0;
		public static const FILTER_TYPE_OTHER:int = 1; //其他
		public static const FILTER_TYPE_EQUIP:int = 2; //装备
		public static const FILTER_TYPE_PET:int = 3; //宠物
		public static const FILTER_TYPE_TASK:int = 4; //任务
		public static const FILTER_TYPE_DRAG:int = 5; //药品
		//拾取物品类型
		public static const PICKUP_DRUG:int = 1; //药品
		public static const PICKUP_STONE:int = 2; //宝石
		public static const PICKUP_SPELLBOOK:int = 3; //技能书
		public static const PICKUP_PET:int = 4; //契约
		public static const PICKUP_OTHERS:int = 5; //其他
		public static const PICKUP_EQUIP:int = 6; //装备
		public static const PICKUP_MONEY:int = 7; //金币
		//type
		public static const TYPE_MONEY:int = 0; //金币
		public static const TYPE_EQUIP:int = 20; //装备
		public static const TYPE_ITEM_DRUG:int = 1; //药品
		public static const TYPE_ITEM_BACK_TO_CITY:int = 2; //回城卷
		public static const TYPE_ITEM_TASK:int = 3; //任务物品
		public static const TYPE_ITEM_STONE:int = 10; //宝石
		public static const TYPE_ITEM_SPELLBOOK:int = 8; //技能书
		public static const TYPE_ITEM_MAGIC_WARD:int = 9; //魔法阵
		public static const TYPE_ITEM_EGG:int = 11; //蛋
		public static const TYPE_ITEM_REPUTE:int = 12; //声望物品
		public static const TYPE_ITEM_WRAP:int = 13; //礼包
		public static const TYPE_ITEM_PET:int = 14; //宠物喂养魔石
		public static const TYPE_ITEM_PET_SEAL:int = 15; //召唤兽封印
		public static const TYPE_ITEM_HORSE:int = 16; //坐骑物品
		public static const TYPE_MAIL:int = 21; //信件
		public static const TYPE_VIP:int = 22; //VIP
		public static const TYPE_IDENTIFIER:int = 24; //鉴定符
		public static const ItemType_Anima:int = 23; //灵魂碎片
		public static const TYPE_ROCKETCOURIER:int = 25; //火箭速递物品
		public static const TYPE_EQUIP_STONE:int = 30; //装备镶嵌宝石
		public static const TYPE_HEAD_PROTRAIT:int = 31; //头像兑换物品
//		public static const TYPE_ITEM_BOX_KEY:int = 21; //宝箱钥匙
//		public static const TYPE_ITEM_PEN:int = 22; //魔法笔

		public static const ITEM_TEMPLATE_ID_HAMMER:int = 36; //锤子

		//特殊物品
		public static const SUB_TYPE_ROCKETCOURIER:int = 2;
		//鉴定符子类型
		public static const SUB_TYPE_IDENTIFY_GREEN:int = 1; //绿品装备鉴定符
		public static const SUB_TYPE_IDENTIFY_BLUE:int = 2; //蓝品装备鉴定符
		public static const SUB_TYPE_IDENTIFY_PURPLE:int = 3; //紫品装备鉴定符
		public static const SUB_TYPE_IDENTIFY_ORANGE:int = 4; //橙品装备鉴定符
		public static const SUB_TYPE_IDENTIFY_RED:int = 5; //红品装备鉴定符
		public static const SUB_TYPE_IDENTIFY_SUPER:int = 10; //超级装备鉴定符
		//药品子类型 TYPE_ITEM_DRUG
		public static const SUB_TYPE_DRUG_RED:int = 6; //红药
		public static const SUB_TYPE_DRUG_BLUE:int = 7; //蓝药
		public static const SUB_TYPE_DRUG_DEF:int = 10; //防御药
		public static const SUB_TYPE_DRUG_HP:int = 11; //生命药
		public static const SUB_TYPE_DRUG_ATTK:int = 12; //攻击药
		public static const SUB_TYPE_DRUG_POTENTATTK:int = 13; //强效攻击药
		public static const SUB_TYPE_DRUG_DEL:int = 14; //灵巧药
		//炼金术
		public static const SUB_TYPE_DEFEND:int = 10; //加防
		public static const SUB_TYPE_HP:int = 11; //加生命
		public static const SUB_TYPE_ATTACK:int = 12; //加攻
		public static const SUB_TYPE_EXATTACK:int = 13; //强效攻击
		public static const SUB_TYPE_DELICACY:int = 14; //加灵巧
		//VIP子类型
		public static const SUB_TYPE_VIP_NORMAL:int = 1; //普通VIP
		public static const SUB_TYPE_VIP_ADVANCE:int = 2; //至尊VIP
		public static const SUB_TYPE_VIP_LIEF_SURPORT:int = 3; //生活特权
		public static const SUB_TYPE_VIP_BATTLE_SURPORT:int = 4; //战斗特权
		//武器子类型 TYPE_EQUIP
		public static const SUB_TYPE_EQUIP_WEAPON:int = 0; //武器
		public static const SUB_TYPE_EQUIP_CLOTH:int = 1; //衣服
		public static const SUB_TYPE_EQUIP_RING:int = 2; //戒指
		public static const SUB_TYPE_EQUIP_SHOE:int = 3; //鞋子
		public static const SUB_TYPE_EQUIP_WAISTBAND:int = 4; //腰带
		public static const SUB_TYPE_EQUIP_WRISTER:int = 5; //手镯
		public static const SUB_TYPE_EQUIP_NECKLACE:int = 6; //项链
		public static const SUB_TYPE_EQUIP_HELMET:int = 7; //头盔
		public static const SUB_TYPE_EQUIP_MEDAL:int = 8; //勋章
		public static const SUB_TYPE_EQUIP_FASHION:int = 9; //时装
		public static const SUB_TYPE_EQUIP_FASHION_WEAPON:int = 10; //时装武器
		public static const SUB_TYPE_EQUIP_WING:int = 11; //翅膀
		//
		public static const SUB_TYPE_DRUG_EXPEND_BAG:int = 2; //背包扩容
		public static const SUB_TYPE_DRUG_EXPEND_DEPOT:int = 3; //仓库扩容
		public static const SUB_TYPE_DRUG_FIX:int = 4; //修理功能物品
		public static const SUB_TYPE_DRUG_MAGICWATER:int = 5; //修理功能物品
		public static const SUB_TYPE_DRUG_EXPEND_PET:int = 6; //扩充宠物栏
		public static const SUB_TYPE_DRUG_ERUPT:int = 16; //神力爆发物品
		//声望物品子类型 TYPE_ITEM_REPUTE
		public static const SUB_TYPE_DIJING:int = 1; //地精
		public static const SUB_TYPE_SHENMIAO:int = 2; //神庙
		public static const SUB_TYPE_BEIBU:int = 3; //北部
		public static const SUB_TYPE_FASHI:int = 4; //法师
		public static const SUB_TYPE_AIREN:int = 5; //矮人
		public static const SUB_TYPE_JINGLING:int = 6; //精灵
		public static const SUB_TYPE_LONGZU:int = 7; //龙族
		//礼包物品子类型 TYPE_ITEM_WRAP
		public static const SUB_TYPE_WRAP_PACK_HOLDER:int = 1; //自定义礼包
		public static const SUB_TYPE_WRAP_SYSTEM_PACK:int = 2; //系统礼包
		public static const SUB_TYPE_WRAP_LUCKY_BOX:int = 3; //宝箱//气球
		public static const SUB_TYPE_WRAP_LOTTERY_TICKET:int = 4; //彩票物品
		public static const SUB_TYPE_WRAP_KEY:int = 5; //宝箱钥匙
		public static const SUB_TYPE_WRAP_PEN:int = 6; //魔法笔
		public static const SUB_TYPE_SHOOT_GAME_REWARD:int = 7; //射击游戏奖品
		public static const FLAG_1_WRAP_USER_SELECT:int = 1; //系统自选礼包类型
		public static const FLAG_1_WRAP_DEFAULT:int = 0; //系统默认礼包类型
		//坐骑物品子类型
		public static const ItemType_Horse_EGG:int = 1; //坐骑蛋			(fj1_horse_template的id配置在flag_1)
		public static const ItemType_Horse_MagicCard:int = 2; //坐骑幻化卡		(fj1_horse_template的id配置在flag_1)
		public static const ItemType_Horse_FOOD:int = 3; //坐骑食物
		//装备附加属性点类型
		public static const POINT_TYPE_ATTACT:int = 0;
		public static const POINT_TYPE_DEFENSE:int = 1;
		public static const POINT_TYPE_AGILTY:int = 2;
		public static const POINT_TYPE_BODY:int = 3;
		//装备灵魂等级上限
		public static const MAX_SOUL_LEVEL:int = 5;
		public static const MAX_EXTRAPOINT_NUM:int = 5; //装备附加属性个数上限
		//
		public static const TASK_ID_SET_DRUG:int = 71; //该任务可接时，将设置获得的药水到快捷栏
		//射击游戏
		public static const SHOOT_YELLOW_BALLON:int = 1828;
		public static const SHOOT_BLUE_BALLON:int = 1829;
		public static const SHOOT_RED_BALLON:int = 1830;
		//
		public static const SHOOT_COPPER_BULLET:int = 7;
		public static const SHOOT_SILVER_BULLET:int = 8;
		public static const SHOOT_GOLD_BULLET:int = 9;
		//拾取类别
		public static const DROP_ITEM_DRUG:int = 1; //药品
		public static const DROP_ITEM_STONE:int = 2; //宝石
		public static const DROP_ITEM_SKILL_BOOK:int = 3; //技能书
		public static const DROP_ITEM_PET:int = 4; //契约
		public static const DROP_ITEM_OTHER:int = 5; //其他
		public static const DROP_ITEM_EQUIP:int = 6; //装备
		public static const DROP_ITEM_MONEY:int = 7; //金币

		public static function getEquipSubTypeName(subType:int):String
		{
			switch (subType)
			{
				case SUB_TYPE_EQUIP_WEAPON:
					return LanguageManager.translate(2041, "武器");
				case SUB_TYPE_EQUIP_CLOTH:
					return LanguageManager.translate(2042, "胸甲");
				case SUB_TYPE_EQUIP_RING:
					return LanguageManager.translate(2043, "戒指");
				case SUB_TYPE_EQUIP_SHOE:
					return LanguageManager.translate(2044, "鞋子");
				case SUB_TYPE_EQUIP_WAISTBAND:
					return LanguageManager.translate(2045, "腰带");
				case SUB_TYPE_EQUIP_WRISTER:
					return LanguageManager.translate(2046, "护手");
				case SUB_TYPE_EQUIP_NECKLACE:
					return LanguageManager.translate(2047, "项链");
				case SUB_TYPE_EQUIP_HELMET:
					return LanguageManager.translate(2048, "头盔");
				case SUB_TYPE_EQUIP_MEDAL:
					return LanguageManager.translate(2049, "饰品");
				case SUB_TYPE_EQUIP_FASHION:
					return LanguageManager.translate(81401, "时装");
				case SUB_TYPE_EQUIP_FASHION_WEAPON:
					return LanguageManager.translate(81402, "时装武器");
				case SUB_TYPE_EQUIP_WING:
					return LanguageManager.translate(81403, "翅膀");
				default:
					return "";
			}
		}
		//人物属性标识枚举
		public static const ATTACK:int = 0; //攻击
		public static const ATTACK_POINT:int = 1; //攻属性点
		public static const DEFENSE:int = 2; //防御
		public static const DEFENSE_POINT:int = 3; //防属性点
		public static const DELICACY:int = 4; //灵巧
		public static const DELICACY_POINT:int = 5; //敏属性点
		public static const HAYMAKER:int = 6; //暴击
		public static const BODY_POINT:int = 7; //体属性点
		public static const MOVESPEED:int = 8; //移动速度
		public static const ADD_MAXHP:int = 9; //生命最大值
		public static const ADD_MAXMP:int = 10; //魔法最大值
		public static const BROKEN:int = 11; //破甲
		public static const MISS:int = 12; //免暴

		//附加属性
		public static function getAttributeStr(type:int):String
		{
			switch (type)
			{
				case ATTACK:
					return LanguageManager.translate(2001, "攻击 +");
					break;
				case ATTACK_POINT:
					return LanguageManager.translate(2012, "攻属性点 +");
					break;
				case DEFENSE:
					return LanguageManager.translate(2003, "防御 +");
					break;
				case DEFENSE_POINT:
					return LanguageManager.translate(2013, "防属性点 +");
					break;
				case DELICACY:
					return LanguageManager.translate(2005, "灵巧 +");
					break;
				case DELICACY_POINT:
					return LanguageManager.translate(2014, "敏属性点 +");
					break;
				case HAYMAKER:
					return LanguageManager.translate(2007, "暴击 +");
					break;
				case BODY_POINT:
					return LanguageManager.translate(2015, "体属性点 +");
					break;
				case MOVESPEED:
					return LanguageManager.translate(2009, "移动速度 +");
					break;
				case ADD_MAXHP:
					return LanguageManager.translate(2010, "生命最大值 +");
					break;
				case ADD_MAXMP:
					return LanguageManager.translate(2011, "魔法最大值 +");
					break;
				default:
					return "";
			}
		}

		/**
		 * 根据装备的subtype判断装备是否为时装
		 * @param subType
		 * @return
		 *
		 */
		public static function isFashionCloth(subtype:int):Boolean
		{
			return subtype == ItemConst.SUB_TYPE_EQUIP_FASHION || subtype == ItemConst.SUB_TYPE_EQUIP_FASHION_WEAPON || subtype == ItemConst.SUB_TYPE_EQUIP_WING;
		}
	}
}
