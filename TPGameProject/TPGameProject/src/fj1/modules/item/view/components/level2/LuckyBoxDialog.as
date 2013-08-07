package fj1.modules.item.view.components.level2
{
	import assets.UIResourceLib;
	import assets.UISkinLib;
	import com.adobe.utils.ArrayUtil;
	import fj1.common.EventDispatchCenter;
	import fj1.common.data.dataobject.AwardData;
	import fj1.common.data.dataobject.items.ItemData;
	import fj1.common.data.dataobject.items.LuckyBoxData;
	import fj1.common.helper.TAlertHelper;
	import fj1.common.net.GameClient;
	import fj1.common.res.item.ItemTemplateManager;
	import fj1.common.res.item.LuckBoxAwardPool;
	import fj1.common.res.item.vo.ItemTemplate;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.staticdata.IconSizeType;
	import fj1.common.staticdata.ItemConst;
	import fj1.common.ui.BaseWindow;
	import fj1.common.ui.boxes.BaseDataBox;
	import fj1.common.ui.boxes.BaseDataListItemRender;
	import fj1.manager.BagItemManager;
	import fj1.manager.MessageManager;
	import fj1.manager.SlotItemManager;
	import fj1.modules.item.events.PackQueryEvent;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import tempest.common.rsl.TRslManager;
	import tempest.ui.collections.TFixedLayoutItemHolder;
	import tempest.ui.components.TAlert;
	import tempest.ui.components.TButton;
	import tempest.ui.components.TCombobox;
	import tempest.ui.components.TDefaultCombobox;
	import tempest.ui.components.TListItemRender;
	import tempest.ui.effects.LoadingCoverEffect;
	import tempest.ui.events.DataEvent;
	import tempest.ui.events.EffectEvent;
	import tempest.ui.events.ListEvent;
	import tempest.ui.events.TWindowEvent;
	import tempest.utils.Random;

	public class LuckyBoxDialog extends BaseWindow
	{
		public static const NAME:String = "LuckyBoxPanel";
		private static const STATE_BEFORE_START:int = 0;
		private static const STATE_PLAYING:int = 1;
		private static const STATE_STOPED:int = 2;
		private var _itemList:TFixedLayoutItemHolder;
		private var _btn_action:TButton;
		private var _awardData:AwardData; //抽中奖品
		private var _awardIndex:int; //抽中奖品索引
		private var _currentState:int; //当前状态
		private var _luckBoxData:LuckyBoxData; //宝箱物品
		private var _cbox_keyList:TCombobox; //宝箱钥匙列表
		private var _keyDataArray:Array; //宝箱钥匙列表数据
		private var _listEffect:LuckBoxSelectEffect;
		private var _awardShowEffect:MovieClip;
		private var _awardItemBox:BaseDataBox;
		public static var awordFoundEffect:MovieClip;
		public static var awardChangeEffect:*;

		public function LuckyBoxDialog()
		{
			super({horizontalCenter: 0, verticalCenter: 0}, TRslManager.getInstance(UIResourceLib.UI_GAME_GUI_LUCKY_BOX), NAME);
			_itemList = new TFixedLayoutItemHolder(_proxy, BaseDataListItemRender, "item", null, false, onItemRenderCreate);
			_itemList.addEventListener(Event.SELECT, onSelect);
			_cbox_keyList = new TDefaultCombobox(null, _proxy.mc_keyList);
			initEffects();
			_btn_action = new TButton(null, _proxy.btn_action, "", onAction);
			this.addEventListener(TWindowEvent.WINDOW_SHOW, onWindowShow);
			this.addEventListener(TWindowEvent.WINDOW_CLOSE, onWindowClose);
		}

		private function onSelect(event:Event):void
		{
			if (awardChangeEffect.parent)
			{
				awardChangeEffect.parent.removeChild(awardChangeEffect);
			}
			if (_itemList.selectedIndex < 0)
			{
				return;
			}
			var itemRender:BaseDataListItemRender = BaseDataListItemRender(_itemList.getItemRender(_itemList.selectedIndex));
			itemRender.addChild(awardChangeEffect);
		}

		private function initEffects():void
		{
			//初始化抽奖结果出现效果
			_awardShowEffect = _proxy.mc_awardShowEffect;
			_awardItemBox = new BaseDataBox(TRslManager.getInstance(UISkinLib.itemMoveBoxSkin));
			_awardItemBox.sizeType = IconSizeType.ICON72;
			_awardItemBox.pickUpEnabled = false;
			_awardItemBox.setSize(72, 72);
			_awardItemBox.enableCD = false;
			_awardItemBox.toolTip = null;
			_awardItemBox.enableLockState = false;
			_awardShowEffect.iconMc.addChild(_awardItemBox);
			_awardShowEffect.gotoAndStop(1);
			_awardShowEffect.addFrameScript(_awardShowEffect.totalFrames - 1, onAwordShowEffectComplete);
			_awardShowEffect.visible = false;
//			_awardShowEffect.mouseEnabled = false;
//			_awardShowEffect.mouseChildren = false;
			//
			_listEffect = new LuckBoxSelectEffect(this);
			_listEffect.addEventListener(EffectEvent.END, onSelectEffectEnd);
			awordFoundEffect = TRslManager.getInstance(UIResourceLib.awardFoundEffect);
			awordFoundEffect.gotoAndStop(1);
			awordFoundEffect.addFrameScript(awordFoundEffect.totalFrames - 1, onAwordFoundEffectComplete);
			awardChangeEffect = TRslManager.getInstance(UIResourceLib.awardChangeEffect);
		}

		public function get itemList():TFixedLayoutItemHolder
		{
			return _itemList;
		}

		private function onWindowShow(event:TWindowEvent):void
		{
			clean();
			_cbox_keyList.items = keyDataArray;
			_luckBoxData = LuckyBoxData(event.data);
			EventDispatchCenter.getInstance().addEventListener(PackQueryEvent.PACK_QUERY_RESULT, onPackQueryResult);
		}

		private function get keyDataArray():Array
		{
			if (!_keyDataArray)
			{
				var keyTemplateArray:Array = ItemTemplateManager.instance.findArray(function(keyTemplate:ItemTemplate):Boolean
				{
					return keyTemplate.type == ItemConst.TYPE_ITEM_WRAP && keyTemplate.subtype == ItemConst.SUB_TYPE_WRAP_KEY;
				});
				_keyDataArray = [];
				for each (var item:ItemTemplate in keyTemplateArray)
				{
					_keyDataArray.push(new KeyDropDownItem(item));
				}
			}
			return _keyDataArray;
		}

		private function onWindowClose(event:TWindowEvent):void
		{
			_cbox_keyList.items = null;
			_cbox_keyList.selectedIndex = -1;
			_luckBoxData.locked = false;
			EventDispatchCenter.getInstance().removeEventListener(PackQueryEvent.PACK_QUERY_RESULT, onPackQueryResult);
		}

		private function onSelectEffectEnd(event:EffectEvent):void
		{
			finish();
		}

		/**
		 * 服务端查询结果返回
		 * @param event
		 *
		 */
		private function onPackQueryResult(event:PackQueryEvent):void
		{
			if (event.subtype != ItemConst.SUB_TYPE_WRAP_LUCKY_BOX)
			{
				return;
			}
			//开始摇奖
			start(AwardData(event.awardList[0]));
		}

		private function onItemRenderCreate(event:ListEvent):void
		{
			var render:BaseDataListItemRender = BaseDataListItemRender(event.itemRender);
			render.addEventListener(Event.SELECT, onSelect);
			var dataBox:BaseDataBox = render.dataBox;
			dataBox.dragImage.pickUpEnable = false;
		}

		private function onAction(event:MouseEvent):void
		{
			switch (_currentState)
			{
				case STATE_BEFORE_START:
					if (!_cbox_keyList.selectedItem)
					{
						MessageManager.instance.addHintById_client(49, "请选择一个宝箱钥匙");
						return;
					}
					var keyData:ItemData = BagItemManager.instance.getFirstItemByTemplateId(KeyDropDownItem(_cbox_keyList.selectedItem).itemTemplate.id);
					if (!keyData)
					{
						MessageManager.instance.addHintById_client(50, "背包中不存在该宝箱钥匙，请到商城购买");
						return;
					}
					//请求开始摇奖
					_btn_action.enabled = false;
					GameClient.sendPackBuildAwordReq(ItemConst.SUB_TYPE_WRAP_LUCKY_BOX, 1, _luckBoxData.guId, keyData.guId);
					break;
				case STATE_PLAYING:
					//请求停止
					_listEffect.beginStop();
					_btn_action.enabled = false;
					break;
				case STATE_STOPED:
					var targetSlot:int = SlotItemManager.instance.getFristEmptySlot(ItemConst.CONTAINER_BACKPACK);
					if (targetSlot < 0)
					{
						MessageManager.instance.addHintById_client(802, "您的背包空间不够"); //您的背包空间不够
					}
					else
					{
						//请求领奖
						GameClient.sendPackUseChestAndOther(ItemConst.SUB_TYPE_WRAP_LUCKY_BOX, _luckBoxData.guId, _awardData.awardId);
						super.closeWindow();
					}
					break;
			}
		}

		/**
		 * 清空状态
		 *
		 */
		private function clean():void
		{
			_awardItemBox.data = null;
			_itemList.items = null;
			_listEffect.reset();
			_awardShowEffect.visible = false;
			_btn_action.text = LanguageManager.translate(29020, "开始抽奖");
			_currentState = STATE_BEFORE_START;
		}

		/**
		 * 开始摇奖
		 * @param awardData
		 *
		 */
		private function start(awardData:AwardData):void
		{
			_btn_action.enabled = true;
			_awardData = awardData;
			var awardListData:Array = LuckBoxAwardPool.getInstance().getDataList(_awardData.itemData.templateId, ItemConst.LUCK_BOX_SIZE - 1);
			_awardIndex = Random.range(0, ItemConst.LUCK_BOX_SIZE); //被抽中物品插入在随机的一个位置
			awardListData.splice(_awardIndex, 0, _awardData.itemData);
			//
			_itemList.items = awardListData;
			_listEffect.setAwordIndex(_awardIndex); //播放效果
			_listEffect.play();
			//宝箱物品已经消耗，解锁
			_luckBoxData.locked = false;
			_currentState = STATE_PLAYING;
			_btn_action.text = LanguageManager.translate(29021, "停止");
		}

		/**
		 * 摇奖结束
		 *
		 */
		private function finish():void
		{
			_itemList.selectedItem = _awardData.itemData;
			var render:TListItemRender = TListItemRender(_itemList.getItemRender(_awardIndex));
			if (awordFoundEffect.parent)
			{
				awordFoundEffect.parent.removeChild(awordFoundEffect);
			}
			render.addChild(awordFoundEffect);
			awordFoundEffect.play();
		}

		/**
		 * 列表上的奖品效果播放完毕
		 *
		 */
		private function onAwordFoundEffectComplete():void
		{
			if (awordFoundEffect.parent)
			{
				awordFoundEffect.parent.removeChild(awordFoundEffect);
			}
			awordFoundEffect.stop();
			_awardItemBox.data = _awardData.itemData;
			_awardShowEffect.visible = true;
			_awardShowEffect.gotoAndPlay(1);
		}

		/**
		 * 中央的奖品效果播放完毕
		 *
		 */
		private function onAwordShowEffectComplete():void
		{
			_awardShowEffect.stop();
			_currentState = STATE_STOPED;
			_btn_action.enabled = true;
			_btn_action.text = LanguageManager.translate(29022, "领奖");
		}

		override public function closeWindow():void
		{
			if (_currentState != STATE_BEFORE_START)
			{
				TAlertHelper.showDialog(27, "您还未领奖，关闭宝箱之后将放弃奖品，确定要关闭吗？", true, TAlert.OK | TAlert.CANCEL, onCloseEnsure);
			}
			else
			{
				super.closeWindow();
			}
		}

		private function onCloseEnsure(event:DataEvent):void
		{
			if (int(event.data) == TAlert.OK)
			{
				super.closeWindow();
			}
		}
	}
}
import fj1.common.res.item.vo.ItemTemplate;
import fj1.common.staticdata.ItemConst;
import fj1.modules.item.view.components.level2.LuckyBoxDialog;
import flash.display.DisplayObject;
import tempest.common.time.vo.TimerData;
import tempest.manager.TimerManager;
import tempest.ui.effects.BaseEffect;
import tempest.ui.events.EffectEvent;
import tempest.utils.Random;

