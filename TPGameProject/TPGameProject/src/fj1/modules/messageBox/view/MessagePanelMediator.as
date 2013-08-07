package fj1.modules.messageBox.view
{
	import assets.WindowTitleLib;
	import fj1.common.res.lan.LanguageManager;
	import fj1.manager.FloatIconManager;
	import fj1.modules.messageBox.model.MessageModel;
	import fj1.modules.messageBox.model.vo.MessageInfo;
	import fj1.modules.messageBox.signals.MessageSignal;
	import fj1.modules.messageBox.view.components.MessageListItemRander;
	import fj1.modules.messageBox.view.components.MessagePanel;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import tempest.common.mvc.base.Mediator;
	import tempest.ui.collections.TArrayCollection;
	import tempest.ui.events.ListEvent;
	import tempest.ui.events.TWindowEvent;

	public class MessagePanelMediator extends Mediator
	{
		[Inject]
		public var messagePanel:MessagePanel
		[Inject]
		public var messageModel:MessageModel;
		[Inject]
		public var messageSignal:MessageSignal;
		private var messageArr:TArrayCollection;

		public function MessagePanelMediator()
		{
			super();
		}

		override public function onRegister():void
		{
			addSignal(messagePanel.agree, onAgree);
			addSignal(messagePanel.disagree, onDisagree);
			addSignal(messageSignal.closeMessageBoxPanel, onCloseMessageBoxPanel);
			messagePanel.addEventListener(TWindowEvent.WINDOW_SHOW, onWindowShow);
			messagePanel.messageListPanel.addEventListener(ListEvent.ITEM_RENDER_CREATE, onRenderCreate);
		}

		private function onRenderCreate(event:ListEvent):void
		{
			var itemRender:MessageListItemRander = event.itemRender as MessageListItemRander;
			itemRender.btn_agree.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				delItemList(itemRender.messageInfo);
				itemRender.messageInfo.agreeFun(itemRender.data);
			}
			);
			itemRender.btn_repulse.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				delItemList(itemRender.messageInfo);
				itemRender.messageInfo.disagreeFun(itemRender.data);
			}
			);
		}

		private function delItemList(messageInfo:MessageInfo):void
		{
			var arr:TArrayCollection = messageModel.findArr(messageInfo.kind);
			messageModel.delData(arr, messageInfo.id);
			if (arr.length == 0)
			{
				var mc:DisplayObject = FloatIconManager.instance.myImgArea.getChildByName(messageModel.getMessageBoxNameByKind(messageInfo.kind));
				FloatIconManager.instance.myImgArea.delArr(mc);
				//删除图标
				FloatIconManager.instance.myImgArea.removeChild(mc);
				//删除窗口
				onCloseMessageBoxPanel();
			}
		}

		/**
		 * 关闭消息盒子
		 *
		 */
		private function onCloseMessageBoxPanel():void
		{
			messagePanel.closeWindow();
		}

		override public function onRemove():void
		{
			messagePanel.removeEventListener(TWindowEvent.WINDOW_SHOW, onWindowShow);
			messagePanel.messageListPanel._messageList.dataProvider = null;
		}

		private function onWindowShow(event:TWindowEvent):void
		{
			switch (messagePanel.data)
			{
				case FloatIconManager.NAME_FRIEND:
					messageArr = messageModel.friendMessage;
					messagePanel.btn_All_OK.enabled = true;
					messagePanel.setTitle(WindowTitleLib.getTitleClass(LanguageManager.translate(1010, "好友消息")));
					break;
				case FloatIconManager.NAME_TEAM:
					messageArr = messageModel.teamMessage;
					messagePanel.btn_All_OK.enabled = true;
					messagePanel.setTitle(WindowTitleLib.getTitleClass(LanguageManager.translate(1011, "组队消息")));
					break;
				case FloatIconManager.NAME_TRADE:
					messageArr = messageModel.tradeMessage;
					messagePanel.btn_All_OK.enabled = false;
					messagePanel.setTitle(WindowTitleLib.getTitleClass(LanguageManager.translate(1012, "交易消息")));
					break;
				case FloatIconManager.NAME_GUILD:
					messageArr = messageModel.guildMessage;
					messagePanel.btn_All_OK.enabled = false;
					messagePanel.setTitle(WindowTitleLib.getTitleClass(LanguageManager.translate(1043, "公会消息")));
					break;
			}
			messagePanel.messageListPanel._messageList.dataProvider = messageArr;
		}

		private function onAgree(e:MouseEvent):void
		{
			messageSignal.messageBoxAll.dispatch(messageArr, MessageInfo.MESSAGE_ALL_AGREE, String(messagePanel.data));
		}

		private function onDisagree(e:MouseEvent):void
		{
			messageSignal.messageBoxAll.dispatch(messageArr, MessageInfo.MESSAGE_ALL_DISAGREE, String(messagePanel.data));
		}
	}
}
