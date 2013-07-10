package modules.main.business.battle.command
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.geom.Point;
	
	import asset.EmbedRes;
	
	import common.GameInstance;
	
	import modules.main.business.battle.constants.BattleCamp;
	import modules.main.business.battle.signals.BattleSignals;
	import modules.main.business.battle.view.BattleSceneMediator;
	import modules.main.business.battle.view.components.BattleGrid;
	import modules.main.business.battle.view.components.BattleScene;
	import modules.main.business.scene.view.components.LoadingUI;
	
	import tempest.common.mvc.base.Command;

	public class BattleFacadeStartupCommand extends Command
	{
		[Inject]
		public var battleSignals:BattleSignals;

		public function BattleFacadeStartupCommand()
		{
			super();
		}

		override public function execute():void
		{
//			var battleScene:BattleScene = new BattleScene();

			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void
			{
				//战斗位置初始化
				GameInstance.battleScene.battleGrid.init(loader.content);
				loader.unload();
//				mediatorMap.map(battleScene, BattleSceneMediator);

				commandMap.map([battleSignals.battleStart], BattleStartCommand);
				commandMap.map([battleSignals.battleEnd], BattleEndCommand);
			});
			loader.loadBytes(new EmbedRes.battleGrid()); //加载战斗位置相关资源
		}
	}
}
