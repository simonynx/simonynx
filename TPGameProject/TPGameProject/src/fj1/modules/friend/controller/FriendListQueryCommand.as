package fj1.modules.friend.controller
{
	import fj1.common.net.GameClient;
	import fj1.modules.friend.service.FriendService;

	import tempest.common.mvc.base.Command;

	/**
	 * 好友列表请求
	 * @author ouyanghechun
	 *
	 */
	public class FriendListQueryCommand extends Command
	{

		[Inject]
		public var service:FriendService;
		override public function execute():void
		{
			service.sendFriendRequest();
		}
	}
}


