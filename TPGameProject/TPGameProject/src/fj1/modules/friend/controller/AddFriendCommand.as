package fj1.modules.friend.controller
{
	import fj1.common.GameInstance;
	import fj1.common.staticdata.FriendConst;
	import fj1.manager.MessageManager;
	import fj1.modules.friend.model.FriendModel;
	import fj1.modules.friend.model.vo.FriendInfo;
	import fj1.modules.friend.service.FriendService;
	import tempest.common.mvc.base.Command;
	import tempest.ui.components.TAlert;
	import tempest.ui.events.TAlertEvent;

	/**
	 * ...
	 * @author ...
	 */
	public class AddFriendCommand extends Command
	{
		[Inject]
		public var service:FriendService;
		[Inject]
		public var model:FriendModel;

		override public function getHandle():Function
		{
			return this.addFriend;
		}

		private function addFriend(guid:int):void
		{
			if (GameInstance.mainChar.id == guid)
			{
				MessageManager.instance.addHintById_client(2013, "不能添加自己为好友");
				return;
			}
			if (model.getContainer(FriendConst.TYPE_FRIEND).length >= FriendInfo.FEIEND_MAX)
			{
				MessageManager.instance.addHintById_client(2007, "好友列表已满无法添加好友！");
				return;
			}
			if (model.getEntity(FriendConst.TYPE_FRIEND, guid))
			{
				MessageManager.instance.addHintById_client(2011, "你们已经是朋友了");
				return;
			}
			if (model.getEntity(FriendConst.TYPE_BLACK, guid))
			{
				MessageManager.instance.addHintById_client(2009, "此人已经在你的黑名单中");
				return;
			}
			if (model.getEntity(FriendConst.TYPE_ENEMY, guid))
			{
				MessageManager.instance.addHintById_client(2038, "此人已经在你的仇人列表中");
				return;
			}
			MessageManager.instance.addHintById_client(1924, "成功发送请求，等待对方响应");
			service.sendFriendAddRequest(guid);
		}
	}
}
