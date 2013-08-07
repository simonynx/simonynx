package fj1.modules.newmail.view
{
	import fj1.common.GameInstance;
	import fj1.common.ui.TWindowManager;
	import fj1.modules.item.signals.ItemSignal;
	import fj1.modules.newmail.model.MailModel;
	import fj1.modules.newmail.service.MailService;
	import fj1.modules.newmail.signals.MailSignal;
	import fj1.modules.newmail.view.components.MailTabPanel;
	import tempest.common.mvc.base.Mediator;
	import tempest.ui.events.TabControllerEvent;

	public class MailTabPanelMediator extends Mediator
	{
		[Inject]
		public var view:MailTabPanel;
		[Inject]
		public var model:MailModel;
		[Inject]
		public var signal:MailSignal;
		[Inject]
		public var service:MailService;
		[Inject]
		public var itemSignal:ItemSignal;
		private var _inited:Boolean;
		private var inboxPanelMediator:InboxPanelMediator;
		private var outboxPanelMediator:OutboxPanelMediator;

		public function MailTabPanelMediator()
		{
			super();
		}

		override public function onRegister():void
		{
			if (!_inited)
			{
				inboxPanelMediator = new InboxPanelMediator(view.mailListPanel, inject);
				outboxPanelMediator = new OutboxPanelMediator(view, inject);
				_inited = true;
			}
			view.tabController.addEventListener(TabControllerEvent.CHANGE, onChangeTab); //改变选项卡
			if (model.chatName == "")
				view.tabController.selectedIndex = 0;
			else
				view.tabController.selectedIndex = 1;
			onChangeTab(null);
			addSignal(signal.replyMail, replyMail);
		}

		/**
		 * 回复邮件
		 * @param replyName
		 * @param replyTitle
		 *
		 */
		private function replyMail(replyName:String, replyTitle:String):void
		{
			if (view.tabController.selectedIndex != 1)
				view.tabController.selectedIndex = 1;
			signal.setNameAndTitle.dispatch(replyName, replyTitle);
		}

		private function onChangeTab(event:TabControllerEvent):void
		{
			if (view.tabController.selectedIndex == 1)
				itemSignal.showHeroBag.dispatch(TWindowManager.MODEL_USE_OLD);
			else
				requestMailList();
		}

		/**
		 * 请求邮件列表
		 *
		 */
		private function requestMailList():void
		{
			if (model.mailListArr.length == 0)
			{
				service.sendRequestAllMail(0);
			}
			else
			{
				for (var i:int = 0; i < model.guidArr.length; i++)
				{
					service.sendRequestAllMail(model.guidArr[i]);
				}
			}
			model.guidArr = [];
		}

		override public function onRemove():void
		{
			view.tabController.selectedIndex = -1;
			model.initSelectState();
		}
	}
}
