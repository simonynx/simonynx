package fj1.common.res.item.vo
{
	import fj1.common.core.ICDClient;
	import fj1.common.staticdata.CDConst;
	import tempest.common.staticdata.Access;
	import tempest.utils.Fun;

	public class ItemTemplate implements ICDClient
	{
		public var id:int; //物品模板唯一编号
		public var name:String; //名称
		public var type:int; //类型
		public var subtype:int; //子类型
		public var is_can_trade:Boolean; //是否可以用于交易
		public var is_only_one:Boolean; //只能拥有一个
		public var is_can_store:Boolean; //是否允许存入仓库
		public var is_can_drop:Boolean; //是否允许丢弃
		public var is_delete_whendrop:Boolean; //丢弃后是否删除
		public var is_can_besell:Boolean; //可被售给NPC商店
		public var is_autodrop_whendie:Boolean; //玩家死亡后自动丢弃
		public var is_autodrop_downline:Boolean; //下线自动丢弃
		public var is_delete_afterused:Boolean; //使用后是否删除
		public var bind_type:int; //绑定类型
		public var cd_type:int; //冷却类型
		public var cd_time:int; //冷却时间
		public var buy_price:int; //买入价格
		public var magic_crystal_price:int; //魔晶价格
		public var sell_price_rate:int; //出售价格比率(百分比)
		public var max_stack:int; //最大叠加数
		public var remain_time_sec:int; //时效时间
		public var request_gender:int; //性别要求
		public var request_userlev:int; //等级需求
		public var request_userprofession:int; //职业需求
		public var increase_health:int; //增加HP
		public var increase_magic:int; //增加MP
		public var increase_experience:int; //增加经验
		public var increase_belief:int; //增加信仰力
		public var bind_state_id:int; //使用该物品后获得的状态id
		public var bind_state_lev:int; //使用该物品后获得的状态lev
		public var bind_spell_id:int; //使用该物品后获得的技能id
		public var bind_spell_lev:int; //使用该物品后获得的技能lev
		public var flag_1:int; //特殊标识1
		public var flag_2:int; //特殊标识2
		public var script_id:int; //使用时触发的脚本ID
		public var prototype_ex_id:int; //额外属性的索引
		public var animaExp:int; //灵魂经验
		public var canUnite:int; //是否可分解
		public var quality:int; //品质
		//表现字段
		public var sortId:int; //分类Id
		public var role_modelid:int; //装备该物品后人物模型id
		public var bag_icon:int; //物品背包图标ID
		public var bag_iconExtend:int; //物品背包图标扩展ID
		public var drop_icon:int; //物品掉落图标ID
		public var use_sound:int; //物品使用音效
		public var get_sound:int; //物品获得音效
		public var drop_sound:int; //物品掉落音效
		public var can_be_use:Boolean; //是否可以使用
		public var description:String = ""; //物品描述
		public var descriptionExtend:String = ""; //物品描述扩展
		public var useeffect_description:String = ""; //物品使用效果描述
		public var useeffect_descriptionExtend:String = ""; //物品使用效果描述扩展
		public var alertId:int; //提示框Id
		public var taking_sort:int; //拾取的类别
		public var need_log:int; //是否需要日志记录  扩展是否可批量使用   value&0x0002
		private var _isCollectUtil:int = -1; //是否是采集道具
		private static var itemEffectInfoAttrNames:Object = Fun.getProperties(ItemEffectTemplate, Access.READ_WRITE);

		public function ItemTemplate()
		{
		}

		public function initByItemEffect(itemEffect:ItemEffectTemplate):void
		{
			for (var attrName:Object in itemEffectInfoAttrNames)
			{
				this[attrName] = itemEffect[attrName];
			}
		}

		public function get templateId():int
		{
			return id;
		}

		public function get groupId():int
		{
			return cd_type;
		}

		public function get cdTime():int
		{
			return cd_time;
		}

		public function get groupType():int
		{
			return CDConst.GROUP_ITEM;
		}

		/**
		 * 是否是采集道具
		 * @return
		 *
		 */
		public function get isCollectUtil():Boolean
		{
//			if (_isCollectUtil == -1)
//			{
//				_isCollectUtil = CollectTemplateManager.instrance.getCollectTemplByToolId(id) ? 1 : 0;
//			}
//			return _isCollectUtil == 1;
			return false;
		}
	}
}
