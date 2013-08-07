package fj1.modules.formation.controller
{
	import fj1.common.ui.TWindowManager;
	import fj1.modules.formation.service.FormationService;
	import fj1.modules.formation.signal.FormationSignal;
	import fj1.modules.formation.view.FormationPanelMediator;
	import fj1.modules.formation.view.components.FormationPanel;
	import tempest.common.keyboard.KeyCodes;
	import tempest.common.mvc.base.Command;
	import tempest.manager.KeyboardManager;

	public class FormationFacadeStartupCommand extends Command
	{
		[Inject]
		public var signal:FormationSignal;
		[Inject]
		public var service:FormationService;

		public override function execute():void
		{
			//注册命令
			commandMap.map([signal.showFormationPanel], ShowFormationPanelCommand); //显示阵型面板
			TWindowManager.instance.registerWindowMediator(FormationPanel, FormationPanelMediator, mediatorMap.map);
			service.init();
			//注册热键
			KeyboardManager.addHotkey("阵型", [KeyCodes.K.keyCode], function():void
			{
				signal.showFormationPanel.dispatch(-1);
			});
		}
	}
}
