package fj1.modules.friend.controller
{
	import fj1.common.GameInstance;
	import fj1.common.helper.TAlertHelper;
	import fj1.common.net.GameClient;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.staticdata.FriendConst;
	import fj1.manager.MessageManager;
	import fj1.modules.friend.model.FindInfo;
	import fj1.modules.friend.model.FriendModel;
	import fj1.modules.friend.model.vo.EnemyInfo;
	import fj1.modules.friend.model.vo.FriendInfo;
	import fj1.modules.friend.service.FriendService;
	import tempest.common.mvc.base.Command;
	import tempest.ui.components.TAlert;
	import tempest.ui.events.TAlertEvent;

	public class AddEnemyCommand extends Command
	{
		private var _playerGuid:int;
		[Inject]
		public var service:FriendService;
		[Inject]
		public var model:FriendModel;

		override public function getHandle():Function
		{
			return this.addEnemy;
		}

		private function addEnemy(guid:int):void
		{
			_playerGuid = guid;
			if (GameInstance.mainChar.id == guid)
			{
				MessageManager.instance.addHintById_client(2028, "不能将自己视为仇人");
				return;
			}
			if (model.getContainer(FriendConst.TYPE_ENEMY).length >= EnemyInfo.ENEMY_MAX)
			{
				MessageManager.instance.addHintById_client(2029, "仇人列表已满无法添加仇人！");
				return;
			}
			if (model.getEntity(FriendConst.TYPE_ENEMY, guid))
			{
				MessageManager.instance.addHintById_client(2030, "该玩家已经是你的仇人了");
				return;
			}
			if (model.getEntity(FriendConst.TYPE_FRIEND, guid))
			{
				MessageManager.instance.addHintById_client(2031, "该玩家是你的好友，请先在好友列表中将其删除，再添加其为仇人");
				return;
			}
			if (model.getEntity(FriendConst.TYPE_BLACK, guid))
			{
				MessageManager.instance.addHintById_client(2032, "该玩家在你的黑名单中，请先在黑名单中将其删除，再添加其为仇人");
				return;
			}
			TAlertHelper.showDialog(2034, "确定将此人添加为仇人", true, TAlert.YES | TAlert.NO, closeHandler);
		}

		private function closeHandler(event:TAlertEvent):void
		{
			if (event.flag == TAlert.YES)
			{
				if (_playerGuid != 0)
				{
					service.sendEnemyAddRequest(_playerGuid);
				}
			}
		}
	}
}
