package fj1.modules.item.view.components
{
	import assets.UIResourceLib;

	import tempest.common.rsl.RslManager;
	import fj1.common.data.dataobject.HeroDepot;
	import fj1.common.data.dataobject.items.ItemData;
	import fj1.common.net.GameClient;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.staticdata.DragImagePlaces;
	import fj1.common.staticdata.FetchType;
	import fj1.common.staticdata.ItemConst;
	import fj1.common.staticdata.MoneyType;
	import fj1.common.ui.BaseWindow;
	import fj1.common.ui.MoneyTypeIcon;
	import fj1.common.ui.TWindowManager;
	import fj1.common.ui.boxes.BaseDataBox;
	import fj1.manager.BagItemManager;
	import fj1.modules.item.events.ItemEvent;
	import fj1.modules.item.helper.ItemHelper;
	import fj1.modules.item.view.components.level2.DepotMoneyEditDialog;
	import fj1.modules.item.view.components.level2.DepotSetPwdDialog;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;

	import mx.binding.utils.BindingUtils;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.natives.NativeSignal;

	import tempest.common.rsl.TRslManager;
	import tempest.engine.SceneCharacter;
	import tempest.engine.vo.map.MapTile;
	import tempest.ui.ChangeWatcherManager;
	import tempest.ui.FetchHelper;
	import tempest.ui.collections.TArrayCollection;
	import tempest.ui.collections.TPagedListCollection;
	import tempest.ui.components.*;
	import tempest.ui.events.*;
	import tempest.utils.Geom;

	public class HeroDepotPanel extends BaseWindow
	{
		public static const NAME:String = "HeroDepot";
		public var lbl_money:TextField;
		/////////////////////////////////////////////////////////////////
//		protected const TITYUP_CD:int = 20000;
		public var bagLists:Object = {};
		public var tabController:TTabController;
		public var lbl_depotSize:TextField; //仓库大小
		public var btn_tidyup:TButton; //整理
		public var btn_saveMoney:TButton; //存钱
		public var _btn_pwd:TButton; //密码修改
		public var _btn_getMoney:TButton; //取钱
		public var _btn_item:TButton; //物品存取

		public function HeroDepotPanel()
		{
			super({horizontalCenter: -140, verticalCenter: 0}, RslManager.getInstance(UIResourceLib.UI_GAME_GUI_HERO_DEPOT), NAME);
			isChangeSceneClose = true;
		}

		override protected function addChildren():void
		{
			super.addChildren();
			tabController = new TTabController();
			buildTab(0);
			buildTab(1);
			buildTab(2);
			lbl_depotSize = _proxy.lbl_depotSize;
			btn_tidyup = new TButton(null, _proxy.btn_tidyup, LanguageManager.translate(29012, "整理"));
			btn_saveMoney = new TButton(null, _proxy.btn_saveMoney, LanguageManager.translate(29017, "存钱"));
//			_btn_pwd = new TButton(null, _proxy.btn_pwd, LanguageManager.translate(29013, "设置密码"));
			_btn_getMoney = new TButton(null, _proxy.btn_getMoney, LanguageManager.translate(29014, "取钱"));
			_btn_item = new TButton(null, _proxy.btn_item, LanguageManager.translate(29015, "物品存取"));
			new MoneyTypeIcon(_proxy.mc_iconMoney, MoneyType.MONEY);
			lbl_money = _proxy.lbl_money;
//			new MoneyTypeIcon(_proxy.mc_iconMagicCrystal, MoneyType.MAGIC_CRYSTAL);
		}

		/**
		 * 创建背包页
		 * @param headName
		 * @param pageindex
		 *
		 */
		private function buildTab(pageindex:int):TRadioButton
		{
			var pageStr:String = pageindex.toString();
			//列表
			bagLists[pageindex] = new TFixedList(null, _proxy["mc_bag" + pageStr], DepotListItemRender, "item", new Array(ItemConst.DEPOT_PAGE_SIZE), true);
			//在列表上套上一层，加上拖放掉落监听
			var tabHead:TRadioButton = tabController.addTab(_proxy["mc_tab" + pageStr], ItemHelper.getBagHeadText(pageindex), [bagLists[pageindex]]);
			tabHead.data = pageindex;
			return tabHead;
		}

		/**
		 * 获取背包格子对应的索引
		 * @param image
		 * @return
		 *
		 */
		public function getRenderIndex(image:DisplayObject):int
		{
			return TListItemRender.getParentRenderIndex(image) + tabController.selectedIndex * ItemConst.DEPOT_PAGE_SIZE;
		}

		/**
		 *离开交谈
		 *
		 */
		public function onLeftTalk():void
		{
			var npc:SceneCharacter = this.data as SceneCharacter;
			if (npc)
			{
				checkTalkDistance(npc.tile, npc.id);
			}
		}
	}
}
import fj1.common.ui.boxes.BaseDataBox;
import fj1.common.ui.boxes.BaseDataListItemRender;
import fj1.modules.item.view.components.DepotDataBox;
import flash.display.DisplayObjectContainer;

class DepotListItemRender extends BaseDataListItemRender
{
	public function DepotListItemRender(_proxy:* = null, data:Object = null)
	{
		super(_proxy, data);
	}

	override protected function createBox():void
	{
		_dataBox = new DepotDataBox(_proxy);
	}
}
