package fj1.modules.chat.individualChat
{
	import assets.UIResourceLib;
	import fj1.modules.chat.model.ChatHistoryHolder;
	import fj1.common.ui.BaseWindow;
	import fj1.manager.IndividualChatMsgManager;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import tempest.common.rsl.TRslManager;
	import tempest.core.IPoolClient;
	import tempest.ui.components.textFields.TRichTextArea;
	import tempest.ui.events.DataEvent;
	import tempest.ui.events.TWindowEvent;

	/**
	 * 私聊对话框
	 */
	public class IndividualChatPanel extends BaseWindow implements IPoolClient
	{
		private var _rtext_chatContent:TRichTextArea; //内容显示
		private var _rtext_chatInput:TRichTextArea; //内容输入
		private var _chathistory:ChatHistoryHolder;
		public static const POOL_NAME:String = "IndividualChatPool";

		public function IndividualChatPanel()
		{
			super({horizontalCenter: 300, verticalCenter: 0}, TRslManager.getInstance(UIResourceLib.UI_GAME_GUI_PRIVATE_CHAT), null);
			this.addEventListener(TWindowEvent.WINDOW_SHOW, onWindowShow);
			this.addEventListener(TWindowEvent.WINDOW_CLOSE, onWindowClose);
			_proxy.btn_send.addEventListener(MouseEvent.CLICK, onSendClick);
			_proxy.btn_cancel.addEventListener(MouseEvent.CLICK, onCancelClick);
		}

		override protected function addChildren():void
		{
			super.addChildren();
			_rtext_chatContent = new TRichTextArea();
			_rtext_chatContent.move(_proxy.mc_chatContent.x, _proxy.mc_chatContent.y);
			_rtext_chatContent.setSize(_proxy.mc_chatContent.width, _proxy.mc_chatContent.height);
			_rtext_chatInput = new TRichTextArea();
			_rtext_chatInput.move(_proxy.mc_input.x, _proxy.mc_input.y);
			_rtext_chatInput.setSize(_proxy.mc_input.width, _proxy.mc_input.height);
		}

		public function reset(args:Array):void
		{
			_rtext_chatContent.clear();
			_rtext_chatInput.clear();
		}

		private function onWindowShow(event:TWindowEvent):void
		{
			var playerId:int = int(event.data);
			_chathistory = IndividualChatMsgManager.getInstance().getHistory(playerId);
			_chathistory.addEventListener(DataEvent.DATA, onHistoryChange);
		}

		private function onSendClick(event:MouseEvent):void
		{
			//发送私聊包
		}

		private function onCancelClick(event:MouseEvent):void
		{
			this.closeWindow();
		}

		/**
		 * 文本变化
		 * @param event
		 *
		 */
		private function onHistoryChange(event:DataEvent):void
		{
			_rtext_chatContent.clear();
			_rtext_chatContent.append(String(event.data));
		}

		private function onWindowClose(event:TWindowEvent):void
		{
			_chathistory.removeEventListener(DataEvent.DATA, onHistoryChange);
		}
	}
}
