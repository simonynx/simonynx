package fj1.modules.friend.controller
{
	import fj1.common.GameInstance;
	import fj1.common.net.ChatClient;
	import fj1.manager.MessageManager;
	import fj1.modules.friend.model.FriendModel;
	import fj1.modules.friend.service.FriendService;
	import tempest.common.mvc.base.Command;
	import tempest.utils.StringUtil;

	public class FindPlayerHandler extends Command
	{
		[Inject]
		public var service:FriendService;
		[Inject]
		public var model:FriendModel;

		override public function getHandle():Function
		{
			return this.findPlayer;
		}

		/**
		 * 查找玩家
		 * @param name 被查人名字
		 *
		 */
		private function findPlayer(name:String):void
		{
			if (StringUtil.getCharSetLen(name, "gb1312") < 4)
			{
				MessageManager.instance.addHintById_client(2019, "请输入2-8个汉字或者4-16个数字或字母后进行查询");
				return;
			}
			if (model.save_input_word == name)
			{
				MessageManager.instance.addHintById_client(2020, "请不要重复查询");
				return;
			}
			model.save_input_word = name;
			service.findPlayerByName(name);
		}
	}
}
