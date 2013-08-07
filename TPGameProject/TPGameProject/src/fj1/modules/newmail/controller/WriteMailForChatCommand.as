package fj1.modules.newmail.controller
{
	import fj1.common.GameInstance;
	import fj1.common.ui.TWindowManager;
	import fj1.manager.MessageManager;
	import fj1.modules.newmail.model.MailModel;
	import fj1.modules.newmail.signals.MailSignal;
	import fj1.modules.newmail.view.components.MailTabPanel;

	import tempest.common.mvc.base.Command;

	public class WriteMailForChatCommand extends Command
	{
		[Inject]
		public var model:MailModel;
		[Inject]
		public var signal:MailSignal;

		override public function getHandle():Function
		{
			return this.writeMailForChat;
		}

		/**
		 * 从聊天框里点击发送邮件
		 * @param name 收件人名字
		 *
		 */
		private function writeMailForChat(name:String):void
		{
			if (GameInstance.mainCharData.name == name)
			{
				MessageManager.instance.addHintById_client(2051, "不能发邮件给自己");
				return;
			}
			if (TWindowManager.instance.findPopup(MailTabPanel.NAME))
			{
				TWindowManager.instance.removePopupByName(MailTabPanel.NAME);
			}
			model.chatName = name;
			signal.showMailPanel.dispatch(1);
		}
	}
}


