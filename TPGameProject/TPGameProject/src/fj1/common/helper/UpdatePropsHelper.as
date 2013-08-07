package fj1.common.helper
{
	import fj1.common.staticdata.ObjectUpdateConst;
	import flash.utils.ByteArray;
	import tempest.common.net.vo.TPacketIn;
	import tempest.utils.AttributeManager;
	import tempest.utils.Fun;

	public class UpdatePropsHelper
	{
		public static function parseMask(packet:TPacketIn):Array
		{
			var props:Array = []; //所有更新属性
			var count:int = packet.readUnsignedByte(); //包总长度
			var index:int;
			var value:int;
			for (var i:int = 0; i < count; i++)
			{
				index = packet.readUnsignedByte();
				value = packet.readUnsignedInt();
				props.push({index: index, value: value});
			}
			return props;
		}

		/**
		 * 解析完整的对象属性更新/创建包
		 * @param packet
		 * @return {type: updateType, guid: guid, props: props, templateId: templateId};
		 *
		 */
		public static function parsePropPacket(packet:TPacketIn):Object
		{
			var updateType:int = packet.readUnsignedByte();
			var guid:int = packet.readUnsignedInt();
			if (guid == 0)
			{
				return {type: updateType, guid: guid, props: null};
			}
			var templateId:int = 0;
			if (updateType != ObjectUpdateConst.UPDATETYPE_VALUES)
			{
				templateId = packet.readUnsignedInt();
			}
			var props:Array = parseMask(packet);
			return {type: updateType, guid: guid, props: props, templateId: templateId};
		}

		/**
		 * 更新对象属性
		 * @param obj
		 * @param props
		 *
		 */
		public static function updateProps(obj:*, props:Array):void
		{
			for (var i:int = 0; i != props.length; i++)
			{
				AttributeManager.update(obj, props[i].index, props[i].value, ObjectUpdateConst.REPLACE);
			}
		}
	}
}

