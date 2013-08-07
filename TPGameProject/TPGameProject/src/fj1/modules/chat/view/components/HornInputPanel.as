package fj1.modules.chat.view.components
{
	import com.riaidea.text.RichTextField;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import assets.UIResourceLib;
	
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.staticdata.ChatConst;
	import fj1.common.ui.BaseWindow;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.natives.NativeSignal;
	
	import tempest.common.rsl.TRslManager;
	import tempest.common.staticdata.MovieClipResModel;
	import tempest.ui.FetchHelper;
	import tempest.ui.UIStyle;
	import tempest.ui.components.TButton;
	import tempest.ui.components.TGroup;
	import tempest.ui.components.TRadioButton;
	import tempest.ui.components.textFields.TRichTextField;
	import tempest.ui.events.FetchEvent;
	import tempest.ui.events.TWindowEvent;

	public class HornInputPanel extends BaseWindow
	{
		public var btn_face:TButton;
		public var btn_send:TButton;
		public var cbx_normal:TRadioButton;
		public var cbx_super:TRadioButton;
		public var rtf_input:TRichTextField;
		public var btn_buyNormal:TButton;
		public var btn_buySuper:TButton;
		public var smileylistPanel:SmileyListPanel;
		public var txtFormat:TextFormat;
		public var _group:TGroup;
		//
		private var _sendHorn:ISignal;
		private var _selectFace:ISignal;
		private var _rtfKeyDown:ISignal;
		private var _rtfKeyUp:ISignal;
		private var _rtfText:ISignal;
		private var _buyNormal:ISignal;
		private var _buySuper:ISignal;
		//
		public static const NAME:String = "HornInputPanel";

		public function HornInputPanel(_proxy:*)
		{
			super({horizontalCenter: 0, verticalCenter: 0}, /*TRslManager.getInstance(UIResourceLib.UI_GAME_GUI_BUYNUMDIALOG)*/_proxy, NAME);
			this.addEventListener(TWindowEvent.WINDOW_SHOW, onWindowShow);
			this.addEventListener(TWindowEvent.WINDOW_CLOSE, onWindowClose);
			this.fetchEnable = true;
			this.addEventListener(FetchEvent.FETCH, onFetch);
			isChangeSceneClose = true;
		}

		override protected function addChildren():void
		{
			super.addChildren();
			txtFormat = new TextFormat("Courier New", 12, UIStyle.NORMAL_TEXT, false, false, false);
			//输入框
			initChatInput();
			this.addChild(rtf_input);
			btn_buyNormal = new TButton(null, _proxy.btn_buyNormal, null);
			btn_buySuper = new TButton(null, _proxy.btn_buySuper, null);
			btn_face = new TButton(null, _proxy.btn_face, null);
			btn_face.toolTipString = LanguageManager.translate(12018, "点击选择表情");
			btn_send = new TButton(null, _proxy.btn_send, LanguageManager.translate(10024, "發送"));
			_group = new TGroup();
			cbx_normal = new TRadioButton(_group, null, _proxy.cbx_normal, null, MovieClipResModel.MODEL_FRAME_2);
			cbx_super = new TRadioButton(_group, null, _proxy.cbx_super, null, MovieClipResModel.MODEL_FRAME_2);
			smileylistPanel = new SmileyListPanel(btn_face);
		}

		private function initChatInput():void
		{
			rtf_input = new TRichTextField();
			rtf_input.x = _proxy.mc_msg.x;
			rtf_input.y = _proxy.mc_msg.y;
			rtf_input.html = true;
			rtf_input.setSize(_proxy.mc_msg.width, _proxy.mc_msg.height);
			rtf_input.type = RichTextField.INPUT;
			rtf_input.textfield.multiline = false;
			rtf_input.textfield.wordWrap = true;
			rtf_input.textfield.maxChars = ChatConst.MAX_HORN_INPUT;
			rtf_input.defaultTextFormat = txtFormat;
		}

		private function onFetch(event:FetchEvent):void
		{
			//保持提取状态 
			FetchHelper.instance.keepFetching();
		}

		private function onWindowShow(event:TWindowEvent):void
		{
			this.data = event.data;
			cbx_normal.select();
		}

		private function onWindowClose(event:TWindowEvent):void
		{
		}

		/**
		 * 设置文本框光标位置
		 * @param index
		 *
		 */
		public function setTextFieldSelection(index:int):void
		{
			this.addEventListener(Event.ENTER_FRAME, function(event:Event):void
			{
				event.currentTarget.removeEventListener(event.type, arguments.callee);
				rtf_input.textfield.setSelection(index, index); //光标设置到目标位置
			});
		}

		/**
		  * 设置焦点到聊天框
		  *
		  */
		public function setChatFocus():void
		{
			if (stage && stage.focus != rtf_input.textfield)
				stage.focus = rtf_input.textfield;
		}

		public function get rtfKeyDown():ISignal
		{
			return _rtfKeyDown ||= new NativeSignal(rtf_input, KeyboardEvent.KEY_DOWN, KeyboardEvent);
		}

		public function get rtfKeyUp():ISignal
		{
			return _rtfKeyUp ||= new NativeSignal(rtf_input, KeyboardEvent.KEY_UP, KeyboardEvent);
		}

		public function get rtfText():ISignal
		{
			return _rtfText ||= new NativeSignal(rtf_input.textfield, TextEvent.TEXT_INPUT, TextEvent)
		}

		public function get sendHorn():ISignal
		{
			return _sendHorn ||= new NativeSignal(btn_send, MouseEvent.CLICK, MouseEvent);
		}

		public function get selectFace():ISignal
		{
			return _selectFace ||= new NativeSignal(btn_face, MouseEvent.CLICK, MouseEvent);
		}

		public function get buyNormal():ISignal
		{
			return _buyNormal ||= new NativeSignal(btn_buyNormal, MouseEvent.CLICK, MouseEvent);
		}

		public function get buySuper():ISignal
		{
			return _buySuper ||= new NativeSignal(btn_buySuper, MouseEvent.CLICK, MouseEvent);
		}
	}
}
