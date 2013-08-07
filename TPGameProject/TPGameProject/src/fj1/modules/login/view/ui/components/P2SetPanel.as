package fj1.modules.login.view.ui.components
{
	import assets.UISecondPSWLib;

	import tempest.common.rsl.RslManager;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.ui.TInputText;
	import fj1.modules.login.model.LoginModel;

	import flash.events.*;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.natives.NativeSignal;

	import tempest.common.rsl.TRslManager;
	import tempest.ui.components.TButton;
	import tempest.utils.StringUtil;

	/**
	 * 二次密码初始化面板
	 * @author wushangkun
	 */
	public class P2SetPanel extends P2PanelBase
	{
		public var txt_pwd1:TInputText; //确认新密码

		public function P2SetPanel()
		{
			super(RslManager.getDefinition(UISecondPSWLib.UI_GAME_GUI_SETSECONDPSD));
		}

		override protected function addChildren():void
		{
			super.addChildren();
			txt_pwd1 = new TInputText(null, null, _proxy.txt_pwd1);
		}

		protected override function init():void
		{
			super.init();
			//设置文本
			_proxy.lbl_win_name.text = LanguageManager.translate(1067, "二次密码设置界面");
			_proxy.lbl_pwd1.text = LanguageManager.translate(1068, "确认新密码");
			_proxy.lbl_describe.text = LanguageManager.translate(1066, "设置二次密码");
			//设置输入框
			txt_pwd1.passwordModel(LoginModel.P2_MAXLENGTH, true);
			txt_pwd1.addEventListener(FocusEvent.FOCUS_IN, onForcusIn);
		}

		public override function clear(e:Event = null):void
		{
			super.clear(e);
			txt_pwd1.text = "";
		}

		protected override function get returnValues():Array
		{
			return [StringUtil.trim(txt_pwd.text), StringUtil.trim(txt_pwd1.text)];
		}
	}
}
