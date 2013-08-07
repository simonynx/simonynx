package fj1.common.data.dataobject.items
{
	import fj1.common.GameInstance;
	import fj1.common.data.dataobject.DataObject;
	import fj1.common.data.dataobject.cd.CDState;
	import fj1.common.data.dataobject.items.toolTipShowers.ItemToolTipShower;
	import fj1.common.data.interfaces.ICDable;
	import fj1.common.data.interfaces.ICopyable;
	import fj1.common.data.interfaces.IGuideableItem;
	import fj1.common.data.interfaces.ISlotItem;
	import fj1.common.data.interfaces.ILockable;
	import fj1.common.data.interfaces.IPlayerBindable;
	import fj1.common.data.interfaces.ISaleroomSaleable;
	import fj1.common.data.interfaces.IShortCut;
	import fj1.common.data.interfaces.IStoredObject;
	import fj1.common.helper.ItemOperateHelper;
	import fj1.common.helper.TAlertHelper;
	import fj1.common.net.GameClient;
	import fj1.common.res.ResPaths;
	import fj1.common.res.guide.vo.GuideConfig;
	import fj1.common.res.item.vo.ItemTemplate;
	import fj1.common.res.salesroom.SalesroomConfigManager;
	import fj1.common.res.salesroom.vo.SaleItemConfig;
	import fj1.common.staticdata.CDConst;
	import fj1.common.staticdata.DataObjectType;
	import fj1.common.staticdata.ItemConst;
	import fj1.common.staticdata.ItemQuality;
	import fj1.common.ui.TWindowManager;
	import fj1.manager.CDManager;
	import fj1.manager.MessageManager;
	import fj1.manager.SlotItemManager;
	import fj1.modules.item.signals.ItemSignal;
	import fj1.modules.main.MainFacade;

	import mx.events.PropertyChangeEvent;

	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.common.staticdata.Access;
	import tempest.common.time.vo.TimerData;
	import tempest.manager.TimerManager;
	import tempest.ui.components.TAlert;
	import tempest.ui.events.DataEvent;
	import tempest.ui.events.SlotEvent;
	import tempest.ui.interfaces.IIcon;
	import tempest.ui.interfaces.ISlotData;
	import tempest.ui.interfaces.IToolTipClient;
	import tempest.utils.Fun;

	[Bindable]
	[Event(name = "slotChange", type = "tempest.ui.events.SlotEvent")]
	[Event(name = "slotRemove", type = "tempest.ui.events.SlotEvent")]
	public class ItemData extends DataObject implements ISlotItem, IIcon, IStoredObject, ICDable, IShortCut, ISaleroomSaleable, IGuideableItem, IPlayerBindable
	{
		private static const log:ILogger = TLog.getLogger(ItemData);

		private var _cdState:CDState; //冷却状态
		private var _slot:int = 0;
		protected var _itemTemplate:ItemTemplate;
		[Attribute(index = "OBJECT_FIELD_ENTRY")]
		public var template:int;
		private var _playerBinded:Boolean;
		private var _state:int;
		private var _cdVisible:Boolean = true;
		private var _quality:int;
		private var _validTimer:TimerData;
		/**
		 * 物品是否被锁定（不能对其进行操作）
		 */
		public var locked:Boolean;
		private var _num:int;
		private var _universal:int;
		private var _validDate:int;
		private var _beginValidDate:int;
		private var _needShowNum:Boolean = true;
		private var _enabled:Boolean = false;
		protected var _ownerId:int;
		protected var _toolTipShower:IToolTipClient;
		protected static const USE_FAIL_REASON_NONE:int = 0;
		protected static const USE_FAIL_REASON_GENDER:int = 1;
		protected static const USE_FAIL_REASON_USERLEV:int = 2;
		protected static const USE_FAIL_REASON_PROFESSION:int = 3;
		/**
		 * 属性名集合
		 */
		private static var attrNames:Object = Fun.getProperties(ItemData, Access.READ_WRITE);

		public function get guideConfig():GuideConfig
		{
			return _guideConfig;
		}

		public function set guideConfig(value:GuideConfig):void
		{
			_guideConfig = value;
		}

		public function get cdVisible():Boolean
		{
			return _cdVisible;
		}

		public function set cdVisible(value:Boolean):void
		{
			_cdVisible = value;
		}

		public function get num():int
		{
			return _num;
		}

		[Attribute(index = "OBJECT_FIELD_ENTRY + 0x0002")]
		public function set num(value:int):void
		{
			_num = value;
		}

		/**
		 * 万用字段，具体含义根据物品的不同而不同
		 */
		[Attribute(index = "OBJECT_END + 0x0005")]
		public function set universal(value:int):void
		{
			_universal = value;
		}

		public function get universal():int
		{
			return _universal;
		}

		/**
		 * 物品有效期
		 */
		[Attribute(index = "OBJECT_END + 0x0006")]
		public function set validDate(value:int):void
		{
			if (_validDate == value)
			{
				return;
			}
			var oldDate:int = _validDate;
			_validDate = value;
			var span:Number = getLastValidTime(new Date());
			if (span > 0)
			{
				if (!_validTimer)
				{
					_validTimer = TimerManager.createNormalTimer(1000, 0, onValidTimer);
				}
				isValid = true;
			}
			else
			{
				if (_validTimer)
				{
					_validTimer.stop();
					_validTimer = null;
				}
				isValid = false;
			}
			if (oldDate != _validDate)
			{
				dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "validDate", oldDate, value));
			}
		}

		/**
		 * 物品进入有效期时间
		 * @return
		 *
		 */
		public function get beginValidDate():int
		{
			return _beginValidDate;
		}

		/**
		 * 物品进入有效期时间
		 * @param value
		 *
		 */
		[Attribute(index = "OBJECT_END + 0x0007")]
		public function set beginValidDate(value:int):void
		{
			_beginValidDate = value;
		}

		/**
		 * 物品是否生效
		 * @return
		 *
		 */
		public function isValidation():Boolean
		{
			var date:Date = new Date();
			return beginValidDate > (GameInstance.getServerTime(date.getTime()) / 1000) ? false : true;
		}
		/**
		 * 当前物品是否有效
		 */
		public var isValid:Boolean = true;

		private function onValidTimer():void
		{
			var span:Number = getLastValidTime(new Date());
			if (span <= 0)
			{
				_validTimer.stop();
				_validTimer = null;
				isValid = false;
			}
		}

		public function get validDate():int
		{
			return _validDate;
		}

		public function getLastValidTime(nowDate:Date):Number
		{
			return new Date(validDate * 1000).getTime() - GameInstance.getServerTime(nowDate.getTime());
		}
		/**
		 * 引导信息
		 */
		private var _guideConfig:GuideConfig;

		/**
		 * 派生类必须重写该方法！
		 * @return
		 *
		 */
		public function copy():ICopyable
		{
			var newData:ItemData = new ItemData(_ownerId, guId, _itemTemplate, num, cdEnabled);
			copyPropertys(newData);
			return newData;
		}

		protected function copyPropertys(newData:ItemData):void
		{
			for (var attrName:Object in attrNames)
			{
				newData[attrName] = this[attrName];
			}
		}

		public function get slot():int
		{
			return _slot;
		}

		[Attribute(index = "OBJECT_FIELD_ENTRY + 0x0001")]
		public function set slot(value:int):void
		{
			if (_slot != value)
			{
				var oldSlot:int = _slot;
				_slot = value;
				dispatchEvent(new SlotEvent(SlotEvent.SLOT_CHANGE, oldSlot, value));
				dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, slot, oldSlot, value));
			}
		}

		public function get cdEnabled():Boolean
		{
			return _cdState ? true : false;
		}

		public function ItemData(ownerId:int, guId:int, info:ItemTemplate, num:int, cdEnabled:Boolean)
		{
			super(guId);
			_ownerId = ownerId;
			this._itemTemplate = info;
			this.num = num;
			super.name = this._itemTemplate.name;
			quality = this._itemTemplate.quality;
			_toolTipShower = new ItemToolTipShower(this);
			if (cdEnabled)
			{
				_cdState = CDManager.getInstance().getCDState(this.groupId, this.templateId, CDConst.GROUP_ITEM);
			}
			//不可堆叠物品默认不显示数量
			if (info.max_stack <= 1)
			{
				this.needShowNum = false;
			}
		}

		public function get canMutiUse():Boolean
		{
			return Boolean(itemTemplate.need_log & 0x0002);
		}

		/**
		 * 获得tip显示对象
		 * @return
		 *
		 */
		public function get toolTipShower():IToolTipClient
		{
			return _toolTipShower;
		}

		public function set toolTipShower(value:IToolTipClient):void
		{
			_toolTipShower = value;
		}

		/**
		 * 检查装备限制
		 * @return 失败原因枚举
		 *
		 */
		protected function checkEnabled():int
		{
//			if (itemTemplate.request_gender != 0 && itemTemplate.request_gender != GameInstance.mainCharData.gender)
//			{
//				return USE_FAIL_REASON_GENDER;
//			}
//			if (itemTemplate.request_userprofession != 0 && itemTemplate.request_userprofession != GameInstance.mainCharData.professions)
//			{
//				return USE_FAIL_REASON_PROFESSION;
//			}
			if (itemTemplate.request_userlev != 0 && itemTemplate.request_userlev > GameInstance.mainCharData.level)
			{
				return USE_FAIL_REASON_USERLEV;
			}
			return USE_FAIL_REASON_NONE;
		}

		public function get quality():int
		{
			return _quality;
		}

		public function set quality(value:int):void
		{
			_quality = value;
		}

		public function get canUse():Boolean
		{
			return checkEnabled() == USE_FAIL_REASON_NONE;
		}

		public function get playerBinded():Boolean
		{
			return _playerBinded;
		}

		[Attribute(index = "OBJECT_END + 0x0001")]
		public function set state(value:int):void
		{
			_state = value;
			playerBinded = Boolean(_state % 10);
		}

		public function get state():int
		{
			return _state;
		}

		public function set playerBinded(value:Boolean):void
		{
			_playerBinded = value;
		}

		public function getIconUrl(sizeType:int = -1):String
		{
			return ResPaths.getIconPath(_itemTemplate.bag_icon, sizeType);
		}

		public function get itemTemplate():ItemTemplate
		{
			return _itemTemplate;
		}

		/****************************功能函数************************************/
		/**
		 * 物品使用音效
		 *
		 */
		public function playUseSound():void
		{
//			GameInstance.signal.sound.addGameSound.dispatch(itemTemplate.use_sound);
		}

		/**
		 *物品掉落音效
		 *
		 */
		public function playDropSound():void
		{
//			GameInstance.signal.sound.addGameSound.dispatch(itemTemplate.drop_sound);
		}

		/**
		 *物品获得音效
		 *
		 */
		public function playGetSound():void
		{
//			GameInstance.signal.sound.addGameSound.dispatch(itemTemplate.get_sound);
		}

		/**
		 *使用物品
		 *
		 */
		public function useObj(onReqSendSuccess:Function = null):Boolean
		{
			var reason:int = checkEnabled();
			if (reason == USE_FAIL_REASON_NONE)
			{
				if (!stateCheck())
				{
					return false;
				}
				var itemSignals:ItemSignal = MainFacade.instance.inject.getInstance(ItemSignal) as ItemSignal;
				itemSignals.itemPreUse.dispatch(this);
				if (!checkUseCondition(onReqSendSuccess) /*检查使用是否需要额外确认，如弹出框*/)
				{
					return false;
				}
				GameClient.sendItemUse(guId, slot);
				if (onReqSendSuccess != null)
				{
					onReqSendSuccess(this);
				}
				return true;
			}
			else
			{
				switch (reason)
				{
					case USE_FAIL_REASON_GENDER:
						MessageManager.instance.addHintById_client(6, "不满足性别需求，无法使用"); //不满足性别需求，无法使用
						break;
					case USE_FAIL_REASON_USERLEV:
						MessageManager.instance.addHintById_client(7, "不满足级别需求，无法使用"); //不满足级别需求，无法使用
						break;
					case USE_FAIL_REASON_PROFESSION:
						MessageManager.instance.addHintById_client(8, "不满足职业需求，无法使用"); //不满足职业需求，无法使用
						break;
				}
				return false;
			}
		}

		/**
		 * 在不弹出确认的前提下，使用物品
		 * @return
		 *
		 */
		public function useObjNotCheckUseEnsure(onReqSendSuccess:Function = null):Boolean
		{
			var reason:int = checkEnabled();
			if (reason == USE_FAIL_REASON_NONE)
			{
				if (!stateCheck())
				{
					return false;
				}
				GameClient.sendItemUse(guId, slot);
				if (onReqSendSuccess != null)
				{
					onReqSendSuccess(this);
				}
				return true;
			}
			else
			{
				switch (reason)
				{
					case USE_FAIL_REASON_GENDER:
						MessageManager.instance.addHintById_client(6, "不满足性别需求，无法使用"); //不满足性别需求，无法使用
						break;
					case USE_FAIL_REASON_USERLEV:
						MessageManager.instance.addHintById_client(7, "不满足级别需求，无法使用"); //不满足级别需求，无法使用
						break;
					case USE_FAIL_REASON_PROFESSION:
						MessageManager.instance.addHintById_client(8, "不满足职业需求，无法使用"); //不满足职业需求，无法使用
						break;
				}
				return false;
			}
		}

		/**
		 * 使用物品时的物品状态检查
		 * @return
		 *
		 */
		protected function stateCheck():Boolean
		{
			if (locked)
			{
				MessageManager.instance.addHintById_client(801, "该物品已锁定"); //该物品已锁定..
				return false;
			}
			if (GameInstance.mainCharData.isLimitItem)
			{
				MessageManager.instance.addHintById_client(3, "当前状态禁止使用物品"); //当前状态禁止使用物品..
				return false;
			}
			if (!checkCD())
			{
				return false;
			}
			if (validDate > 0 && getLastValidTime(new Date()) <= 0)
			{
				MessageManager.instance.addHintById_client(64, "该物品已失效"); //该物品已失效
				return false;
			}
			if (!isValidation())
			{
				MessageManager.instance.addHintById_client(70, "物品还没有到使用时间");
				return false;
			}
			return true;
		}

		/**
		 * 检查CD
		 * @return
		 *
		 */
		protected function checkCD():Boolean
		{
			if (_cdState && _cdState.inCD())
			{
				MessageManager.instance.addHintById_client(4, "物品 %s 冷却中", itemTemplate.name); //物品 %s 冷却中
				return false;
			}
			return true;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function get isInCD():Boolean
		{
			return _cdState.inCD();
		}

		/**
		 * 检查使用是否需要额外确认，如弹出框（派生类覆盖）
		 * @return true则在立即发送使用请求，false则不发送使用请求
		 *
		 */
		protected function checkUseCondition(onReqSendSuccess:Function = null):Boolean
		{
			return ItemOperateHelper.checkUse(this, onReqSendSuccess);
		}

		public function discardObj(check:Boolean = true):void
		{
			if (!_itemTemplate.is_can_drop)
			{
				MessageManager.instance.addHintById_client(9, "该物品不允许丢弃"); //该物品不允许丢弃
			}
			else
			{
				if (check && (isExpensive() || num > 1))
				{
					TAlertHelper.showDialog(23, "确定要丢弃 %s 吗？", true, TAlert.OK | TAlert.CANCEL, onDropOutEnsure, TAlert.OK, this.name);
				}
				else
				{
					GameClient.sendDropItem(guId, slot);
				}
			}
		}

		private function onDropOutEnsure(event:DataEvent):void
		{
			var flag:int = event.data as int;
			switch (flag)
			{
				case TAlert.OK:
					GameClient.sendDropItem(guId, slot);
					break;
			}
		}

		public function sendToChat():void
		{
//			if (!TWindowManager.instance.findPopup(HornInputPanel.NAME))
//				GameInstance.signal.chat.addLink.dispatch(new ChatItemLinkAdapter(this, 0));
//			else
//				GameInstance.signal.chat.addHornItemLink.dispatch(new ChatItemLinkAdapter(this, 0));
		}

		public function getQuality():int
		{
			return _itemTemplate.quality;
		}

		/**
		 * 检查目标物品是否可合并到当前物品
		 * @param target
		 * @return
		 *
		 */
		public function canCombine(target:ISlotItem):Boolean
		{
			var targetItem:ItemData = target as ItemData;
			return targetItem && targetItem.playerBinded == this.playerBinded && targetItem.templateId == this.templateId && this.num < this.itemTemplate.max_stack
				&& targetItem.validDate == this.validDate;
		}

		/**
		 * 开始CD
		 * @return
		 *
		 */
		public function startCD():void
		{
			playUseSound();
			if (_cdState)
			{
				_cdState.startCD(_itemTemplate.cd_time);
			}
		}

		/**
		 * 不使用CD
		 *
		 */
		public function disableCD():void
		{
			_cdState = null;
		}

		public function getColor():String
		{
			return ItemQuality.getColorString(this._itemTemplate.quality);
		}

		override public function get typeId():uint
		{
			return DataObjectType.ITEM;
		}

		override public function get templateId():int
		{
			return _itemTemplate.templateId;
		}

		public function get groupId():int
		{
			return _itemTemplate.groupId;
		}

		public function get cdState():CDState
		{
			return _cdState;
		}

		public function get needShowNum():Boolean
		{
			return _needShowNum;
		}

		public function set needShowNum(value:Boolean):void
		{
			_needShowNum = value;
		}

		public function get magicCrystalPrice():int
		{
			return itemTemplate.magic_crystal_price;
		}

		public function get moneyPrice():int
		{
			return itemTemplate.buy_price;
		}

		/**
		 * 是否是贵重物品
		 * @return
		 *
		 */
		public function isExpensive():Boolean
		{
			return itemTemplate.magic_crystal_price > ItemConst.ITEM_WORTH;
		}

		/**
		 * 所有者Id
		 * @return
		 *
		 */
		public function get ownerId():int
		{
			return _ownerId;
		}

		/**
		 * 是否可以设置到快捷栏
		 * @return
		 *
		 */
		public function get shortCutSendable():Boolean
		{
			return _ownerId == GameInstance.mainChar.id && guId != 0 && SlotItemManager.getSlotType(slot) == ItemConst.CONTAINER_BACKPACK && itemTemplate.can_be_use && type != ItemConst.TYPE_ITEM_TASK;
		}

		public function get type():int
		{
			return itemTemplate.type;
		}

		public function get canSale():Boolean
		{
			var saleConfig:SaleItemConfig = SalesroomConfigManager.getSaleItemConfig(itemTemplate.id);
			if (!saleConfig || !saleConfig.canSell)
			{
				return false;
			}
			else
			{
				return true;
			}
		}

		public function getNumStr(value:int):String
		{
			return value.toString();
		}

		public function get chatSendName():String
		{
			return this.name;
		}

		/**
		 * 物品是否是大药
		 * @return
		 *
		 */
		public function get isBigDrug():Boolean
		{
			return type == ItemConst.TYPE_ITEM_DRUG
				&& (itemTemplate.subtype == ItemConst.SUB_TYPE_DRUG_RED || itemTemplate.subtype == ItemConst.SUB_TYPE_DRUG_BLUE)
				&& itemTemplate.flag_2 != 0;
		}

		public function get max_stack():int
		{
			return itemTemplate.max_stack;
		}

		public function get subtype():int
		{
			return itemTemplate.subtype;
		}

		public function getCmpValue(name:String):int
		{
			if (name == "cmpId")
			{
				return getCmpId();
			}
			else
			{
				return itemTemplate[name] as int;
			}
		}

		private function getCmpId():int
		{
			switch (type)
			{
				case ItemConst.TYPE_EQUIP:
					switch (itemTemplate.subtype)
					{
						case ItemConst.SUB_TYPE_EQUIP_WEAPON:
							return 15;
						case ItemConst.SUB_TYPE_EQUIP_HELMET:
							return 14;
						case ItemConst.SUB_TYPE_EQUIP_CLOTH:
							return 13;
						case ItemConst.SUB_TYPE_EQUIP_WRISTER:
							return 12;
						case ItemConst.SUB_TYPE_EQUIP_SHOE:
							return 11;
						case ItemConst.SUB_TYPE_EQUIP_WAISTBAND:
							return 10;
						case ItemConst.SUB_TYPE_EQUIP_NECKLACE:
							return 9;
						case ItemConst.SUB_TYPE_EQUIP_RING:
							return 8;
						case ItemConst.SUB_TYPE_EQUIP_MEDAL:
							return 7;
						default:
							log.error("无效的装备subtype：" + itemTemplate.subtype);
							return 6;
					}
					break;
				case ItemConst.TYPE_ITEM_EGG:
				case ItemConst.TYPE_ITEM_PET_SEAL:
					return 4;
				case ItemConst.TYPE_ITEM_TASK:
					return 3;
				default:
					return 1;
			}
		}
	}
}
