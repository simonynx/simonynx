package fj1.common.data.dataobject.items.toolTipShowers
{
	import fj1.common.data.dataobject.items.EquipStoneData;
	import fj1.common.data.dataobject.items.ItemData;
	import fj1.common.res.item.vo.EquipStoneTemplate;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.staticdata.ItemConst;
	import fj1.common.staticdata.ItemQuality;

	import tempest.utils.HtmlUtil;

	public class EquipStoneToolTipShower extends ItemToolTipShower
	{
		public function EquipStoneToolTipShower(itemData:ItemData)
		{
			super(itemData);
		}

		private function get stoneTemplate():EquipStoneTemplate
		{
			return EquipStoneData(itemData).equipStoneTemplate;
		}

		override public function getTipDataArray(params:Object):Array
		{
			var tipPlace:int = params ? int(params) : ItemConst.TIP_PLACE_DEFAULT;
			var strArray:Array = [];
			//名称
			strArray.push(makeAppendParams2("center", ItemQuality.getColorString(_itemData.itemTemplate.quality), setBoldText(_itemData.name)));
			//分割线
			strArray.push(getNewSplictLine());
			//物品类型
			//			strArray.push(richTextFieldObj(getTypeString()));
			//绑定状态
			if (tipPlace != ItemConst.TIP_PLACE_SHORT_CUT) //快捷栏中，不显示物品绑定状态
			{
				if (getBindStr() != "")
					strArray.push(makeAppendParams2("left", normalWhite, getBindStr()));
				else
					strArray.push(makeAppendParams(getBindStr()));
			}
			//物品品质
			strArray.push(makeAppendParams2("left", normalWhite, spaceStr + ItemQuality.getName(_itemData.itemTemplate.quality) + " " + getTypeString()));
			//使用等级
			strArray.push(makeAppendParams(getLevelReqString()));
			//堆叠上限
			strArray.push(makeAppendParams(getAccumulationQuantity()));
			itemDataLayout(strArray, 7);
			//生命值
			if (_itemData.itemTemplate.increase_health > 0)
				strArray.push(makeAppendParams(getRemainingHealth()));
			//魔法值
			if (_itemData.itemTemplate.increase_magic > 0)
				strArray.push(makeAppendParams(getSurplusMgic()));
			//职业需求
			strArray.push(makeAppendParams(getProfession()));
			//性别需求
			strArray.push(makeAppendParams(getSex()));
			//任务物品
			if (itemData.type == ItemConst.TYPE_ITEM_TASK)
				strArray.push(makeAppendParams2("left", normalYellow, LanguageManager.translate(2024, "任务物品")));
			//是否可出售  出售价格
			//			strArray.push(richTextFieldObj(getSellString()));
			//不可交易
			strArray.push(makeAppendParams(getItemState(trade)));
			//不可存储
			strArray.push(makeAppendParams(getItemState(store)));
			//不可丢弃
			strArray.push(makeAppendParams(getItemState(drop)));
			//不可售卖
			strArray.push(makeAppendParams(getItemState(canSale)));
			//不可出售
			if (!_itemData.itemTemplate.is_can_besell)
				strArray.push(makeAppendParams(getSellString(0)));
			//分割线
			strArray.push(getNewSplictLine());
			//使用效果
			strArray.push(makeAppendParams(getEffectString()));
			//冷却时间
			strArray.push(makeAppendParams(getCDTime()));
			//镶嵌宝石附加属性
			strArray = strArray.concat(getAdditionArray());
			//描述
			strArray.push(makeAppendParams(getDescription()));
			//出售价格
			if (!params || params != ItemConst.TIP_PLACE_NPCSHOP) //NPC商店物品不显示出售价格
			{
				if (_itemData.itemTemplate.is_can_besell)
					strArray.push(makeAppendParams(getSellString(0)));
			}
			if (itemData.validDate) //有效期
			{
				//分割线
				strArray.push(getNewSplictLine());
				var nowDate:Date = new Date();
				//
				strArray.push(makeAppendParams(getValidDateString(nowDate)));
				//
				strArray.push(makeAppendParams(getLastValidTime(nowDate)));
			}
			pushDebugInfo(strArray);
			return strArray;
		}

		/**
		 * 镶嵌宝石附加属性
		 */
		protected function getAdditionArray():Array
		{
			var strArray:Array = [];
			strArray.push(BaseToolTipShower.makeAppendParams(BaseToolTipShower.getHtmlTextWithAlign("left", BaseToolTipShower.normalLightYellow, LanguageManager.translate(2061, "附加属性"))));
			pushPropStr(strArray, LanguageManager.translate(2001, "攻击 +"), stoneTemplate.add_attack);
			pushPropStr(strArray, LanguageManager.translate(2003, "防御 +"), stoneTemplate.add_defense);
			pushPropStr(strArray, LanguageManager.translate(2005, "灵巧 +"), stoneTemplate.add_delicacy);
			pushPropStr(strArray, LanguageManager.translate(2007, "暴击 +"), stoneTemplate.add_haymaker);
			pushPropStr(strArray, LanguageManager.translate(2010, "生命最大值 +"), stoneTemplate.add_max_hp);
			pushPropStr(strArray, LanguageManager.translate(2011, "魔法最大值 +"), stoneTemplate.add_max_magic);
			return strArray
		}

		protected function pushPropStr(strArray:Array, prefix:String, value:int):void
		{
			if (!value)
			{
				return;
			}
			var str:String = BaseToolTipShower.getHtmlTextWithAlign("left", BaseToolTipShower.normalWhite, BaseToolTipShower.spaceStr1 + prefix + value.toString());
			strArray.push(BaseToolTipShower.makeAppendParams(str));
		}
	}
}
