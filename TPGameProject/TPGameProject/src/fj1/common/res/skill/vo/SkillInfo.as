package fj1.common.res.skill.vo
{
	import fj1.common.core.ICDClient;
	import fj1.common.res.skill.MagicTemplateMannage;
	import fj1.common.staticdata.CDConst;
	import fj1.common.staticdata.SkillConst;
	import fj1.common.staticdata.SpellTargetType;
	
	import tpm.magic.entity.BaseMaigcInfo;
	import tpm.magic.entity.MagicInfo;

	[Bindable]
	public class SkillInfo extends BaseMaigcInfo implements ICDClient
	{
		//基础信息
		public var id:int=0; //技能唯一标识ID
		public var isLearned:Boolean=false;
		public var spell_name:String="skill";
		public var spell_description:String="description"; //技能描述
		public var spell_getdescription:String=""; //技能书获取途径描述
		public var spell_ico:int=0; //技能图标
		public var type_id:int=0; //技能种类ID//技能类型  治疗  伤害 增益
		public var spell_level:int=1; //当前技能等级
		public var special_type:int=0; //特殊技能类型   冲锋 瞬移 特殊伤害计算
		public var magic_id:int; //技能魔法ID 对应多个  1，2，3
		public var godpower:int=0; //神力加成
		public var is_normal_attack:int=0; //是否普通攻击
		public var uplev_reqexp:int; //升级所需经验
		public var addexp_everytime:int; //每次升级增加技能经验
		//施放条件
		public var is_face:int=0; //施法时是否面向
		public var casting_needtarget:int=1; //施放选中对象      1自己  2敌对者 3直接施放不用选择对象 
		public var area_type:int=1; //攻击范围类型            群攻  单体  XP
		public var effect_begin_target:int=1; //魔法光效添加对象 1自己 2敌对者 3鼠标点击点
		public var target_limit:int=1; //作用目标数
		public var is_activeskill:int=0; //是否主动技能
		public var is_casting_insafe:int=0; //是否可以在安全区施法
		public var casting_distance:Number=0; //施法距离   施法者离目标最小距离
		public var uneffect_bystatus:int=0; //是否受状态影响
		public var casting_weapontype:int=0; //技能释放需要武器类型
		public var is_autoattact:Boolean; //是否可以自动攻击
		public var is_auto_normalattack:int=0; //是否技能释放后接普通攻击
		public var kang_xing_id:int; //抗性id
		public var is_guaji:Boolean; //是否可挂机
		//CD信息
		public var cd_type:int=0; //技能CD时间
		public var cd_times:Number=1; //技能恢复时间
		public var is_affect_allcd:int=0; //是否影响所有CD
		//施法伤害
		public var fixed_damage:Number=0; //固定伤害值
		public var percent_damage:Number=0; //百分比伤害
		public var times_damage:Number=0; //技能扩大伤害倍数
		public var additional_targetid:uint=0; //额外伤害扩大目标状态ID
		public var additional_timesdamage:Number=0; //额外伤害扩大倍数
		public var fury_limit:int=0; //暴怒点上限
		public var fury_add:Number=0; //暴怒点增加值
		//学习需求
		public var need_level:int=1; //学习等级需求
		public var need_profession:int=1; //学习需要职业
		public var consume_goods:int=0; //消耗物品ID
		public var consume_goods_count:int=0; //消耗物品ID数量
		public var consume_experience:Number=0; //消耗经验
		public var consume_money:Number=0; //消耗金钱
		public var consume_belief:Number=0; //消耗信仰力
		public var consume_thew:int=0; //消耗体力
		//使用消耗
		public var consume_hp:Number=0; //消耗生命值
		public var consume_hp_percent:Number=0; //消耗生命百分比
		public var consume_mp:Number=0; //消耗魔法值
		public var consume_mp_percent:Number=0; //消耗魔法百分比
		public var consume_xingjunling:int=0; //神将技能消耗技能点
		//施法效果
		public var fixed_cure:Number=0; //固定治疗值
		public var percent_cure:Number=0; //万分比治疗比
		public var cure:Number=0; ///治疗力
		public var addfirst_statusid:int=0; //技能赋予状态1ID
		public var addfirst_statuslevel:int=0; //技能赋予状态1等级
		public var addfirst_statusperecnt:Number=0; //技能赋予状态1几率
		public var addsecond_statusid:int=0; //技能赋予状态2ID
		public var addsecond_statuslevel:int=0; //技能赋予状态2等级
		public var addsecond_statusperecnt:Number=0; //技能赋予状态2几率
		public var addthird_statusid:int=0; //技能赋予状态3ID
		public var addthird_statuslevel:int=0; //技能赋予状态3等级
		public var addthird_statusperecnt:Number=0; //技能赋予状态3几率
		public var unlock_statusid:int=0; //解除状态ID
		public var unlock_status_type:int=0; //解除状态类型
		public var fly_text:String=""; //使用时的飘字
		public var spell_type:int=0; //技能类型
		public var skill_power:int=0; //正表示伤害，负表示治疗

		public function get distanceType():String
		{
			return (isRangeSkill ? "远程" : "近战") + (isAreaSkill ? "群体" : "单攻");
		}

		public function get templateId():int
		{
			return id;
		}

		/**
		 *大公共cd组
		 * @return
		 *
		 */
		public function get groupType():int
		{
			if (isNormalSkill || isJumpSkill)
				return CDConst.GROUP_NONE; //普攻，不放入CD组
			else
				return CDConst.GROUP_SPELL;
		}

		public function get cdTime():int
		{
			return cd_times;
		}

		/**
		 *自身cd组
		 * @return
		 *
		 */
		public function get groupId():int
		{
			return cd_type;
		}
		public var use_magic_id:int;

		public function get magicInfo():MagicInfo
		{
			return MagicTemplateMannage.instrance.getMagicInfo(use_magic_id);
		}

		/**
		 *是否普通攻击
		 * @return
		 *
		 */
		public function get isNormalSkill():Boolean
		{
			return (spell_type == SkillConst.SPELL_NORMAL);
		}

		/**
		 *是否跳跃技能
		 * @return
		 *
		 */
		public function get isJumpSkill():Boolean
		{
			return (spell_type == SkillConst.SPELL_JUMP);
		}

		/**
		 * 公会技能
		 * @return
		 *
		 */
		public function get isGuildSkill():Boolean
		{
			return (spell_type == SkillConst.SPELL_GUILD);
		}

		/**
		 * 职业技能
		 * @return
		 *
		 */
		public function get isProfressionSkill():Boolean
		{
			return (spell_type == SkillConst.SPELL_PROFRESSION);
		}

		/**
		 *采集技能
		 * @return
		 *
		 */
		public function get isCollectSkill():Boolean
		{
			return (spell_type == SkillConst.SPELL_COLLECT);
		}

		/**
		 *是否远程技能
		 * @return
		 *
		 */
		public function get isRangeSkill():Boolean
		{
			return this.casting_distance > 3;
		}

		/**
		 *是否群攻
		 * @return
		 *
		 */
		public function get isAreaSkill():Boolean
		{
			return this.area_type == SkillConst.AREA_TYPE_MUTI;
		}

		/**
		 *是否主动技能
		 *
		 */
		public function get isActiveSkill():Boolean
		{
			return this.is_activeskill == 1;
		}

		/**
		 *释放是否需要目标
		 * @return
		 *
		 */
		public function get needTarget():Boolean
		{
			return (isRangeSkill && casting_needtarget != SpellTargetType.SpellTargetType_Self);
		}
	}
}
