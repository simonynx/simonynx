package fj1.modules.battle.view.components
{
	import assets.UIResourceLib;
	
	import fj1.common.res.lan.LanguageManager;
	import fj1.modules.battle.view.BattleFinishPanel;
	import fj1.modules.battle.view.RoleInfoLeftPanel;
	import fj1.modules.battle.view.RoleInfoRightPanel;
	
	import tempest.common.rsl.RslManager;
	import tempest.ui.components.TButton;
	import tempest.ui.components.TLayoutContainer;
	
	public class BattleUILayer extends TLayoutContainer
	{
		public var btn_battle_end:TButton;
		public var btn_battle_accelerate:TButton;
		public var battleFinishPanel:BattleFinishPanel;
		public var roleInfoLeftPanel:RoleInfoLeftPanel;
		public var roleInfoRightPanel:RoleInfoRightPanel;
		
		public function BattleUILayer(constraints:Object=null, _proxy:*=null)
		{
			super({left: 0, right: 0, top: 0, bottom: 0}, _proxy);
		}
		
		protected override function addChildren():void
		{
			roleInfoLeftPanel = new RoleInfoLeftPanel({left:0, top:0}, RslManager.getInstance(UIResourceLib.UI_BATTLE_ROLEINFO_LEFT));
			addChild(roleInfoLeftPanel);
			roleInfoRightPanel = new RoleInfoRightPanel({right:0, top:0}, RslManager.getInstance(UIResourceLib.UI_BATTLE_ROLEINFO_RIGHT));
			addChild(roleInfoRightPanel);
			battleFinishPanel = new BattleFinishPanel({horizontalCenter:0, verticalCenter:0}, RslManager.getInstance(UIResourceLib.UI_BATTLE_PANEL_FINISH));
			btn_battle_end = new TButton({horizontalCenter:-100, bottom:100}, RslManager.getInstance(UIResourceLib.UI_BATTLE_BTN_END), LanguageManager.translate(0, "战斗结束"));
			addChild(btn_battle_end);
			btn_battle_accelerate = new TButton({horizontalCenter:100, bottom:100}, RslManager.getInstance(UIResourceLib.UI_BATTLE_BTN_ACCELERATE), LanguageManager.translate(0, "战斗加速"));
			addChild(btn_battle_accelerate);
		}
	}
}