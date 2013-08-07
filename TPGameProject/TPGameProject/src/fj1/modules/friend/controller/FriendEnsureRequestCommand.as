package fj1.modules.friend.controller
{
	import fj1.modules.friend.service.FriendService;

	import tempest.common.mvc.base.Command;

	public class FriendEnsureRequestCommand extends Command
	{
		[Inject]
		public var service:FriendService;

		override public function getHandle():Function
		{
			return this.ensureRequest;
		}

		private function ensureRequest(guid:int):void
		{
			service.sendFriendEnsureRequest(guid);
		}
	}
}

