package fj1.modules.main
{
	import fj1.modules.bag.BagFacadePlugin;
	import fj1.modules.battle.BattleFacadePlugin;
	import fj1.modules.card.CardFacadePlugin;
	import fj1.modules.chat.ChatFacadePlugin;
	import fj1.modules.formation.FormationFacadePlugin;
	import fj1.modules.friend.FriendFacadePlugin;
	import fj1.modules.item.ItemFacadePlugin;
	import fj1.modules.main.controller.MainFacadeStartupCommand;
	import fj1.modules.mainUI.MainUIFacadePlugin;
	import fj1.modules.messageBox.MessageFacedePlugin;
	import fj1.modules.newmail.MailFacadePlugin;
	import fj1.modules.scene.SceneFacadePlugin;
	import fj1.modules.skill.SkillFacadePlugin;
	import fj1.modules.sound.SoundFacdePlugin;
	import tempest.common.mvc.TFacade;

	public class MainFacade extends TFacade
	{
		private static var _instance:MainFacade;

		public function MainFacade()
		{
			super();
			if (_instance)
			{
				throw new Error("MainFacade is Singleton");
			}
		}

		public static function get instance():MainFacade
		{
			return _instance ||= new MainFacade();
		}

		override public function startup():void
		{
			commandMap.map([this.startupSignal], MainFacadeStartupCommand, true);
			this.addPlugin(new SoundFacdePlugin());
			this.addPlugin(new MainUIFacadePlugin());
			this.addPlugin(new BagFacadePlugin());
			this.addPlugin(new SceneFacadePlugin());
			this.addPlugin(new BattleFacadePlugin());
			this.addPlugin(new ItemFacadePlugin());
			this.addPlugin(new MailFacadePlugin());
			this.addPlugin(new ChatFacadePlugin());
			this.addPlugin(new SkillFacadePlugin());
			this.addPlugin(new CardFacadePlugin());
			this.addPlugin(new MessageFacedePlugin());
			this.addPlugin(new FriendFacadePlugin());
			this.addPlugin(new FormationFacadePlugin());
			super.startup();
		}
	}
}
