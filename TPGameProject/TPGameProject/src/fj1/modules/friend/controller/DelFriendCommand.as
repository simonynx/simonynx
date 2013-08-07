package fj1.modules.friend.controller
{
	import fj1.common.GameInstance;
	import fj1.common.helper.TAlertHelper;
	import fj1.common.net.GameClient;
	import fj1.common.staticdata.FriendConst;
	import fj1.modules.friend.service.FriendService;

	import tempest.common.mvc.base.Command;
	import tempest.ui.components.TAlert;
	import tempest.ui.events.TAlertEvent;

	/**
	 * ...
	 * @author ...
	 */
	public class DelFriendCommand extends Command
	{
		[Inject]
		public var service:FriendService;
		override public function getHandle():Function
		{
			return this.delFriend;
		}

		private var _guid:int;

		private function delFriend(guid:int):void
		{
			_guid = guid;
			TAlertHelper.showDialog(2015, "确定删除这个好友", true, TAlert.YES | TAlert.NO, closeHandler);
		}

		private function closeHandler(event:TAlertEvent):void
		{
			if (event.flag == TAlert.YES)
			{
				service.sendFriendDelRequest(_guid, FriendConst.TYPE_FRIEND);
			}
		}
	}
}


