package fj1.modules.item.view.components
{
	import assets.UIResourceLib;

	import fj1.common.res.lan.LanguageManager;
	import fj1.common.staticdata.ItemConst;
	import fj1.common.ui.BaseWindow;
	import fj1.modules.item.helper.ItemHelper;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.natives.NativeSignal;

	import tempest.common.rsl.TRslManager;
	import tempest.ui.collections.TPagedListCollection;
	import tempest.ui.components.TButton;
	import tempest.ui.components.TFixedList;
	import tempest.ui.components.TListItemRender;
	import tempest.ui.components.TRadioButton;
	import tempest.ui.components.TTabController;

	public class AwardDepotPanel extends BaseWindow
	{
		public static const NAME:String = "AwordDepotPanel";

//		public var bagLists:Object = {};
//		public var tabController:TTabController;

//		public var btn_tidyup:TButton; //整理
		public var btn_removeAll:TButton; //删除全部
		public var btn_moveAllToBag:TButton; //全部移入背包
		public var btn_moveAllToDepot:TButton; //全部移入仓库
		public var list:TFixedList;

		private var _tidyUp:ISignal;
		private var _removeAll:ISignal;
		private var _moveAllToBag:ISignal;
		private var _moveAllToDepot:ISignal;

//		/**
//		 * 整理
//		 * @return
//		 *
//		 */
//		public function get tidyUp():ISignal
//		{
//			return _tidyUp ||= new NativeSignal(btn_tidyup, MouseEvent.CLICK, MouseEvent);
//		}

		/**
		 * 删除全部
		 * @return
		 *
		 */
		public function get removeAll():ISignal
		{
			return _removeAll ||= new NativeSignal(btn_removeAll, MouseEvent.CLICK, MouseEvent);
		}

		/**
		 * 全部移入背包
		 * @return
		 *
		 */
		public function get moveAllToBag():ISignal
		{
			return _moveAllToBag ||= new NativeSignal(btn_moveAllToBag, MouseEvent.CLICK, MouseEvent);
		}

		/**
		 * 全部移入仓库
		 * @return
		 *
		 */
		public function get moveAllToDepot():ISignal
		{
			return _moveAllToDepot ||= new NativeSignal(btn_moveAllToDepot, MouseEvent.CLICK, MouseEvent);
		}

		public function AwardDepotPanel()
		{
			super({horizontalCenter: -140, verticalCenter: 0}, TRslManager.getInstance(UIResourceLib.UI_GAME_GUI_AWORDDEPOT), NAME);
		}

		override protected function addChildren():void
		{
			super.addChildren();
//			btn_tidyup = new TButton(null, _proxy.btn_tidyup, LanguageManager.translate(29012, "整理"));
			btn_removeAll = new TButton(null, _proxy.btn_removeAll, LanguageManager.translate(100054, "全部删除"));
			btn_moveAllToBag = new TButton(null, _proxy.btn_moveAllToBag, LanguageManager.translate(29030, "一键入包"));
			btn_moveAllToDepot = new TButton(null, _proxy.btn_moveAllToDepot, LanguageManager.translate(29031, "一键入库"));
			list = new TFixedList(null, _proxy.mc_bag0, DepotListItemRender, "item", new Array(ItemConst.AWORD_DEPOT_PAGE_SIZE), true);
//			tabController = new TTabController();
//			buildTab(0);
//			buildTab(1);
//			buildTab(2);
//			buildTab(3);
		}

		/**
		 * 获取背包格子对应的索引
		 * @param image
		 * @return
		 *
		 */
		public function getRenderIndex(image:DisplayObject):int
		{
			return TListItemRender.getParentRenderIndex(image);
//			return TListItemRender.getParentRenderIndex(image) + tabController.selectedIndex * ItemConst.AWORD_DEPOT_PAGE_SIZE;
		}

//		/**
//		 * 创建背包页
//		 * @param headName
//		 * @param pageindex
//		 *
//		 */
//		private function buildTab(pageindex:int):TRadioButton
//		{
//			var pageStr:String = pageindex.toString();
//			//列表
//			bagLists[pageindex] = new TFixedList(null, _proxy["mc_bag" + pageStr], DepotListItemRender, "item", new Array(ItemConst.AWORD_DEPOT_PAGE_SIZE), true);
//			//在列表上套上一层，加上拖放掉落监听
//			var tabHead:TRadioButton = tabController.addTab(_proxy["mc_tab" + pageStr], ItemHelper.getBagHeadText(pageindex), [bagLists[pageindex]]);
//			tabHead.data = pageindex;
//			return tabHead;
//		}
	}
}

import fj1.common.ui.boxes.BaseDataBox;
import fj1.common.ui.boxes.BaseDataListItemRender;
import fj1.modules.item.view.components.AwardDepotDataBox;
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
		_dataBox = new AwardDepotDataBox(_proxy);
	}
}

