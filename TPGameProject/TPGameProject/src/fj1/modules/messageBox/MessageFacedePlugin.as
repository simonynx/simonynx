package fj1.modules.messageBox
{
	import fj1.modules.messageBox.controller.MessageFacadeStartupCommand;
	import fj1.modules.messageBox.model.MessageModel;
	import fj1.modules.messageBox.signals.MessageSignal;
	import tempest.common.mvc.base.TFacadePlugin;

	public class MessageFacedePlugin extends TFacadePlugin
	{
		public function MessageFacedePlugin()
		{
			super();
		}

		override protected function startup():void
		{
			inject.mapSingleton(MessageSignal);
//			inject.mapSingleton(MailService);
			inject.mapSingleton(MessageModel);
			commandMap.map([this.startupSignal], MessageFacadeStartupCommand);
		}
	}
}
