package fj1.common.res.item.vo
{
	import fj1.common.GameInstance;
	import fj1.common.staticdata.ItemConst;
	
	import flash.utils.describeType;
	
	import tempest.common.staticdata.Access;
	import tempest.utils.Fun;

	public class EquipmentTemplate extends ItemTemplate
	{
		public var is_can_repair:Boolean; //是否可修理
		public var max_durability:int; //耐久度上限
		public var max_quality:int;
		public var max_strengthen:int; //强化数上限
		public var max_socks:int; //孔数上限
		public var stone_type:int; //镶嵌宝石类型
		public var increase_attack:int; //增加攻击力
		public var increase_defense:int; //增加防御力
		public var increase_delicacy:int; //增加灵巧
		public var increase_haymaker:int; //增加暴击
		public var increase_attack_point:int; //增加攻点
		public var increase_defense_point:int; //增加防点
		public var increase_delicacy_point:int; //增加敏点
		public var increase_body_point:int; //增加体点
		public var increase_movespeed:int; //增加移动速度
		public var lowequipment_add:int; //低档次装备附加点
		public var midequipment_add:int; //中档次装备附加点
		public var hightequipment_add:int; //高档次装备附加点
		public var add_maxhp:int; //增加生命最大值
		public var add_maxmp:int; //增加魔法最大值
		public var series:int; //序列
　    　public var is_can_dismantle:int; //是否可分解
        public var fixing_rate:int;//维修费率（每损失10000耐久需要花费的金币数）

		/**
		 * 装备的基础神力值
		 */
		public var add_godpower:int;
		
		private static var itemInfoAttrNames:Object = Fun.getProperties(ItemTemplate, Access.READ_WRITE);

		public function EquipmentTemplate()
		{
			super();
		}

		public function initByItem(item:ItemTemplate):void
		{
			for (var attrName:Object in itemInfoAttrNames)
			{
				this[attrName] = item[attrName];
			}
		}

		override public function get groupId():int
		{
			return -1;
		}
		
		/**
		 * 是否是时装
		 * @return
		 *
		 */
		public function get isFashionCloth():Boolean
		{
			return ItemConst.isFashionCloth(subtype);
		}
		
		/**
		 * 根据装备静态属性计算出的神力值
		 * @return 
		 * 
		 */		
		public function getDefaultGodPower():int
		{
			return Math.floor(increase_attack / 3 + increase_defense / 3
				+ increase_delicacy / 4 + increase_haymaker / 4
				+ add_maxhp / 100 + add_maxmp / 100);
		}
	}
}
