package fj1.modules.newmail.controller
{
	import fj1.common.GameInstance;
	import fj1.manager.MessageManager;
	import fj1.modules.newmail.model.MailModel;
	import fj1.modules.newmail.service.MailService;
	import tempest.common.mvc.base.Command;

	public class MailDeleteCommand extends Command
	{
		[Inject]
		public var service:MailService;
		[Inject]
		public var model:MailModel;

		public override function getHandle():Function
		{
			return this.mailDelete;
		}

		/**
		 * 删除邮件
		 * @param arr 选中的邮件guid
		 *
		 */
		private function mailDelete(arr:Array):void
		{
			service.mailDelete(arr);
			model.delMailByIDArr(arr);
			MessageManager.instance.addHintById_client(2059, "删除邮件成功");
		}
	}
}
