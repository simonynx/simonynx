package fj1.modules.friend.controller
{
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.staticdata.FriendConst;
	import fj1.manager.MessageManager;
	import fj1.modules.friend.service.FriendService;

	import tempest.common.mvc.base.Command;
	import tempest.ui.components.TAlert;
	import tempest.ui.events.TAlertEvent;

	public class DelEnemyListCommand extends Command
	{
		[Inject]
		public var service:FriendService;
		override public function getHandle():Function
		{
			return this.delEnemy;
		}

		private function delEnemy(guid:int, name:String):void
		{
			TAlert.Show(LanguageManager.translate(50473, "确定删除这个仇人？"),"", true, TAlert.YES | TAlert.NO, function(event:TAlertEvent):void
			{
				if (event.flag == TAlert.YES)
				{
					service.sendFriendDelRequest(guid, FriendConst.TYPE_ENEMY);
					MessageManager.instance.addHintById_client(2036, "成功与%s解除仇人关系", name);
				}
			});
		}
	}
}


