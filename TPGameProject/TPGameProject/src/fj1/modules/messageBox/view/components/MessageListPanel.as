package fj1.modules.messageBox.view.components
{
	import assets.UIResourceLib;
	import tempest.common.rsl.RslManager;
	import tempest.ui.components.TComponent;
	import tempest.ui.components.TList;

	public class MessageListPanel extends TComponent
	{
		public var _messageList:TList;

		public function MessageListPanel(_proxy:* = null)
		{
			super(null, _proxy);
		}

		override protected function addChildren():void
		{
			_messageList = new TList(null, _proxy.mc_list, _proxy.scroll, MessageListItemRander, RslManager.getDefinition(UIResourceLib.MessageItem));
		}
	}
}
