package fj1.modules.friend.controller
{
	import fj1.common.GameInstance;
	import fj1.common.helper.TAlertHelper;
	import fj1.common.net.GameClient;
	import fj1.common.staticdata.FriendConst;
	import fj1.manager.MessageManager;
	import fj1.modules.friend.model.FindInfo;
	import fj1.modules.friend.model.FriendModel;
	import fj1.modules.friend.service.FriendService;
	import tempest.common.mvc.base.Command;
	import tempest.ui.components.TAlert;
	import tempest.ui.events.TAlertEvent;

	/**
	 * ...
	 * @author ...
	 */
	public class AddBlackCommand extends Command
	{
		[Inject]
		public var service:FriendService;
		[Inject]
		public var model:FriendModel;

		override public function getHandle():Function
		{
			return this.addBlack;
		}
		private var getGuid:int;

		private function addBlack(guid:int):void
		{
			getGuid = guid;
			if (GameInstance.mainChar.id == guid)
			{
				MessageManager.instance.addHintById_client(2022, "不能把自己添加到黑名单");
				return;
			}
			if (model.getEntity(FriendConst.TYPE_FRIEND, guid))
			{
				TAlertHelper.showDialog(2021, "该玩家在你的好友列表中，是否确认加入黑名单", true, TAlert.YES | TAlert.NO, moveFriend);
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
			TAlertHelper.showDialog(2012, "确定将此人添加到黑名单中", true, TAlert.YES | TAlert.NO, closeHandler);
		}

		private function moveFriend(event:TAlertEvent):void
		{
			if (event.flag == TAlert.YES)
				//将好友移到黑名单
				service.sendFriendMoveToRequest(getGuid);
		}

		private function closeHandler(event:TAlertEvent):void
		{
			if (event.flag == TAlert.YES)
			{
				var findInfo:FindInfo = model.findInfo;
				var num:int;
				if (findInfo.online == FriendConst.TYPPE_OFFLINE)
					num = 0;
				else
					num = 1;
				service.sendBlackAddRequest(findInfo.guid, findInfo.name, findInfo.level, num);
			}
		}
	}
}
