package fj1.modules.battle.command
{
	import fj1.common.GameInstance;
	import fj1.modules.scene.signals.SceneSignals;

	import tempest.common.mvc.base.Command;

	public class QuitBattleCommand extends Command
	{
		[Inject]
		public var sceneSignals:SceneSignals;

		public function QuitBattleCommand()
		{
			super();
		}

		override public function getHandle():Function
		{
			return endBattle;
		}

		private function endBattle():void
		{
			GameInstance.battleScene.dispose();
			if (GameInstance.battleScene.container.parent && GameInstance.battleScene.battleUI.parent)
			{
				GameInstance.app.sceneContainer.removeChild(GameInstance.battleScene.container);
				GameInstance.app.sceneContainer.removeChild(GameInstance.battleScene.battleUI);
			}
			GameInstance.scene.enabled = true;
			GameInstance.app.mainUI.visible = true;
			GameInstance.scene.container.visible = true;
			GameInstance.scene.sceneRender.startRender(true);
		}
	}
}
