package fj1.modules.newmail.view.components
{
	import assets.UIResourceLib;
	import tempest.common.rsl.RslManager;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.ui.BaseWindow;
	import flash.events.Event;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.natives.NativeSignal;
	import tempest.common.rsl.TRslManager;
	import tempest.ui.components.TTabController;

	public class MailTabPanel extends BaseWindow
	{
		public static const NAME:String = "MailTabPanel";
		public var tabController:TTabController;
		public var mailListPanel:MailListPanel;
		public var mailWritePanel:MailWritePanel;
		private var _tabChange:ISignal;

		public function MailTabPanel(_proxy:*)
		{
			super({horizontalCenter: 0, verticalCenter: 0}, _proxy, NAME);
		}

		override protected function addChildren():void
		{
			super.addChildren();
			mailListPanel = new MailListPanel(_proxy.mc_mailListPanel);
			mailWritePanel = new MailWritePanel(_proxy.mc_mailWritePanel);
			tabController = new TTabController();
			tabController.addTab(_proxy.mc_tab_mailList, LanguageManager.translate(10021, "收件箱"), [mailListPanel]);
			tabController.addTab(_proxy.mc_tab_sendMail, LanguageManager.translate(10022, "发邮件"), [mailWritePanel]);
		}

		public function get tabChange():ISignal
		{
			return _tabChange ||= new NativeSignal(tabController, Event.CHANGE, Event);
		}
	}
}
