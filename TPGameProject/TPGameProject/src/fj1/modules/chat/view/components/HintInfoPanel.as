package fj1.modules.chat.view.components
{
	import assets.UIHudLib;
	import com.gskinner.motion.GTweener;
	import com.riaidea.text.RichTextField;
	import fj1.common.GameInstance;
	import fj1.common.helper.MouseEventHepler;
	import fj1.common.res.hint.vo.HintData;
	import fj1.common.res.layoutDesign.LayoutDesignManager;
	import fj1.common.staticdata.ChatConst;
	import fj1.common.staticdata.HintConst;
	import fj1.common.staticdata.LayoutDesignConst;
	import fj1.common.ui.TextFieldMouseDownPlugin;
	import fj1.manager.MessageManager;
	import fj1.modules.chat.model.ChatHistoryHolder;
	import fj1.modules.chat.model.ChatListHistoryHolder;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextFormat;
	import tempest.common.rsl.TRslManager;
	import tempest.common.time.vo.TimerData;
	import tempest.manager.TimerManager;
	import tempest.ui.TPUGlobals;
	import tempest.ui.UIStyle;
	import tempest.ui.components.TComponent;
	import tempest.ui.components.TList2;
	import tempest.ui.components.textFields.TRichTextArea;
	import tempest.ui.components.textFields.TRichTextField;
	import tempest.ui.events.ListEvent;

	/**
	 * 系统提示区域
	 * @author linxun
	 *
	 */
	public class HintInfoPanel extends TComponent
	{
		public var bg:MovieClip;
		public var mc_hint_content:MovieClip;
		public var vscollbar0:Sprite;
		//------------------------------------------------------
//		protected var chatContent:TRichTextArea;
		private var _tlist2_chat_content:TList2;
		private var _historyHolder:ChatListHistoryHolder;
		private var _timerData:TimerData;

//		private var _cornerDragbar:TDragBar;
		public function HintInfoPanel()
		{
			super(LayoutDesignManager.getConstraintsByID(LayoutDesignConst.PANEL_HINT), TRslManager.getInstance(UIHudLib.UI_GAME_GUI_HINT));
			initOutput();
			bgAlpha = 0;
			MouseEventHepler.forwarding(_proxy.mc_hint_content, GameInstance.scene.interactiveLayer); //转移鼠标事件和焦点到场景
			MessageManager.registerChatShower(HintConst.HINT_PLACE_SYSTEM_HINT, showText);
			this.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			this.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
		}

		private function showText(hintData:HintData):void
		{
			appendMsg(hintData.content);
		}

		private function initOutput():void
		{
			_historyHolder = new ChatListHistoryHolder(ChatConst.MAX_LINE_HINT);
			_tlist2_chat_content = new TList2(null, _proxy.mc_hint_content, _proxy.vscollbar0, RichTextFieldRender);
			_tlist2_chat_content.scrollLineSize = 18;
			_tlist2_chat_content.verticalGap = -2;
			_tlist2_chat_content.autoScroll = true;
			_tlist2_chat_content.addEventListener(ListEvent.ITEM_RENDER_CREATE, onChatItemRenderCreate);
			_tlist2_chat_content.dataProvider = _historyHolder.historyList;
			_timerData = TimerManager.createNormalTimer(30000, 0, onTimer);
		}

		private function onTimer():void
		{
			_tlist2_chat_content.alpha = 0;
		}

		private function onChatItemRenderCreate(event:ListEvent):void
		{
			RichTextFieldRender(event.itemRender).rtf.addEventListener(TextEvent.LINK, onTextLink);
		}

		private function onTextLink(event:TextEvent):void
		{
		}

		public function appendMsg(str:String):void
		{
			_historyHolder.appendDialog(str);
			_timerData.reset();
			_timerData.start();
			_tlist2_chat_content.alpha = 1;
		}

		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		//自动隐藏
		private function onMouseOver(event:MouseEvent):void
		{
			GTweener.to(this, 0.5, {bgAlpha: 1});
			_timerData.reset();
			_timerData.stop();
			_tlist2_chat_content.alpha = 1;
		}

		private function onMouseOut(event:MouseEvent):void
		{
			GTweener.to(this, 0.2, {bgAlpha: 0});
			_timerData.reset();
			_timerData.start();
		}

		public function set bgAlpha(value:Number):void
		{
			_proxy.vscollbar0.alpha = value;
			_proxy.bg.alpha = value;
		}

		public function get bgAlpha():Number
		{
			return _proxy.bg.alpha;
		}
	}
}
import fj1.common.GameInstance;
import fj1.common.ui.TextFieldMouseDownPlugin;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import tempest.ui.UIStyle;
import tempest.ui.components.TListItemRender;
import tempest.ui.components.textFields.TRichTextField;

class RichTextFieldRender extends TListItemRender
{
	private var _rtf:TRichTextField;
	private var _txtFormat:TextFormat = new TextFormat(UIStyle.fontName, UIStyle.fontSize, UIStyle.YELLOW, false, false, false, null, null, null, null, null, null, 2);

	public function get rtf():TRichTextField
	{
		return _rtf;
	}

	public function RichTextFieldRender(proxy:* = null, data:Object = null)
	{
		super(proxy, data);
		_rtf = new TRichTextField(true);
		_rtf.html = true;
		_rtf.selectable = false;
		_rtf.defaultTextFormat = _txtFormat;
		_rtf.textfield.filters = [UIStyle.textBoundFilter];
		_rtf.textfield.autoSize = TextFieldAutoSize.LEFT;
		_rtf.textfield.mouseWheelEnabled = false;
		_rtf.setSize(150, 20);
		_rtf.addPlugin(new TextFieldMouseDownPlugin(GameInstance.scene.interactiveLayer));
		this.addChild(_rtf);
	}

	override public function set data(value:Object):void
	{
		super.data = value;
		_rtf.clear();
		_rtf.append(data as String);
		_rtf.setSize(_rtf.textfield.width, _rtf.textfield.height);
		this.measureChildren();
	}
}
