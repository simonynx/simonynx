package fj1.modules.item.view.components.level2
{
	import assets.UIResourceLib;
	import assets.UISkinLib;

	import fj1.common.EventDispatchCenter;
	import fj1.common.GameInstance;
	import fj1.common.data.dataobject.AwardData;
	import fj1.common.data.dataobject.ItemNumCounter;
	import fj1.common.data.dataobject.items.ItemData;
	import fj1.common.data.dataobject.items.LotteryTicketData;
	import fj1.common.net.GameClient;
	import fj1.common.res.item.ItemTemplateManager;
	import fj1.common.res.item.vo.ItemTemplate;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.staticdata.ItemConst;
	import fj1.common.staticdata.ItemSpecailConst;
	import fj1.common.ui.BaseWindow;
	import fj1.common.ui.ScratchCard;
	import fj1.common.ui.TWindowManager;
	import fj1.manager.BagItemManager;
	import fj1.manager.ItemNumCounterManager;
	import fj1.manager.MessageManager;
	import fj1.modules.item.events.PackQueryEvent;
	import fj1.modules.mall.view.components.MallPanel;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	import tempest.common.rsl.TRslManager;
	import tempest.common.staticdata.MovieClipResModel;
	import tempest.ui.ChangeWatcherManager;
	import tempest.ui.CursorManager;
	import tempest.ui.components.TButton;
	import tempest.ui.components.TDefaultCombobox;
	import tempest.ui.components.TGroup;
	import tempest.ui.components.TRadioButton;
	import tempest.ui.events.DataEvent;
	import tempest.ui.events.TWindowEvent;

	public class LotteryPanel extends BaseWindow
	{
		public static const NAME:String = "LotteryPanel";
		public var btn_begin:SimpleButton;
		private var _btn_submit:TButton;
		private var _btn_begin:TButton;
		private var _scratchCard:ScratchCard;
		private var _txt_result:TextField;
		private var _combox_pen:TDefaultCombobox;
		private var _btn_buyPen:SimpleButton;
		private var _lotteryTickData:LotteryTicketData;
		private var _awardData:AwardData;
		private var _penTemplateList:Array = [];
		private static const STATE_BEFORD_START:int = 0;
		private static const STATE_STARTED:int = 1;
		private static const STATE_END:int = 2;
		private var _currentState:int; //当前状态
		private var _currentCursorLib:String;
		/**
		 * 显示铜魔法笔数量
		 */
		private var _txt_copper_brush:TextField;
		/**
		 * 显示银魔法笔数量
		 */
		private var _txt_silver_brush:TextField;
		/**
		 * 显示金魔法笔数量
		 */
		private var _txt_gold_brush:TextField;
		/**
		 * 铜魔法笔
		 */
		private var _cbox_copper_brush:TRadioButton;
		/**
		 * 银魔法笔
		 */
		private var _cbox_silver_brush:TRadioButton;
		/**
		 * 金魔法笔
		 */
		private var _cbox_gold_brush:TRadioButton;
		private var _group:TGroup;
		private var _copperNum:ItemNumCounter;
		private var _silverNum:ItemNumCounter;
		private var _goldNum:ItemNumCounter;
		private var _changeWatcherManger:ChangeWatcherManager = new ChangeWatcherManager();

		public function LotteryPanel()
		{
			super({horizontalCenter: 0, verticalCenter: 0}, TRslManager.getInstance(UIResourceLib.UI_GAME_GUI_LOTTERY_PANEL), NAME);
//			dragable = false;
			//魔法笔初始化
			initBrush();
			/*****************************按钮********************************/
			_btn_buyPen = _proxy.btn_buyPen;
			_btn_buyPen.addEventListener(MouseEvent.CLICK, onBuyClick);
			_btn_submit = new TButton(null, _proxy.btn_submit);
			_btn_submit.addEventListener(MouseEvent.CLICK, onSubmitClick);
			_btn_submit.addEventListener(MouseEvent.ROLL_OVER, onBeginRollOver);
			_btn_submit.addEventListener(MouseEvent.ROLL_OUT, onBeginRollOut);
			_btn_begin = new TButton(null, _proxy.btn_begin);
			_btn_begin.addEventListener(MouseEvent.CLICK, onBeginClick);
			/******************************************************************/
			_txt_result = _proxy.txt_result;
			_txt_result.autoSize = TextFieldAutoSize.CENTER;
			_proxy.mc_lotteryMask.parent.removeChild(_proxy.mc_lotteryMask);
			_proxy.txt_result.text = "";
			_scratchCard = new ScratchCard(0.8);
			_scratchCard.x = _proxy.mc_lotteryMask.x;
			_scratchCard.y = _proxy.mc_lotteryMask.y;
			this.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			this.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			this.addChild(_scratchCard);
			var brush:* = TRslManager.getInstance(UISkinLib.scratchBrushSkin);
			_scratchCard.setBrush(brush);
			_scratchCard.addEventListener(Event.COMPLETE, onComplete);
			this.addEventListener(TWindowEvent.WINDOW_SHOW, onWindowShow);
			this.addEventListener(TWindowEvent.WINDOW_CLOSE, onWindowClose);
		}

		private function initBrush():void
		{
			//显示魔法笔数量
			_txt_copper_brush = _proxy.txt_copper_brush;
			_txt_silver_brush = _proxy.txt_silver_brush;
			_txt_gold_brush = _proxy.txt_gold_brush;
			//魔法笔
			_group = new TGroup();
			var penTemplateArray:Array = ItemTemplateManager.instance.findArray(function(penTemplate:ItemTemplate):Boolean
			{
				return penTemplate.type == ItemConst.TYPE_ITEM_WRAP && penTemplate.subtype == ItemConst.SUB_TYPE_WRAP_PEN;
			}); //获取类型为魔法笔的物品模板列表
			for each (var penTemplate:ItemTemplate in penTemplateArray)
			{
				var penItem:PenDropDownItem = new PenDropDownItem(penTemplate)
				_penTemplateList.push(penItem);
				switch (penTemplate.id)
				{
					case ItemSpecailConst.ITEM_TEMPLATE_BRUSH_COPPER:
						_cbox_copper_brush = new TRadioButton(_group, null, _proxy.cbox_copper_brush, null, MovieClipResModel.MODEL_FRAME_4);
						_cbox_copper_brush.data = penItem;
						_cbox_copper_brush.select();
						break;
					case ItemSpecailConst.ITEM_TEMPLATE_BRUSH_SILVER:
						_cbox_silver_brush = new TRadioButton(_group, null, _proxy.cbox_silver_brush, null, MovieClipResModel.MODEL_FRAME_4);
						_cbox_silver_brush.data = penItem;
						break;
					case ItemSpecailConst.ITEM_TEMPLATE_BRUSH_GOLD:
						_cbox_gold_brush = new TRadioButton(_group, null, _proxy.cbox_gold_brush, null, MovieClipResModel.MODEL_FRAME_4);
						_cbox_gold_brush.data = penItem;
						break;
				}
			}
			//绑定各个魔法笔的数量
			_copperNum = ItemNumCounterManager.instance.getCounter(ItemSpecailConst.ITEM_TEMPLATE_BRUSH_COPPER);
			_silverNum = ItemNumCounterManager.instance.getCounter(ItemSpecailConst.ITEM_TEMPLATE_BRUSH_SILVER);
			_goldNum = ItemNumCounterManager.instance.getCounter(ItemSpecailConst.ITEM_TEMPLATE_BRUSH_GOLD);
			_changeWatcherManger.bindSetter(setCopperNum, _copperNum, "num");
			_changeWatcherManger.bindSetter(setSilverNum, _silverNum, "num");
			_changeWatcherManger.bindSetter(setGoldNum, _goldNum, "num");
		}

		private function setCopperNum(value:int):void
		{
			_txt_copper_brush.text = value.toString();
		}

		private function setSilverNum(value:int):void
		{
			_txt_silver_brush.text = value.toString();
		}

		private function setGoldNum(value:int):void
		{
			_txt_gold_brush.text = value.toString();
		}

		private function onBeginRollOver(event:MouseEvent):void
		{
			if (_currentState == STATE_STARTED)
			{
				CursorManager.instance.removeCursor(_currentCursorLib);
			}
		}

		private function onBeginRollOut(event:MouseEvent):void
		{
			if (_currentState == STATE_STARTED)
			{
				CursorManager.instance.setCursor(_currentCursorLib);
			}
		}

		private function onRollOver(event:MouseEvent):void
		{
			if (_currentState == STATE_STARTED)
			{
				CursorManager.instance.setCursor(_currentCursorLib);
			}
		}

		private function onRollOut(event:MouseEvent):void
		{
			if (_currentState == STATE_STARTED)
			{
				CursorManager.instance.removeCursor(_currentCursorLib);
			}
		}

		private function onWindowShow(event:TWindowEvent):void
		{
			_cbox_copper_brush.select();
			_lotteryTickData = LotteryTicketData(event.data);
			clean();
			EventDispatchCenter.getInstance().addEventListener(PackQueryEvent.PACK_QUERY_RESULT, onPackQueryResult);
		}

		private function clean():void
		{
			_scratchCard.resetMask(_proxy.mc_lotteryMask);
//			_scratchCard.resetMask2(252, 49, 0xFFFFFF);
			_scratchCard.endScratch();
			_btn_submit.enabled = false;
			_btn_begin.enabled = true;
			tbtn_close.enabled = true;
			_currentState = STATE_BEFORD_START;
		}

		private function onWindowClose(event:TWindowEvent):void
		{
			EventDispatchCenter.getInstance().removeEventListener(PackQueryEvent.PACK_QUERY_RESULT, onPackQueryResult);
		}

		private function onBuyClick(event:MouseEvent):void
		{
			var penDropDownData:PenDropDownItem = _group.selectedButton.data as PenDropDownItem;
			if (!penDropDownData)
			{
				return;
			}
			GameInstance.signal.mall.queryItem.dispatch(penDropDownData.itemTemplate.id);
		}

		private function onPackQueryResult(event:PackQueryEvent):void
		{
			if (event.subtype != ItemConst.SUB_TYPE_WRAP_LOTTERY_TICKET)
			{
				return;
			}
			_awardData = AwardData(event.awardList[0]);
			//开始刮
			begingScratch(_awardData.getDescription());
		}

		private function onComplete(event:Event):void
		{
			_btn_submit.enabled = true;
		}

		/**
		 * 请求刮
		 * @param event
		 *
		 */
		private function onBeginClick(event:MouseEvent):void
		{
			var penDropDownData:PenDropDownItem = _group.selectedButton.data as PenDropDownItem;
			if (!penDropDownData)
			{
				MessageManager.instance.addHintById_client(41, "请选择一个魔法笔");
				return;
			}
			var penData:ItemData = BagItemManager.instance.getFirstItemByTemplateId(penDropDownData.itemTemplate.templateId);
			if (!penData)
			{
				MessageManager.instance.addHintById_client(42, "背包中不存在该魔法笔，请到商城购买");
				return;
			}
			_btn_begin.enabled = false;
			_currentCursorLib = penDropDownData.getCursorLib(); //获取当前选中魔法笔资源的名称
			GameClient.sendPackBuildAwordReq(ItemConst.SUB_TYPE_WRAP_LOTTERY_TICKET, 1, _lotteryTickData.guId, penData.guId);
		}

		private function onSubmitClick(event:MouseEvent):void
		{
			if (_scratchCard.completed)
			{
				//发送完成请求
				_scratchCard.endScratch();
				this._currentState = STATE_END;
				CursorManager.instance.removeCursor(_currentCursorLib);
				super.closeWindow();
				GameClient.sendPackUseChestAndOther(ItemConst.SUB_TYPE_WRAP_LOTTERY_TICKET, _lotteryTickData.guId, _awardData.awardId);
			}
		}

		/**
		 * 开始刮奖
		 * @param itemDescript
		 *
		 */
		private function begingScratch(itemDescript:String):void
		{
			_currentState = STATE_STARTED;
			tbtn_close.enabled = false;
			CursorManager.instance.setCursor(_currentCursorLib);
			_txt_result.text = itemDescript;
			var txtBound:Rectangle = _txt_result.getBounds(_scratchCard);
			_scratchCard.setKeyArea(new Rectangle(txtBound.x, txtBound.y, _txt_result.textWidth, txtBound.height));
			_scratchCard.beginScratch();
		}

		override public function closeWindow():void
		{
			//屏蔽默认关闭窗口处理
			if (_currentState == STATE_BEFORD_START)
			{
				super.closeWindow();
			}
		}
	}
}
import assets.CursorLib;
import fj1.common.data.dataobject.items.ItemData;
import fj1.common.res.item.vo.ItemTemplate;
import fj1.common.staticdata.ItemSpecailConst;

class PenDropDownItem
{
	private var _itemTemplate:ItemTemplate;

	public function PenDropDownItem(itemTemplate:ItemTemplate)
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

	public function getCursorLib():String
	{
		switch (_itemTemplate.id)
		{
			case ItemSpecailConst.ITEM_TEMPLATE_BRUSH_COPPER:
				return CursorLib.SCRATCH1;
			case ItemSpecailConst.ITEM_TEMPLATE_BRUSH_SILVER:
				return CursorLib.SCRATCH2;
			case ItemSpecailConst.ITEM_TEMPLATE_BRUSH_GOLD:
				return CursorLib.SCRATCH3;
			default:
				return CursorLib.SCRATCH1;
		}
	}
}
