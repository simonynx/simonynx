package fj1.modules.item.view.components
{
	import assets.UIResourceLib;

	import com.gskinner.motion.GTweener;

	import fj1.common.GameInstance;
	import tempest.common.rsl.RslManager;
	import fj1.common.data.dataobject.items.ItemData;
	import fj1.common.net.GameClient;
	import fj1.common.res.guide.vo.GuideConfig;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.staticdata.DragImagePlaces;
	import fj1.common.staticdata.FetchType;
	import fj1.common.staticdata.HintConst;
	import fj1.common.staticdata.ItemConst;
	import fj1.common.staticdata.MoneyType;
	import fj1.common.ui.BaseWindow;
	import fj1.common.ui.MoneyTypeIcon;
	import fj1.common.ui.TWindowManager;
	import fj1.common.ui.boxes.BaseDataListItemRender;
	import fj1.manager.BagItemManager;
	import fj1.manager.ItemNumCounterManager;
	import fj1.manager.MessageManager;
	import fj1.manager.SlotItemManager;
	import fj1.modules.item.events.ItemEvent;
	import fj1.modules.item.helper.ItemHelper;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	import mx.binding.utils.BindingUtils;

	import org.osflash.signals.natives.NativeSignal;

	import tempest.common.rsl.TRslManager;
	import tempest.common.staticdata.MovieClipResModel;
	import tempest.ui.ChangeWatcherManager;
	import tempest.ui.FetchHelper;
	import tempest.ui.collections.TArrayCollection;
	import tempest.ui.collections.TFixedLayoutItemHolder;
	import tempest.ui.collections.TPagedListCollection;
	import tempest.ui.components.IList;
	import tempest.ui.components.TAlert;
	import tempest.ui.components.TButton;
	import tempest.ui.components.TComponent;
	import tempest.ui.components.TDragableImage;
	import tempest.ui.components.TFixedList;
	import tempest.ui.components.TGroup;
	import tempest.ui.components.TList;
	import tempest.ui.components.TListItemRender;
	import tempest.ui.components.TRadioButton;
	import tempest.ui.components.TTabController;
	import tempest.ui.components.textFields.TText;
	import tempest.ui.events.DataChangeEvent;
	import tempest.ui.events.DataEvent;
	import tempest.ui.events.DragEvent;
	import tempest.ui.events.FetchEvent;
	import tempest.ui.events.ListEvent;
	import tempest.ui.events.TComponentEvent;
	import tempest.ui.events.TWindowEvent;
	import tempest.utils.Fun;
	import tempest.utils.Geom;

	/**
	 * ...
	 * @author wsk
	 */
	public class HeroBagPanel extends BaseWindow
	{
		/////////////////////////////////////////////////////////////////
		private static const TITYUP_CD:int = 20000;
		public var tabController:TTabController;
		public var lbl_bagSize:TextField; //背包大小显示
		public var tbtn_tidyup:TButton; //整理按钮
		public var tbtn_openShop:TButton; //前往商城
		public var btn_far_storage:TButton; //远程仓库
		public var btn_far_shop:TButton; //远程商店
		public var tlbl_money:TText;
		public var tlbl_magicCrystal:TText;
//		public var tlbl_magicStone:TText;
		public var tlbl_intergrate:TText;
		public var bagDataList:IList;
		public var bagDataListPageHelper:TPagedListCollection;
		public var group:TGroup;
		public var rbt_cate0:TRadioButton;
		public var rbt_cate1:TRadioButton;
		public var rbt_cate2:TRadioButton;
		public var rbt_cate3:TRadioButton;
		public var rbt_cate4:TRadioButton;
//		public var saleList:TFixedLayoutItemHolder;
		public var rbt_cate5:TRadioButton;
		public var _bagLists:Object = {};
		public static const NAME:String = "HeroBag";

		public function HeroBagPanel()
		{
			super({horizontalCenter: 300, verticalCenter: 0}, RslManager.getInstance(UIResourceLib.UI_GAME_GUI_HERO_BAG), NAME);
			this.addEventListener(TWindowEvent.WINDOW_SHOW, onWindowShow);
			this.addEventListener(TWindowEvent.WINDOW_CLOSE, onWindowClose);
			isChangeSceneClose = true;
		}

		private function onWindowClose(event:TWindowEvent):void
		{
		}

		private function onWindowShow(event:TWindowEvent):void
		{
		}

		override protected function init():void
		{
			super.init();
		}

		override protected function addChildren():void
		{
			super.addChildren();
			tabController = new TTabController();
			buildTab(0);
			buildTab(1);
			buildTab(2);
			lbl_bagSize = _proxy.lbl_bagSize;
			tbtn_tidyup = new TButton(null, _proxy.btn_tidyup, LanguageManager.translate(29012, "整理"));
			tbtn_openShop = new TButton(null, _proxy.btn_open_shop, LanguageManager.translate(29010, "商城"));
			btn_far_storage = new TButton(null, _proxy.btn_far_storage, LanguageManager.translate(29027, "仓库"));
			btn_far_shop = new TButton(null, _proxy.btn_far_shop, LanguageManager.translate(29028, "商店"));
			tlbl_money = new TText(null, _proxy.lbl_money, "", TextFieldAutoSize.NONE);
			tlbl_magicCrystal = new TText(null, _proxy.lbl_magicCrystal, "", TextFieldAutoSize.NONE);
//			tlbl_magicStone = new TText(null, _proxy.lbl_magicStone, "", TextFieldAutoSize.NONE);
			tlbl_intergrate = new TText(null, _proxy.lbl_intergrate, "", TextFieldAutoSize.NONE);
			//隐藏热销商品面板
//			_proxy.mc_onSalePanel.visible = false;
			new MoneyTypeIcon(_proxy.mc_iconMoney, MoneyType.MONEY);
			new MoneyTypeIcon(_proxy.mc_iconMagicCrystal, MoneyType.MAGIC_CRYSTAL);
//			new MoneyTypeIcon(_proxy.mc_iconMagicStone, MoneyType.MAGIC_STONE);
			group = new TGroup();
			rbt_cate0 = new TRadioButton(group, null, _proxy.mc_cate0, LanguageManager.translate(100022, "全部"), MovieClipResModel.MODEL_FRAME_4);
			rbt_cate0.data = ItemConst.FILTER_TYPE_NONE;
			rbt_cate1 = new TRadioButton(group, null, _proxy.mc_cate1, LanguageManager.translate(14002, "装备"), MovieClipResModel.MODEL_FRAME_4);
			rbt_cate1.data = ItemConst.FILTER_TYPE_EQUIP;
			rbt_cate2 = new TRadioButton(group, null, _proxy.mc_cate2, LanguageManager.translate(3044, "宠物"), MovieClipResModel.MODEL_FRAME_4);
			rbt_cate2.data = ItemConst.FILTER_TYPE_PET;
			rbt_cate3 = new TRadioButton(group, null, _proxy.mc_cate3, LanguageManager.translate(8043, "任务"), MovieClipResModel.MODEL_FRAME_4);
			rbt_cate3.data = ItemConst.FILTER_TYPE_TASK;
			rbt_cate4 = new TRadioButton(group, null, _proxy.mc_cate4, LanguageManager.translate(29011, "药水"), MovieClipResModel.MODEL_FRAME_4);
			rbt_cate4.data = ItemConst.FILTER_TYPE_DRAG;
			rbt_cate5 = new TRadioButton(group, null, _proxy.mc_cate5, LanguageManager.translate(29016, "其他"), MovieClipResModel.MODEL_FRAME_4);
			rbt_cate5.data = ItemConst.FILTER_TYPE_OTHER;
//			//商品列表
//			saleList = new TFixedLayoutItemHolder(_proxy.mc_saleList, SingleSaleItemRender, "mc_vip");
		}

		/**
		 * 创建背包页
		 * @param headName
		 * @param pageindex
		 *
		 */
		private function buildTab(pageindex:int):void
		{
			var pageStr:String = pageindex.toString();
			//列表
			_bagLists[pageindex] = new TFixedList(null, _proxy["mc_bag" + pageStr], BagListItemRender, "item", new Array(ItemConst.BAG_PAGE_SIZE));
			tabController.addTab(_proxy["mc_tab" + pageStr], ItemHelper.getBagHeadText(pageindex), [_bagLists[pageindex]]);
		}

		/**
		 * 获取背包格子对应的索引
		 * @param image
		 * @return
		 *
		 */
		public function getRenderIndex(image:DisplayObject):int
		{
			return TListItemRender.getParentRenderIndex(image) + tabController.selectedIndex * ItemConst.BAG_PAGE_SIZE;
		}
	}
}
