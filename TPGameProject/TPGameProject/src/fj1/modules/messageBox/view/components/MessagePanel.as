package fj1.modules.messageBox.view.components
{
	import assets.UIResourceLib;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.ui.BaseWindow;
	import flash.events.MouseEvent;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.natives.NativeSignal;
	import tempest.common.rsl.RslManager;
	import tempest.ui.components.TButton;

	public class MessagePanel extends BaseWindow
	{
		public var messageListPanel:MessageListPanel;
		public var btn_All_OK:TButton;
		public var btn_All_Cancel:TButton;
		public var agreeSignal:ISignal;
		public var disagreeSignal:ISignal;
		public static const NAME:String = "MessagePanel";

		public function MessagePanel(_proxy:*)
		{
			super({horizontalCenter: 0, verticalCenter: 0}, _proxy, NAME);
			messageListPanel = new MessageListPanel(_proxy.mc_messageList);
			btn_All_OK = new TButton(null, _proxy.btn_OK, LanguageManager.translate(33002, "全部同意"));
			btn_All_Cancel = new TButton(null, _proxy.btn_canel, LanguageManager.translate(33003, "全部拒绝"));
		}

		public function get agree():ISignal
		{
			return agreeSignal ||= new NativeSignal(btn_All_OK, MouseEvent.CLICK, MouseEvent);
		}

		public function get disagree():ISignal
		{
			return disagreeSignal ||= new NativeSignal(btn_All_Cancel, MouseEvent.CLICK, MouseEvent);
		}
	}
}
