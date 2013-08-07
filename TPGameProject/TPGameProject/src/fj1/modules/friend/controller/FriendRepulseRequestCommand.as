package fj1.modules.friend.controller
{
	import fj1.manager.MessageManager;
	import fj1.modules.friend.service.FriendService;

	import tempest.common.mvc.base.Command;

	public class FriendRepulseRequestCommand extends Command
	{
		[Inject]
		public var service:FriendService;

		override public function getHandle():Function
		{
			return this.sendRepulseRequest;
		}

		/**
		 * 拒绝好友请求
		 * @param guid
		 *
		 */		
		private function sendRepulseRequest(guid:int,name:String):void
		{
			service.sendRepulseRequest(guid);
			MessageManager.instance.addHintById_client(2004, "你拒绝了%s的好友请求", name);
		}
	}
}

