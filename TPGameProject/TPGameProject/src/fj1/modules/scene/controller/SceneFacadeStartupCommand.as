package fj1.modules.scene.controller
{
	import fj1.common.GameInstance;
	import fj1.common.config.SystemConfig;
	import fj1.common.staticdata.SceneCharacterType;
	import fj1.common.vo.character.Hero;
	import fj1.modules.scene.net.SceneService;
	import fj1.modules.scene.signals.SceneLoadingUISignals;
	import fj1.modules.scene.signals.SceneSignals;
	import fj1.modules.scene.view.LoadingUIMediator;
	import fj1.modules.scene.view.components.LoadingUI;

	import tempest.TPEngine;
	import tempest.common.mvc.base.Command;
	import tempest.engine.SceneCharacter;

	public class SceneFacadeStartupCommand extends Command
	{
		[Inject]
		public var loadingUISignals:SceneLoadingUISignals;

		[Inject]
		public var sceneSignals:SceneSignals;

		[Inject]
		public var sceneService:SceneService;

		public function SceneFacadeStartupCommand()
		{
			super();
		}

		override public function execute():void
		{
			sceneService.init();

			TPEngine.init(GameInstance.app.stage, SystemConfig.FPS); //初始化场景Engine

			mediatorMap.map(new LoadingUI(), LoadingUIMediator);

			commandMap.map([loadingUISignals.show], ShowLoadingUICommand);
			commandMap.map([sceneSignals.switchScene], SwitchSceneCommand);
			//
			commandMap.map([GameInstance.scene.signal.interactive], SceneInteractiveCommand);
			commandMap.map([GameInstance.scene.signal.status], SceneStatusCommand);
			commandMap.map([GameInstance.scene.signal.walk], SceneWalkCommand);

			GameInstance.app.sceneContainer.addChild(GameInstance.scene.container); //添加场景层
			GameInstance.mainChar = new SceneCharacter(SceneCharacterType.PLAYER, GameInstance.scene);
			GameInstance.mainChar.data = new Hero(GameInstance.mainChar);
			GameInstance.scene.mainChar = GameInstance.mainChar;
//			sceneSignals.switchScene.dispatch(1); //进入场景
		}
	}
}