class KeyDropDownItem
{
	private var _itemTemplate:ItemTemplate;

	public function KeyDropDownItem(itemTemplate:ItemTemplate)
	{
		_itemTemplate = itemTemplate;
	}

	public function get itemTemplate():ItemTemplate
	{
		return _itemTemplate;
	}

	public function get label():String
	{
		return _itemTemplate.name;
	}
}

class LuckBoxSelectEffect extends BaseEffect
{
	private var _luckyBox:LuckyBoxDialog;
	private var _timer:TimerData;
	private var _state:int;
	private var _stopingIntervalAddition:Number;
	private var _awordIndex:int;
	private var _startStopIndex:int;
	private static const STATE_START:int = 0;
	private static const STATE_STOP_REQUEST:int = 1;
	private static const STATE_STOPING:int = 2;
	private static const START_INTERVAL:int = 30;
	private static const STOPING_STEP_MIN:int = 7;
	private static const STOPING_STEP_MAX:int = 11;
	private static const STOPING_INTERVAL_MAX:int = 600;

	public function LuckBoxSelectEffect(target:LuckyBoxDialog)
	{
		super(target);
		_luckyBox = target;
		_timer = TimerManager.createNormalTimer(START_INTERVAL, 0, onTimer);
		this.addEventListener(EffectEvent.START, onStart);
		this.addEventListener(EffectEvent.END, onEnd);
	}

