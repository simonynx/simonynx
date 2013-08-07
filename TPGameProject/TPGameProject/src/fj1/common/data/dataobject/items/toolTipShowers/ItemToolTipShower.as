package fj1.common.data.dataobject.items.toolTipShowers
{
	import assets.UIResourceLib;
	import fj1.common.GameInstance;
	import fj1.common.data.dataobject.items.ItemData;
	import fj1.common.helper.TimerStringHelp;
	import fj1.common.res.item.ItemTemplateManager;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.res.salesroom.SalesroomConfigManager;
	import fj1.common.res.salesroom.vo.SaleItemConfig;
	import fj1.common.staticdata.BindType;
	import fj1.common.staticdata.IconSizeType;
	import fj1.common.staticdata.ItemConst;
	import fj1.common.staticdata.ItemQuality;
	import fj1.common.staticdata.Profession;
	import fj1.common.staticdata.SalesroomConst;
	import fj1.common.ui.boxes.IconBox;
	import fj1.common.ui.pools.IconBoxPool;
	import fj1.common.ui.pools.IconBoxPoolManager;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	import tempest.common.rsl.TRslManager;
	import tempest.ui.components.tips.TRichTextToolTip;
	import tempest.utils.HtmlUtil;

	public class ItemToolTipShower extends BaseToolTipShower
	{
		protected var _itemData:ItemData;

		public function ItemToolTipShower(itemData:ItemData)
		{
			super();
			_itemData = itemData;
		}

		public function get itemData():ItemData
		{
			return _itemData;
		}

		override public function getTipWidth():int
		{
			return 200;
		}

		/**
		 * Tip中图片数据列表
		 * {id: "img", imgUrl: path, defaultImg:defaultBitmapData, w: 36, h: 36, align: "lineHead", marginX:140, marginY:0}
		 * @return
		 *
		 */
		override public function getIconImage():DisplayObject
		{
			var iconBoxPool:IconBoxPool = IconBoxPoolManager.getPool(IconSizeType.ICON72.toString());
			var dataBox:IconBox = IconBox(iconBoxPool.create());
			dataBox.data = _itemData;
			return dataBox;
		}

		/**
		 * TIP隐藏时触发，清除BaseDataBox中的数据，以防止BaseDataBox无法被释放
		 * @param toolTip
		 *
		 */
		override public function onTipHide(toolTip:TRichTextToolTip):void
		{
			var dataBox:IconBox = toolTip.iconImage as IconBox;
			if (!dataBox)
			{
				return;
			}
			dataBox.data = null;
			IconBoxPoolManager.getPool(IconSizeType.ICON72.toString()).disposeObj(dataBox);
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
			//描述
			strArray.push(makeAppendParams(getDescription()));
			//出售价格
			if (!params || params != ItemConst.TIP_PLACE_NPCSHOP) //NPC商店物品不显示出售价格
			{
				if (_itemData.itemTemplate.is_can_besell)
					strArray.push(makeAppendParams(getSellString(0)));
			}
			if (itemData.beginValidDate)
			{
				//物品使用时间 
				strArray.push(makeAppendParams(getBeginValidDateString()));
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

		protected function getNewSplictLine():Object
		{
			var line:Sprite = Sprite(TRslManager.getInstance(UIResourceLib.tipLine));
			return makeAppendParams(getHtmlTextWithAlign("left", normalWhite, ""), [{src: line, index: 0}]);
		}

		override protected function rebuildTipString(place:int = 0):String
		{
			var strArray:Array = [];
			strArray.push(getSellString(place));
			return "";
		}

		public function itemDataLayout(strArray:Array, lineNum:int):void
		{
			var num:int = 0;
			var obj:Object;
			for each (obj in strArray)
			{
				if (obj && obj.text != "")
				{
					++num;
				}
			}
			var i:int = num;
			while (i < lineNum)
			{
				strArray.push(makeAppendParams2("left", normalRed, " "));
				++i;
			}
		}
		public var trade:int = 0;
		public var store:int = 1;
		public var drop:int = 2;
		public var canSale:int = 3;

		//不可交易 不可存储 不可丢弃
		protected function getItemState(num:int):String
		{
			var str:String;
			switch (num)
			{
				case trade:
					str = _itemData.playerBinded ? "" : _itemData.itemTemplate.is_can_trade ? "" : LanguageManager.translate(2025, "不可交易");
					break;
				case store:
					str = _itemData.itemTemplate.is_can_store ? "" : LanguageManager.translate(2026, "不可存储");
					break;
				case drop:
					str = _itemData.itemTemplate.is_can_drop ? "" : LanguageManager.translate(2027, "不可丢弃");
					break;
				case canSale:
					str = itemData.canSale ? "" : LanguageManager.translate(2056, "不可售卖");
					break;
			}
			if (str != "")
				return getHtmlTextWithAlign("left", normalRed, str);
			else
				return "";
		}

		//获得血量
		protected function getRemainingHealth():String
		{
			var _remain:String = _itemData.universal > 0 ? LanguageManager.translate(2072, "储存生命值：{0}/{1}", _itemData.universal, _itemData.itemTemplate.increase_health) : "";
			if (_remain != "")
				return getHtmlTextWithAlign("left", normalBlue, _remain);
			else
				return "";
		}

		//获得魔法
		protected function getSurplusMgic():String
		{
			var _remain:String = _itemData.universal > 0 ? LanguageManager.translate(2073, "储存魔法值：{0}/{1}", _itemData.universal, _itemData.itemTemplate.increase_magic) : "";
			if (_remain != "")
				return getHtmlTextWithAlign("left", normalBlue, _remain);
			else
				return "";
		}

		//获得CD
		protected function getCDTime():String
		{
			var cd_Time:String = _itemData.itemTemplate.cd_time > 0 ? LanguageManager.translate(2023, "冷却时间：{0}秒", (_itemData.itemTemplate.cd_time / 1000).toString()) : "";
			if (cd_Time != "")
				return getHtmlTextWithAlign("left", normalWhite, cd_Time);
			else
				return "";
		}

		//堆叠上限
		protected function getAccumulationQuantity():String
		{
			var quantity:String = _itemData.itemTemplate.max_stack > 0 ? String(_itemData.itemTemplate.max_stack) : "";
			if (quantity != "")
				return getHtmlTextWithAlign("left", normalWhite, spaceStr + LanguageManager.translate(2070, "堆叠上限") + colonStr + quantity);
			else
				return "";
		}

		protected function fixLayout(strArray:Array):void
		{
			var count:int = 0;
			for each (var str:String in strArray)
			{
				if (str != "")
				{
					++count;
				}
			}
			var i:int = count;
			while (i < 5)
			{
				strArray.push("<br>");
				++i;
			}
		}

		protected function pushDebugInfo(strArray:Array):void
		{
			CONFIG::debugging
			{
				strArray.push(makeAppendParams2("left", normalWhite, "guid: " + _itemData.guId.toString()));
				strArray.push(makeAppendParams2("left", normalWhite, "id: " + _itemData.itemTemplate.id.toString()));
			}
		}

		protected function getLevelReqString():String
		{
			var lvStr:String = HtmlUtil.color(normalWhite, spaceStr + LanguageManager.translate(2028, "使用等级："));
			var colorStr:String = _itemData.itemTemplate.request_userlev <= GameInstance.mainCharData.level ? normalWhite : normalRed;
			getHtmlTextWithAlign("left", colorStr, lvStr + _itemData.itemTemplate.request_userlev.toString());
			var str:String = getHtmlTextWithAlign("left", colorStr, lvStr + _itemData.itemTemplate.request_userlev.toString());
			return str;
		}

		protected function getDescription():String
		{
			if (_itemData.itemTemplate.description && _itemData.itemTemplate.description.length > 0)
			{
				return getHtmlTextWithAlign("left", normalGreen, "“" + _itemData.itemTemplate.description + "”");
			}
			else
			{
				return "";
			}
		}

		protected function getBindStr():String
		{
			if (_itemData.ownerId != 0 && _itemData.guId != 0)
			{
				if (_itemData.playerBinded)
				{
					return spaceStr + LanguageManager.translate(2029, "已绑定");
				}
				else
				{
					switch (_itemData.itemTemplate.bind_type)
					{
						case BindType.GAIN:
							return spaceStr + LanguageManager.translate(2030, "获取后绑定");
							break;
						case BindType.EQUIP:
							return spaceStr + LanguageManager.translate(2031, "装备后绑定");
							break;
						default:
							return spaceStr + LanguageManager.translate(2032, "未绑定");
							break;
					}
				}
			}
			return "";
		}

		//职业需求
		protected function getProfession():String
		{
//			if (Profession.getName(_itemData.itemTemplate.request_userprofession) == LanguageManager.translate(100004, "未知"))
//				return "";
//			else
//			{
//				var colorStr:String = normalWhite;
//				var str:String = HtmlUtil.color(colorStr, LanguageManager.translate(2021, "需求职业："));
//				colorStr = _itemData.itemTemplate.request_userprofession == GameInstance.mainCharData.professions ? normalWhite : normalRed;
//				var profession:String = HtmlUtil.color(colorStr, Profession.getName(_itemData.itemTemplate.request_userprofession));
//				return getHtmlTextWithAlign("left", colorStr, str + profession);
//			}
			return "";
		}

		//性别需求
		protected function getSex():String
		{
//			if (_itemData.itemTemplate.request_gender == Profession.None)
//			{
//				return "";
//			}
//			else
//			{
//				var colorStr:String = normalWhite;
//				var str:String = HtmlUtil.color(colorStr, LanguageManager.translate(2022, "需求性别："));
//				colorStr = _itemData.itemTemplate.request_userprofession == GameInstance.mainCharData.professions ? normalWhite : normalRed;
//				var sex:String = HtmlUtil.color(colorStr, Profession.getName(_itemData.itemTemplate.request_gender));
//				return getHtmlTextWithAlign("left", colorStr, str + sex);
//			}
			return "";
		}

		protected function getTypeString():String
		{
			ItemTemplateManager.instance.get(_itemData.templateId);
//			var strType:String;
			var saleItemConfig:SaleItemConfig = SalesroomConfigManager.getSaleItemConfig(_itemData.templateId);
			if (!saleItemConfig)
				return LanguageManager.translate(34004, "其他");
			switch (saleItemConfig.type)
			{
				case SalesroomConst.SORT_WEAPON: //武器
					break;
				case SalesroomConst.SORT_DEFEND: //防具
					break;
				case SalesroomConst.SORT_PET: //宠物
					break;
				case SalesroomConst.SORT_RIDE: //坐骑
					break;
				case SalesroomConst.SORT_STONE: //宝石
					switch (saleItemConfig.subtype)
					{
						case SalesroomConst.SUB_SORT_SST_MAGIC: //魔法晶核
							return LanguageManager.translate(20022, "魔法晶核");
							break;
						case SalesroomConst.SUB_SORT_SST_SKILLFUL: //精通宝石
							return LanguageManager.translate(20023, "精通宝石");
							break;
						case SalesroomConst.SUB_SORT_SST_GODHOOD: //神格宝石
							return LanguageManager.translate(20024, "神格宝石");
							break;
					}
					break;
				case SalesroomConst.SORT_MEDICINE: //药品
					switch (saleItemConfig.subtype)
					{
						case SalesroomConst.SUB_SORT_MST_NORMAL: //普通药剂
							return LanguageManager.translate(20025, "普通药剂");
							break;
						case SalesroomConst.SUB_SORT_MST_BATTLE: //战斗药剂
							return LanguageManager.translate(20026, "战斗药剂");
							break;
					}
					break;
				case SalesroomConst.SORT_SKILL_BOOK: //技能书
					return LanguageManager.translate(20008, "技能书");
					break;
				case SalesroomConst.SORT_OTHER: //其他
					return LanguageManager.translate(34004, "其他");
					break;
			}
			return "";
		}

		protected function getSellString(place:int):String
		{
			if (place != ItemConst.TIP_PLACE_NPCSHOP)
			{
				if (!_itemData.itemTemplate.is_can_besell)
					return getHtmlTextWithAlign("left", normalRed, LanguageManager.translate(2034, "不可出售给NPC商店"));
				else
					return getHtmlTextWithAlign("left", normalLightYellow, LanguageManager.translate(2035, "出售价格：") + ((_itemData.itemTemplate.buy_price * _itemData.itemTemplate.sell_price_rate / 100) >>
						0).toString());
			}
			else
			{
				return "";
			}
		}

		//使用效果
		protected function getEffectString():String
		{
			if (_itemData.itemTemplate.useeffect_description && _itemData.itemTemplate.useeffect_description.length > 0)
			{
				return getHtmlTextWithAlign("left", normalBlue, LanguageManager.translate(2036, "使用效果：") + _itemData.itemTemplate.useeffect_description);
			}
			else
			{
				return "";
			}
		}

		protected function getCanSaleString():String
		{
			if (!itemData.canSale)
			{
				return LanguageManager.translate(2056, "不可售卖");
			}
			else
			{
				return "";
			}
		}

		//		private function getStringLength(str:String, charSet:String = "gb1312"):int
		//		{
		//			return StringUtil.getCharSetLen(str, charSet);
		//		}
		protected function getStringLength(thisString:String, charSet:String = "gb1312"):int
		{
			var thisStringBytsLength:ByteArray = new ByteArray();
			thisStringBytsLength.writeMultiByte(thisString, charSet);
			return thisStringBytsLength.length;
		}
		protected var _byteNum:int = 30;

		protected function getSpaceString(thisString:String, byteNum:int = 50):String
		{
			var num:int = byteNum - getStringLength(thisString);
			var str:String = "";
			for (var i:int = +0; i < num; i++)
			{
				str += " ";
			}
			return str;
		}

		protected function getValidDateString(nowDate:Date):String
		{
			var span:Number = itemData.getLastValidTime(nowDate);
			return getHtmlTextWithAlign("left", span > 0 ? normalGreen : normalRed, LanguageManager.translate(50492, "有效期至：") + getDateString(new Date(itemData.validDate * 1000)));
		}

		/**
		 * 物品使用时间
		 * @return
		 *
		 */
		protected function getBeginValidDateString():String
		{
			return getHtmlTextWithAlign("left", normalGreen, LanguageManager.translate(1104, "使用时间：") + getDateString(new Date(itemData.beginValidDate * 1000)));
		}

		protected function getLastValidTime(nowDate:Date):String
		{
			var span:Number = itemData.getLastValidTime(nowDate);
			if (span > 0)
			{
				return getHtmlTextWithAlign("left", normalGreen, LanguageManager.translate(50493, "有效时间：") + TimerStringHelp.parseSecond(span / 1000));
			}
			else
			{
				return getHtmlTextWithAlign("left", normalRed, LanguageManager.translate(50494, "已过期"));
			}
		}

		private function getDateString(date:Date):String
		{
			return LanguageManager.translate(50495, "{0}年{1}月{2}日{3}时{4}分{5}秒", date.getFullYear(), date.getMonth() + 1, date.getDate(), date.hours, date.getMinutes(), date.getSeconds());
		}
	}
}
