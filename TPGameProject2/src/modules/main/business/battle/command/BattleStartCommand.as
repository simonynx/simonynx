package modules.main.business.battle.command
{
	import flash.events.Event;
	
	import common.GameInstance;
	
	import modules.main.business.battle.constants.BattleCamp;
	import modules.main.business.battle.model.BattleModel;
	import modules.main.business.battle.model.entity.BattlePlayer;
	import modules.main.business.battle.model.vo.BattleInfo;
	import modules.main.business.battle.model.vo.BattleSceneTemplate;
	import modules.main.business.battle.view.components.BattleScene;
	import modules.main.business.battle.view.components.element.BattleCharacter;
	
	import tempest.common.mvc.base.Command;
	import tempest.ui.PopupManager;
	
	import tpe.manager.FilePathManager;

	public class BattleStartCommand extends Command
	{
//		[Inject]
//		public var battleScene:BattleScene;

		[Inject]
		public var battleModel:BattleModel;

		public function BattleStartCommand()
		{
			super();
		}

		override public function execute():void
		{
			if (GameInstance.battleScene.container.parent)
			{
				return;
			}
			var info:BattleInfo = new BattleInfo();
			GameInstance.scene.sceneRender.stopRender();
			GameInstance.scene.dispose();
//			if(GameInstance.scene.container.parent)
//				GameInstance.app.sceneContainer.removeChild(GameInstance.scene.container);
			GameInstance.scene.enabled = false;
			GameInstance.app.sceneContainer.addChild(GameInstance.battleScene.container);
			GameInstance.battleScene.enterScene(info); //进入场景
//			PopupManager.instance.showPopup(null, battleScene, false);
		}

	}
}