	override public function reset():void
	{
		super.reset();
		_timer.delay = START_INTERVAL;
		_state = STATE_START;
	}

	public function setAwordIndex(value:int):void
	{
		_awordIndex = value;
		var stopingStep:int = Random.range(STOPING_STEP_MIN, STOPING_STEP_MAX);
		_startStopIndex = _awordIndex - stopingStep;
		if (_startStopIndex < 0)
		{
			_startStopIndex = _startStopIndex + _luckyBox.itemList.items.length;
		}
		_stopingIntervalAddition = (STOPING_INTERVAL_MAX - START_INTERVAL) / stopingStep;
	}

	private function onStart(event:EffectEvent):void
	{
		_timer.start();
	}

	private function onEnd(event:EffectEvent):void
	{
		_timer.stop();
		_timer.delay = START_INTERVAL;
	}

	public function beginStop():void
	{
		_state = STATE_STOP_REQUEST;
	}

	private function onTimer():void
	{
		var nextIndex:int;
		switch (_state)
		{
			case STATE_START:
			case STATE_STOP_REQUEST:
				nextIndex = _luckyBox.itemList.selectedIndex + 1;
				if (nextIndex >= _luckyBox.itemList.items.length)
				{
					nextIndex = 0;
				}
				if (_state == STATE_STOP_REQUEST && nextIndex == _startStopIndex)
				{
					_state = STATE_STOPING;
					_timer.delay += _stopingIntervalAddition;
				}
				_luckyBox.itemList.selectedIndex = nextIndex;
				break;
			case STATE_STOPING:
				if (_timer.delay > STOPING_INTERVAL_MAX)
				{
					stop();
					return;
				}
				_timer.delay += _stopingIntervalAddition;
				nextIndex = _luckyBox.itemList.selectedIndex + 1;
				if (nextIndex >= _luckyBox.itemList.items.length)
				{
					nextIndex = 0;
				}
				_luckyBox.itemList.selectedIndex = nextIndex;
				break;
		}
	}
}
