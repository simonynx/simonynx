package fj1.modules.item.view.components.level2
{
	import assets.UIResourceLib;

	import fj1.common.EventDispatchCenter;
	import fj1.common.GameInstance;
	import fj1.common.data.dataobject.AwardData;
	import fj1.common.data.dataobject.items.ItemData;
	import fj1.common.data.dataobject.items.SystemPackData;
	import fj1.common.net.GameClient;
	import fj1.common.res.guide.vo.GuideConfig;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.staticdata.GuideConst;
	import fj1.common.staticdata.ItemConst;
	import fj1.common.ui.BaseWindow;
	import fj1.common.ui.boxes.BaseDataBox;
	import fj1.common.ui.boxes.BaseDataListItemRender;
	import fj1.manager.MessageManager;
	import fj1.modules.guide.helper.GuideHelper;
	import fj1.modules.item.events.PackQueryEvent;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import tempest.common.rsl.TRslManager;
	import tempest.ui.components.TAlert;
	import tempest.ui.components.TButton;
	import tempest.ui.components.TFixedList;
	import tempest.ui.effects.LoadingCoverEffect;
	import tempest.ui.events.ListEvent;
	import tempest.ui.events.TWindowEvent;

	public class SystemPackDialog extends BaseWindow
	{
		public static const NAME:String = "GiftPackPanel";
		private var _giftList:TFixedList;
		private var _btn_getAword:TButton;
		private var _giftListData:Array;
		private var _loadingEffect:LoadingCoverEffect;
		private var _sysPackItem:SystemPackData;
		private var _awardList:Array;

		private var _getAwordRequest:ISignal;

		public function get getAwordRequest():ISignal
		{
			return _getAwordRequest ||= new Signal();
		}

		public function get btn_getAword():TButton
		{
			return _btn_getAword;
		}

		public function SystemPackDialog()
		{
			super({horizontalCenter: 0, verticalCenter: 0}, TRslManager.getInstance(UIResourceLib.UI_GAME_GUI_GIFT_PACK), NAME);
			_btn_getAword = new TButton(null, _proxy.btn_getAword, LanguageManager.translate(29006, "领取奖励"), onEnsure);
			_giftList = new TFixedList(null, _proxy.mc_giftList, BaseDataListItemRender, "item", null, false, onRenderCreate);
			_giftList.addEventListener(Event.SELECT, onSelect);
			_loadingEffect = new LoadingCoverEffect(_giftList);
			this.addEventListener(TWindowEvent.WINDOW_SHOW, onWindowShow);
			this.addEventListener(TWindowEvent.WINDOW_CLOSE, onWindowClose)
		}

		private function onSelect(event:Event):void
		{
			if (_sysPackItem.itemTemplate.flag_1 != ItemConst.FLAG_1_WRAP_USER_SELECT)
			{
				return;
			}
			_btn_getAword.enabled = _giftList.selectedItem ? true : false;
		}

		private function onWindowShow(event:TWindowEvent):void
		{
			_loadingEffect.play();
			_sysPackItem = SystemPackData(event.data);
			_giftList.selectedIndex = -1;
			if (_sysPackItem.itemTemplate.flag_1 == ItemConst.FLAG_1_WRAP_USER_SELECT)
			{
				_giftList.selectable = true;
				_proxy.txt_descript.text = LanguageManager.translate(50460, "请选择一个您要领取的奖励");
			}
			else
			{
				_giftList.selectable = false;
				_proxy.txt_descript.text = LanguageManager.translate(50461, "请领取以下奖励");
			}
			EventDispatchCenter.getInstance().addEventListener(PackQueryEvent.PACK_QUERY_RESULT, onPackQueryResult);
			//查询奖励
			GameClient.sendPackSysQuery(_sysPackItem.guId);
		}

		private function onWindowClose(event:TWindowEvent):void
		{
			_loadingEffect.stop();
			_sysPackItem.locked = false;
			EventDispatchCenter.getInstance().removeEventListener(PackQueryEvent.PACK_QUERY_RESULT, onPackQueryResult);
		}

		/**
		 * 服务端查询结果返回
		 * @param event
		 *
		 */
		private function onPackQueryResult(event:PackQueryEvent):void
		{
			if (event.subtype != ItemConst.SUB_TYPE_WRAP_SYSTEM_PACK)
			{
				return;
			}
			_awardList = event.awardList;
			var _giftListData:Array = [];
			for each (var award:AwardData in _awardList)
			{
				_giftListData.push(award.itemData);
			}
			_giftList.items = _giftListData;
			_loadingEffect.stop();
		}

		private function onRenderCreate(event:ListEvent):void
		{
			var dataBox:BaseDataBox = BaseDataListItemRender(event.itemRender).dataBox;
			dataBox.dragImage.pickUpEnable = false;
		}

		private function onEnsure(event:MouseEvent):void
		{
			var giftItem:SystemPackData = SystemPackData(this.data);
			//发送礼包开启请求
			if (_sysPackItem.itemTemplate.flag_1 == ItemConst.FLAG_1_WRAP_USER_SELECT)
			{
				if (!_giftList.selectedItem)
				{
					return;
				}
				GameClient.sendPackUseChestAndOther(ItemConst.SUB_TYPE_WRAP_SYSTEM_PACK, _sysPackItem.guId, AwardData(_awardList[_giftList.selectedIndex]).awardId);
			}
			else
			{
				GameClient.sendPackUseChestAndOther(ItemConst.SUB_TYPE_WRAP_SYSTEM_PACK, _sysPackItem.guId, 0);
			}

			getAwordRequest.dispatch();
			this.closeWindow();
		}
	}
}
