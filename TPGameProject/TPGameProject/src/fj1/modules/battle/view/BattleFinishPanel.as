package fj1.modules.battle.view
{
	import flash.events.MouseEvent;
	
	import fj1.common.res.lan.LanguageManager;
	import fj1.modules.battle.signals.BattleSignals;
	import fj1.modules.main.MainFacade;
	
	import tempest.ui.components.TButton;
	import tempest.ui.components.TWindow;
	
	public class BattleFinishPanel extends TWindow
	{
		public static const NAME:String = "BattleFinishPanel";
		private var btn_quit:TButton;
		
		
		public function BattleFinishPanel(constraints:Object=null, proxy:*=null)
		{
			super(constraints, proxy, NAME);
		}
		
		protected override function addChildren():void
		{
			btn_quit = new TButton(null, _proxy.btn_quit, LanguageManager.translate(0, "退出战斗"), onQuit);
		}
		
		private function onQuit(evt:MouseEvent):void
		{
			(MainFacade.instance.inject.getInstance(BattleSignals) as BattleSignals).quitBattle.dispatch();
		}
	}
}