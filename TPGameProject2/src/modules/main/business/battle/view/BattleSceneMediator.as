package modules.main.business.battle.view
{
	import flash.events.MouseEvent;

	import modules.main.business.battle.model.BattleModel;
	import modules.main.business.battle.model.entity.BattlePlayer;
	import modules.main.business.battle.signals.BattleModelSignals;
	import modules.main.business.battle.view.components.BattleScene;
	import modules.main.business.battle.view.components.element.BattleCharacter;

	import tempest.common.mvc.base.Mediator;
	import tempest.utils.ListenerManager;

	public class BattleSceneMediator extends Mediator
	{
		[Inject]
		public var battleScene:BattleScene;

		[Inject]
		public var battleModel:BattleModel;

		private var _listenerMgr:ListenerManager;

		public function BattleSceneMediator()
		{
			super();
			_listenerMgr = new ListenerManager();
		}

		override public function onRegister():void
		{
			_listenerMgr.addSignal(battleModel.signals.playerAdd, onPlayerAdd);
			_listenerMgr.addSignal(battleModel.signals.playerRemove, onPlayerRemove);
			_listenerMgr.addEventListener(battleScene, MouseEvent.CLICK, onSceneClick);

			for each (var player:BattlePlayer in battleModel.playerDic)
			{
				onPlayerAdd(player);
			}
		}

		private function onPlayerAdd(player:BattlePlayer):void
		{
			var char:BattleCharacter = new BattleCharacter(player.guid);
			char.data = player;
			battleScene.addElement(char);
		}

		private function onPlayerRemove(guid:int):void
		{
			battleScene.removeElement(guid);
		}

		private function onSceneClick(event:MouseEvent):void
		{

		}
	}
}
