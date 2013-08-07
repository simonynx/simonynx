package fj1.modules.chat
{
	import fj1.modules.chat.controller.ChatFacadeStartupCommand;
	import fj1.modules.chat.model.ChatModel;
	import fj1.modules.chat.service.ChatService;
	import fj1.modules.chat.singles.ChatSignal;
	import tempest.common.mvc.base.TFacadePlugin;

	public class ChatFacadePlugin extends TFacadePlugin
	{
		public function ChatFacadePlugin()
		{
			super();
		}

		override protected function startup():void
		{
			inject.mapSingleton(ChatSignal);
			inject.mapSingleton(ChatModel);
			inject.mapSingleton(ChatService);
			commandMap.map([this.startupSignal], ChatFacadeStartupCommand);
		}
	}
}
