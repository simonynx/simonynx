package fj1.modules.friend.controller
{
	import fj1.common.helper.TAlertHelper;
	import fj1.common.net.GameClient;
	import fj1.common.staticdata.FriendConst;
	import fj1.modules.friend.service.FriendService;

	import tempest.common.mvc.base.Command;
	import tempest.ui.components.TAlert;
	import tempest.ui.events.TAlertEvent;

	public class DelBlackCommand extends Command
	{
		[Inject]
		public var service:FriendService;
		override public function getHandle():Function
		{
			return this.delBlack;
		}

		private var _guid:int;

		/**
		 * 刪除黑名單
		 * @param guild 被刪除人guid
		 *
		 */
		private function delBlack(guid:int):void
		{
			_guid = guid;
			TAlertHelper.showDialog(2016, "确定删除这个黑名单中的玩家", true, TAlert.YES | TAlert.NO, closeHandler);
		}

		private function closeHandler(event:TAlertEvent):void
		{
			if (event.flag == TAlert.YES)
			{
				service.sendFriendDelRequest(_guid, FriendConst.TYPE_BLACK);
			}
		}
	}
}


