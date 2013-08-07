package fj1.modules.battle.view
{
	import flash.events.MouseEvent;
	
	import fj1.common.GameInstance;
	import fj1.modules.battle.constants.BattleConst;
	import fj1.modules.battle.model.BattleModel;
	import fj1.modules.battle.signals.BattleSignals;
	import fj1.modules.battle.view.components.BattleUILayer;
	
	import tempest.common.mvc.base.Mediator;
	import tempest.utils.ListenerManager;

	public class BattleUiMediator extends Mediator
	{
		[Inject]
		public var battleUi:BattleUILayer;
		[Inject]
		public var battleModel:BattleModel;
		[Inject]
		public var battleSignals:BattleSignals;
		
		private var _listenerManager:ListenerManager;
		
		public function BattleUiMediator()
		{
			_listenerManager = new ListenerManager();
		}
		
		public override function onRegister():void
		{
			_listenerManager.addSignal(battleSignals.battleEnd, onBattleEnd);
			_listenerManager.addEventListener(battleUi.btn_battle_end, MouseEvent.CLICK, onBattleEnd);
			_listenerManager.addEventListener(battleUi.btn_battle_accelerate, MouseEvent.CLICK, onBattleAccelerate);
		}
		
		private function onBattleAccelerate(evt:MouseEvent):void
		{
			GameInstance.battleScene.sceneRender.renderSpeed = BattleConst.BATTLE_RENDER_SPEED;
		}
		
		private function onBattleEnd(evt:MouseEvent):void
		{
			battleModel.haltQueue();	
			battleUi.addChild(battleUi.battleFinishPanel);
		}
		
		public override function onRemove():void
		{
			if(battleUi.battleFinishPanel.parent)
				battleUi.removeChild(battleUi.battleFinishPanel);
			_listenerManager.removeAll();
			GameInstance.battleScene.sceneRender.renderSpeed = BattleConst.BATTLE_RENDER_DEFAULTSPEED;
		}		
		
	}
}