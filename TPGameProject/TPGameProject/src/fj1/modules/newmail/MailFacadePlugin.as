package fj1.modules.newmail
{
	import fj1.modules.newmail.controller.MailFacadeStartupCommand;
	import fj1.modules.newmail.model.MailModel;
	import fj1.modules.newmail.service.MailService;
	import fj1.modules.newmail.signals.MailSignal;
	import tempest.common.mvc.base.TFacadePlugin;

	public class MailFacadePlugin extends TFacadePlugin
	{
		public function MailFacadePlugin()
		{
			super();
		}

		override protected function startup():void
		{
			inject.mapSingleton(MailSignal);
			inject.mapSingleton(MailService);
			inject.mapSingleton(MailModel);
			commandMap.map([this.startupSignal], MailFacadeStartupCommand);
		}
	}
}
