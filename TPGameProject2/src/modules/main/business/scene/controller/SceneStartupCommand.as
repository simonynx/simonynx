package modules.main.business.scene.controller
{
	import common.GameInstance;
	import common.config.SystemConfig;

	import modules.main.business.scene.constants.SceneCharacterType;
	import modules.main.business.scene.signals.SceneLoadingUISignals;
	import modules.main.business.scene.signals.SceneSignals;
	import modules.main.business.scene.view.LoadingUIMediator;
	import modules.main.business.scene.view.components.LoadingUI;

	import tempest.TPEngine;
	import tempest.common.mvc.base.Command;
	import tempest.engine.SceneCharacter;

	public class SceneStartupCommand extends Command
	{
		[Inject]
		public var loadingUISignals:SceneLoadingUISignals;

		[Inject]
		public var sceneSignals:SceneSignals;

		public function SceneStartupCommand()
		{
			super();
		}

		override public function execute():void
		{
			TPEngine.init(GameInstance.app.stage, SystemConfig.FPS); //初始化场景Engine

			mediatorMap.map(new LoadingUI(), LoadingUIMediator);

			commandMap.map([loadingUISignals.show], ShowLoadingUICommand);
			commandMap.map([sceneSignals.switchScene], SwitchSceneCommand);
			commandMap.map([GameInstance.scene.signal.interactive], SceneInteractiveCommand);

			GameInstance.app.sceneContainer.addChild(GameInstance.scene.container); //添加场景层
			GameInstance.mainChar = new SceneCharacter(SceneCharacterType.PLAYER, GameInstance.scene);
			GameInstance.scene.mainChar = GameInstance.mainChar;
			sceneSignals.switchScene.dispatch(1); //进入场景
		}
	}
}