class AttField
{
	//============================================对象属性======================================================
	public static const OBJECT_FIELD_ENTRY:int = 0x0000; //静态模板id;如物品、怪物都有静态模板id;(用作保存: 玩家的模型id;怪物的模型id)
	public static const OBJECT_END:int = 0x0001;
	//=============================================物品属性=======================================================
	public static const ITEM_FIELD_QUALITY:int = OBJECT_END + 0x0000; // 品质;封印的宠物蛋时是宠物的guid
	public static const ITEM_FIELD_BIND:int = OBJECT_END + 0x0001; // 绑定、礼包
	public static const ITEM_FIELD_CELLPOS:int = OBJECT_END + 0x0002; // 位置
	public static const ITEM_FIELD_STACK_COUNT:int = OBJECT_END + 0x0003; // 叠加数 Size: 1; Type: INT; Flags: OWNER; ITEM_OWNER
	public static const ITEM_FIELD_WRAP:int = OBJECT_END + 0x0004; // 打包
	public static const ITEM_END:int = OBJECT_END + 0x0005;
	//=============================================装备属性==========================================================
	public static const EQUIP_FIELD_STRENGTHEN_LEVEL:int = ITEM_END + 0x0000; // 强化等级
	public static const EQUIP_FIELD_ADD_JEWELS:int = ITEM_END + 0x0001; // 装备当前镶嵌宝石(最多5个) size: 5
	public static const EQUIP_FIELD_DURABILITY:int = ITEM_END + 0x0002; // 耐久度
	public static const EQUIP_FIELD_EXTRA_PROP1:int = ITEM_END + 0x0003; // 附加属性1
	public static const EQUIP_FIELD_EXTRA_PROP2:int = ITEM_END + 0x0004; // 附加属性2
	public static const EQUIP_FIELD_EXTRA_PROP3:int = ITEM_END + 0x0005; // 附加属性3
	public static const EQUIP_FIELD_EXTRA_PROP4:int = ITEM_END + 0x0006; // 附加属性4
	public static const EQUIP_FIELD_EXTRA_PROP5:int = ITEM_END + 0x0007; // 附加属性5
	public static const EQUIP_FIELD_DEITYPOWER:int = ITEM_END + 0x0008; //神力
	public static const EQUIP_END:int = ITEM_END + 0x0007;
	//=============================================场景对象属性=====================================================
	public static const WORLDOBJECT_FIELD_MAPID:int = OBJECT_END + 0x0000; //mapid
	public static const WORLDOBJECT_END:int = OBJECT_END + 0x0005;
	//==============================================动态物品ID======================================================
	public static const DYNAMICOBJECT_FIELD_SORT:int = WORLDOBJECT_END + 0x0000; //种类(掉落物品、魔法阵...)
	public static const DYNAMICOBJECT_FIELD_LIFESPAN:int = WORLDOBJECT_END + 0x0001;
	public static const DYNAMICOBJECT_END:int = WORLDOBJECT_END + 0x0002;
	//==============================================掉落物品======================================================
	public static const DROPITEM_OWNER_GUID:int = DYNAMICOBJECT_END + 0x0000; //归属者的guid
	public static const DROPITEM_PROTECT_TIME:int = DYNAMICOBJECT_END + 0x0001; //保护时间
	public static const DROPITEM_ROLLING:int = DYNAMICOBJECT_END + 0x0002; //是否在roll点中
	public static const DROPITEM_END:int = DYNAMICOBJECT_END + 0x0003;
	//===============================================魔法阵==========================================================
	public static const MAGICWARD_TYPE:int = DYNAMICOBJECT_END + 0x0000; // 魔法阵类型
	public static const MAGICWARD_CHARGE_TYPE:int = DYNAMICOBJECT_END + 0x0001; // 魔法阵收费类型		1
	public static const MAGICWARD_CHARGE_VALUE:int = DYNAMICOBJECT_END + 0x0002; // 魔法阵收费多少		1
	public static const MAGICWARD_MEMBERS:int = DYNAMICOBJECT_END + 0x0003; // 魔法阵成员数量		1
	public static const MAGICWARD_MAX_MEMBERS:int = DYNAMICOBJECT_END + 0x0004; // 魔法阵最大成员数量	1
	public static const MAGICWARD_STATUS:int = DYNAMICOBJECT_END + 0x0005; // 魔法阵附加状态		1
	public static const MAGICWARD_FIELD_REMAINTIME:int = DYNAMICOBJECT_END + 0x0006; // 魔法阵剩余时间
	public static const MAGICWARD_FIELD_CREATER:int = DYNAMICOBJECT_END + 0x0007; // 魔法阵创建者
	public static const MAGICWARD_FIELD_MEMBER_GUID:int = DYNAMICOBJECT_END + 0x0008; // 5个0x0008~0x000C (5个成员，不包含创建者自己)
	public static const MAGICWARD_FIELD_MEMBER_CREATER:int = DYNAMICOBJECT_END + 0x000D; // 创建者自己是否在魔法阵
	public static const MAGICWARD_FIELD_ATTACHVALUE:int = DYNAMICOBJECT_END + 0x000E; // 魔法阵附加值
	public static const MAGICWARD_FIELD_SPENDTYPE:int = DYNAMICOBJECT_END + 0x000F; // 魔法阵预付费类型
	public static const MAGICWARD_END:int = DYNAMICOBJECT_END + 0x0006;
	//=============================================生物==============================================================
	public static const UNIT_FIELD_LEVEL:int = WORLDOBJECT_END + 0x0000; //等级// Size: 1; Type: INT; Flags: PUBLIC
	public static const UNIT_FIELD_HEALTH:int = WORLDOBJECT_END + 0x0001; //生命// Size: 1; Type: INT; Flags: PUBLIC
	public static const UNIT_FIELD_MAXHEALTH:int = WORLDOBJECT_END + 0x0002; // Size: 1; Type: INT; Flags: PUBLIC
	public static const UNIT_FIELD_MOVESPEED:int = WORLDOBJECT_END + 0x0003; //移动速度(像素)
	public static const UNIT_FIELD_ATTACK:int = WORLDOBJECT_END + 0x0004; //攻击力
	public static const UNIT_FIELD_DEFENSE:int = WORLDOBJECT_END + 0x0005; //防御力
	public static const UNIT_FIELD_DELICACY:int = WORLDOBJECT_END + 0x0006; //灵巧
	public static const UNIT_FIELD_HAYMAKER:int = WORLDOBJECT_END + 0x0007; //爆击
	public static const UNIT_FIELD_WHITE_MAGIC:int = WORLDOBJECT_END + 0x0008; //白魔法力
	public static const UNIT_FIELD_BLACK_MAGIC:int = WORLDOBJECT_END + 0x0009; //黑魔法力
	public static const UNIT_FIELD_BLUE_MAGIC:int = WORLDOBJECT_END + 0x000A; //青魔法力
	public static const UNIT_FIELD_BLOOD_MAGIC:int = WORLDOBJECT_END + 0x000B; //血魔法力
	public static const UNIT_FIELD_MAGIC:int = WORLDOBJECT_END + 0x000C; //魔法(MP)
	public static const UNIT_FIELD_MAGIC_MAX:int = WORLDOBJECT_END + 0x000D;
	public static const UNIT_FIELD_MODEL_ID:int = WORLDOBJECT_END + 0x000E; //身体模型id(为了支持变身)
	public static const UNIT_FIELD_MODEL_ZOOM:int = WORLDOBJECT_END + 0x000F; //身体模型缩放比例
	public static const UNIT_FIELD_WHITE_MAGIC_Max:int = WORLDOBJECT_END + 0x0010; //白黑青血魔法力上限值
	public static const UNIT_FIELD_BLACK_MAGIC_Max:int = WORLDOBJECT_END + 0x0011;
	public static const UNIT_FIELD_BLUE_MAGIC_Max:int = WORLDOBJECT_END + 0x0012;
	public static const UNIT_FIELD_BLOOD_MAGIC_Max:int = WORLDOBJECT_END + 0x0013;
	public static const UNIT_FIELD_DEITY_POWER:int = WORLDOBJECT_END + 0x0014; //神力
	public static const UNIT_END:int = WORLDOBJECT_END + 0x0014;
	//==============================================怪物===============================================================
	public static const MONSTER_FIELD_ICON:int = UNIT_END + 0x0000; //怪物头像
	public static const MONSTER_FIELD_TEMPLATE_ID:int = UNIT_END + 0x0001; //模板id// 模板ID
	public static const MONSTER_FIELD_INITIATIVE:int = UNIT_END + 0x0002; //是否是主动怪
	public static const MONSTER_FIELD_DIFF_STATE:int = UNIT_END + 0x0003; //怪物变异状态//0表示未变异，-1表示变异失败，其它则指状态id
	public static const MONSTER_END:int = UNIT_END + 0x0004;
	//==============================================玩家===============================================================
	public static const PLAYER_FIELD_FLAGS:int = UNIT_END + 0x0000; //某些状态标识
	public static const PLAYER_FIELD_BASEPROPERTY:int = UNIT_END + 0x0001; //基本属性（职业、性别、头像、PK模式）enum PLAYER_BASEPROPERTY
	public static const PLAYER_FIELD_REWARDHUNTERLEV:int = UNIT_END + 0x0002; //赏金猎人等级
	public static const PLAYER_FIELD_EXPERIENCE:int = UNIT_END + 0x0003; //角色经验
	public static const PLAYER_FIELD_FREEPOINT:int = UNIT_END + 0x0004; //自由点数
	public static const PLAYER_FIELD_STATE:int = UNIT_END + 0x0005; //角色全局状态(死亡、骑乘、站立 || 红名、白名、蓝名)
	public static const PLAYER_FIELD_MAGIC_ID:int = UNIT_END + 0x0006; //魔法阵ID
	//...空档...
	public static const PLAYER_FIELD_EVIL_ALL:int = UNIT_END + 0x000E; //总罪恶值;主要用于排行榜
	public static const PLAYER_FIELD_BELIEF:int = UNIT_END + 0x000F; //信仰值
	public static const PLAYER_FIELD_MONEY:int = UNIT_END + 0x0010; //金币
	public static const PLAYER_FIELD_INTEGRATE:int = UNIT_END + 0x0011; //积分
	public static const PLAYER_FIELD_MAGICCRYSTAL:int = UNIT_END + 0x0012; //魔晶
	public static const PLAYER_FIELD_MAGICSTONE:int = UNIT_END + 0x0013; //魔石
	public static const PLAYER_FIELD_MAX_EXPERIENCE:int = UNIT_END + 0x0014; //当前升级需求经验
	public static const PLAYER_FIELD_ATTACK_INTERVAL:int = UNIT_END + 0x0015; //没用了//攻击间隔
	//	PLAYER_FIELD_COMM_ATTACK_TIME:int			  = UNIT_END + 0x0016;//最近一次普攻时间
	public static const PLAYER_FIELD_WEAPON_MODELID:int = UNIT_END + 0x0017; //武器模型
	//	PLAYER_FIELD_DEATH_TIME:int					  = UNIT_END + 0x0018;//死亡时时间(服务端专用)
	//	PLAYER_FIELD_REBORNPOINT_ID	:int			  = UNIT_END + 0x0019;
	public static const PLAYER_FIELD_MAXBELIEF:int = UNIT_END + 0x001A; //最大信仰值
	public static const PLAYER_FIELD_GODHOODLEV:int = UNIT_END + 0x001B; //神格等级
	//=========点数(与Player.h文件中的PointType枚举一一对应)===========
	public static const PLAYER_FIELD_BASE_ATTACKPOINT:int = UNIT_END + 0x001C; //基础攻点数
	public static const PLAYER_FIELD_BASE_DEFENSEPOINT:int = UNIT_END + 0x001D; //基础防点数
	public static const PLAYER_FIELD_BASE_DELICACYPOINT:int = UNIT_END + 0x001E; //基础敏点数
	public static const PLAYER_FIELD_BASE_BODYPOINT:int = UNIT_END + 0x001F; //基础体点数
	public static const PLAYER_FIELD_GODHOOD_ATTACKPOINT:int = UNIT_END + 0x0020; //神格攻点数
	public static const PLAYER_FIELD_GODHOOD_DEFENSEPOINT:int = UNIT_END + 0x0021; //神格防点数
	public static const PLAYER_FIELD_GODHOOD_DELICACYPOINT:int = UNIT_END + 0x0022; //神格敏点数
	public static const PLAYER_FIELD_GODHOOD_BODYPOINT:int = UNIT_END + 0x0023; //神格体点数
	public static const PLAYER_FIELD_EQUIP_ATTACKPOINT:int = UNIT_END + 0x0024; //装备攻点数
	public static const PLAYER_FIELD_EQUIP_DEFENSEPOINT:int = UNIT_END + 0x0025; //装备防点数
	public static const PLAYER_FIELD_EQUIP_DELICACYPOINT:int = UNIT_END + 0x0026; //装备敏点数
	public static const PLAYER_FIELD_EQUIP_BODYPOINT:int = UNIT_END + 0x0027; //装备体点数
	public static const PLAYER_FIELD_STONE_ATTACKPOINT:int = UNIT_END + 0x0028; //宝石攻点数
	public static const PLAYER_FIELD_STONE_DEFENSEPOINT:int = UNIT_END + 0x0029; //宝石防点数
	public static const PLAYER_FIELD_STONE_DELICACYPOINT:int = UNIT_END + 0x002A; //宝石敏点数
	public static const PLAYER_FIELD_STONE_BODYPOINT:int = UNIT_END + 0x002B; //宝石体点数
	public static const PLAYER_FIELD_ALL_ATTACKPOINT:int = UNIT_END + 0x002C; //总攻点数
	public static const PLAYER_FIELD_ALL_DEFENSEPOINT:int = UNIT_END + 0x002D; //总防点数
	public static const PLAYER_FIELD_ALL_DELICACYPOINT:int = UNIT_END + 0x002E; //总敏点数
	public static const PLAYER_FIELD_ALL_BODYPOINT:int = UNIT_END + 0x002F; //总体点数
	public static const PLAYER_FIELD_BAG_SIZE:int = UNIT_END + 0x0030; //背包格子数
	public static const PLAYER_FIELD_SKILL_POINT:int = UNIT_END + 0x0031; //技能点
	public static const PLAYER_FIELD_EVIL:int = UNIT_END + 0x0032; //玩家罪恶值
	public static const PLAYER_FIELD_SKILL_POINT_MAX:int = UNIT_END + 0x0033; //技能点可获得最大值
	public static const PLAYER_FIELD_REPUTE:int = UNIT_END + 0x0034; //~0x003B//声望值(8个)
	public static const PLAYER_FIELD_REPUTE_PHASE:int = UNIT_END + 0x003C; //~0x0043//声望阶段(8个)
	public static const PLAYER_FIELD_HORSE_IDS:int = UNIT_END + 0x0044; //玩家拥有的坐骑id;最多四个
	public static const PLAYER_FIELD_HORSE_ID:int = UNIT_END + 0x0045; //玩家当前的坐骑id
	public static const PLAYER_FIELD_RolePartFamiliarity:int = UNIT_END + 0x0046; //~0x004E 9个部位的精通//精通(9个部位)
	public static const PLAYER_FIELD_Team_Id:int = UNIT_END + 0x004F; //队伍ID：袁瑞//队伍
	public static const PLAYER_FIELD_Title_Id:int = UNIT_END + 0x0050; //称号ID，对应fj1_status_template中的'id'字段：袁瑞//称号（每个角色最多同时使用5个称号：0x0050 ~ 0x0054）
	public static const PLAYER_FIELD_DeityPowerValue:int = UNIT_END + 0x0055; //神力各种来源的值 0x0055 ~ 0x005C	//神力(0x0055 ~ 0x005C)
	public static const PLAYER_END:int = UNIT_END + 0x005D;
	//===========================================宠物===================================================================
	public static const PET_FIELD_OWNERGUID:int = UNIT_END + 0x0000; //拥有者GUID
	public static const PET_FIELD_TEMPLATE_ID:int = UNIT_END + 0x0001; //宠物静态模板ID
	public static const PET_FIELD_MAX_EXP:int = UNIT_END + 0x0002; //EXP最大值(升级)
	public static const PET_FIELD_EXP:int = UNIT_END + 0x0003; //EXP
	public static const PET_FIELD_Awaken:int = UNIT_END + 0x0004; //觉醒度
	public static const PET_FIELD_Agreement:int = UNIT_END + 0x0005; //契合度
	public static const PET_FIELD_ATTACK_POINT:int = UNIT_END + 0x0006; //攻点数
	public static const PET_FIELD_DEFENSE_POINT:int = UNIT_END + 0x0007; //防点数
	public static const PET_FIELD_DELICACY_POINT:int = UNIT_END + 0x0008; //敏点数
	public static const PET_FIELD_BODY_POINT:int = UNIT_END + 0x0009; //体点数
	public static const PET_FIELD_QUALITY:int = UNIT_END + 0x000A; //品质
	public static const PET_FIELD_Location:int = UNIT_END + 0x000B; //位置状态(存储地方（宠物栏，背包，仓库），状态（合体、出战、闲置、封印）)
	public static const PE_FIELD_ATTACK_GROWTHRATE:int = UNIT_END + 0x000C; //攻成长率
	public static const PE_FIELD_DEFENSE_GROWTHRATE:int = UNIT_END + 0x000D; //防成长率
	public static const PE_FIELD_DELICACY_GROWTHRATE:int = UNIT_END + 0x000E; //敏成长率
	public static const PE_FIELD_BODY_GROWTHRATE:int = UNIT_END + 0x0010; //体成长率
	public static const PET_FIELD_LOYAL:int = UNIT_END + 0x0011; //忠诚度
	public static const PET_FIELD_WORTH:int = UNIT_END + 0x0012; //价值
	public static const PET_FIELD_FUSEINFO:int = UNIT_END + 0x0013; //融合信息(0xAABB;AA表次数，BB表下次融合要求的等级)
	public static const PET_FIELD_WHOLE_APTITUDE:int = UNIT_END + 0x0014; //总资质
	public static const PET_FIELD_GROWTH_APTITUDE:int = UNIT_END + 0x0015; //成长资质
	public static const PET_FIELD_MAGIC_APTITUDE:int = UNIT_END + 0x0016; //魔法资质
	public static const PET_FIELD_WHITE_MAGIC_GROWTHRATE:int = UNIT_END + 0x0017; //白魔法力成长率
	public static const PET_FIELD_BLACK_MAGIC_GROWTHRATE:int = UNIT_END + 0x0018;
	public static const PET_FIELD_BLUE_MAGIC_GROWTHRATE:int = UNIT_END + 0x0019;
	public static const PET_FIELD_BLOOD_MAGIC_GROWTHRATE:int = UNIT_END + 0x0020;
	public static const PET_FIELD_DEITY_POWER:int = UNIT_END + 0x0021; //神力加成
	//	PET_FIELD_HEAD_ICON							= UNIT_END + 0x0022;//头像
	//所有属性的品质及总品质
	public static const PET_FIELD_ALL_QUALITY:int = UNIT_END + 0x0023;
	public static const PET_END:int = UNIT_END + 0x0028;
	public static const PLAYER_FIELD_JunXianDengJi:int = UNIT_END + 0x00A1; //军衔
}
