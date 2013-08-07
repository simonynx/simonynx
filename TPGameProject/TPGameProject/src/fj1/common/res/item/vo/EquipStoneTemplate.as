package fj1.common.res.item.vo
{
	import fj1.common.res.item.ItemTemplateManager;
	import fj1.common.staticdata.ItemConst;

	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.common.staticdata.Access;
	import tempest.utils.Fun;

	public class EquipStoneTemplate extends ItemTemplate
	{
		private static const log:ILogger = TLog.getLogger(EquipStoneTemplate);

		public var add_attack:int; //加攻击力
		public var add_defense:int; //加防御力
		public var add_delicacy:int; //加敏捷
		public var add_haymaker:int; //加暴击
		public var add_max_hp:int; //加最大生命值
		public var add_max_magic:int; //加最大魔法值
		public var grade:int; //該寶石的階數（1~255）
		public var up_grade_count:int; //表示多少個寶石才能進行升階操作
		public var up_grade_succrate:int; //表示升階成功率百分比
		public var up_grade_failed_itemid:int; //表示升階失敗時可能補償物品的Id
		public var up_grade_failed_itemcount:int; //補償數量
		public var up_grade_failed_itemrate:int; //補償概率百分比
		public var up_grade_beliefcast:int; //升階的信仰消耗
		public var up_grade_moneycast:int; //升階的金幣消耗
		public var is_can_takeout:int; //是否可以取出（0：不可以，1：可以）
		public var add_status_id:int; //關聯狀態的Id
		public var rolepart:int; //可镶嵌的部位(只要所有位中有该数字则表示能装备到该部位)
		public var xilian_beliefcast:int; //洗炼消耗信仰力量
		public var xilian_moneycast:int; //洗炼消耗金币量
		public var zhaiqu_beliefcast:int; //摘取消耗信仰力
		public var zhaiqu_moneycast:int; //摘取消耗金币量

		private static var itemInfoAttrNames:Object = Fun.getProperties(ItemTemplate, Access.READ_WRITE);

		public function EquipStoneTemplate()
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

		/**
		 * 获取宝石加成属性
		 * @return
		 *
		 */
		public function getAdditionArray():Array
		{
			var ret:Array = [];
			if (add_attack)
			{
				ret.push({type: ItemConst.ATTACK, value: add_attack});
			}
			if (add_defense)
			{
				ret.push({type: ItemConst.DEFENSE, value: add_defense});
			}
			if (add_delicacy)
			{
				ret.push({type: ItemConst.DELICACY, value: add_delicacy});
			}
			if (add_haymaker)
			{
				ret.push({type: ItemConst.HAYMAKER, value: add_haymaker});
			}
			if (add_max_hp)
			{
				ret.push({type: ItemConst.ADD_MAXHP, value: add_max_hp});
			}
			if (add_max_magic)
			{
				ret.push({type: ItemConst.ADD_MAXMP, value: add_max_magic});
			}
			if (ret.length == 0)
			{
				log.error("宝石附加属性获取失败：id = " + id);
			}
			return ret;
		}

		/**
		 * 检查是否符合部位需求
		 * @param subType
		 * @return
		 *
		 */
		public function checkRolePart(subType:int):Boolean
		{
			if (!rolepart)
			{
				return false;
			}
			var part:int = rolepart;
			while (part != 0)
			{
				if (part % 10 == subType)
				{
					return true;
				}
				else
				{
					part /= 10;
				}
			}
			return false;
		}


		private var _nextTemplate:EquipStoneTemplate;
		private var _nextTemplateValid:Boolean;

		/**
		 * 获取下一级别的宝石模板
		 * @return
		 *
		 */
		public function get nextTemplate():EquipStoneTemplate
		{
			if (!_nextTemplateValid)
			{
				_nextTemplate = getNextLevelGem(this);
				_nextTemplateValid = true;
			}
			return _nextTemplate;
		}

		/**
		 * 获取下一级别的宝石模板
		 * @param template
		 * @return
		 *
		 */
		private static function getNextLevelGem(template:EquipStoneTemplate):EquipStoneTemplate
		{
			var propArr:Array = template.getAdditionArray();
			var firstProp:Object = propArr[0];
			var result:EquipStoneTemplate = ItemTemplateManager.instance.find(function(item:ItemTemplate):Boolean
			{
				var stoneTempl:EquipStoneTemplate = item as EquipStoneTemplate;
				if (!stoneTempl)
				{
					return false;
				}
				var itemPropArr:Array = stoneTempl.getAdditionArray();
				if (itemPropArr.length == 0)
				{
					return false;
				}
				return firstProp.type == itemPropArr[0].type && template.grade + 1 == stoneTempl.grade;
			}) as EquipStoneTemplate;
			return result;
		}
	}
}
