package fj1.modules.login.view.ui.components
{
	import assets.UISecondPSWLib;

	import tempest.common.rsl.RslManager;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.ui.TInputText;
	import fj1.modules.login.model.LoginModel;

	import flash.events.*;
	import flash.text.TextField;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.natives.NativeMappedSignal;
	import org.osflash.signals.natives.NativeSignal;

	import tempest.common.rsl.TRslManager;
	import tempest.ui.components.TButton;
	import tempest.utils.StringUtil;

	/**
	 * 二次密码重置面板
	 * @author wushangkun
	 */
	public class P2ResetPanel extends P2PanelBase
	{
		public var txt_pwd1:TInputText; //新密码
		public var txt_pwd2:TInputText; //确认新密码
		private var _onClose:ISignal;
		private var btn_close:TButton;

		public function P2ResetPanel()
		{
			super(RslManager.getDefinition(UISecondPSWLib.UI_GAME_GUI_RESETSECONDPSD));
		}

		override protected function addChildren():void
		{
			super.addChildren();
			txt_pwd1 = new TInputText(null, null, _proxy.txt_pwd1);
			txt_pwd2 = new TInputText(null, null, _proxy.txt_pwd2);
			btn_close = new TButton(null, _proxy.btn_close);
		}

		protected override function init():void
		{
			super.init();
			//设置文本
			_proxy.lbl_win_name.text = LanguageManager.translate(1072, "二次密码更改界面");
			_proxy.lbl_pwd.text = LanguageManager.translate(1073, "原密碼");
			_proxy.lbl_pwd1.text = LanguageManager.translate(1074, "新密碼");
			_proxy.lbl_pwd2.text = LanguageManager.translate(1068, "确认新密码");
			_proxy.lbl_describe.text = LanguageManager.translate(1065, "修改二次密码");
			//设置输入框
			txt_pwd1.passwordModel(LoginModel.P2_MAXLENGTH, true);
			txt_pwd1.addEventListener(FocusEvent.FOCUS_IN, onForcusIn);
			txt_pwd2.passwordModel(LoginModel.P2_MAXLENGTH, true);
			txt_pwd2.addEventListener(FocusEvent.FOCUS_IN, onForcusIn);
		}

		public override function clear(e:Event = null):void
		{
			super.clear(e);
			txt_pwd1.text = "";
			txt_pwd2.text = "";
		}

		protected override function get returnValues():Array
		{
			return [StringUtil.trim(txt_pwd.text), StringUtil.trim(txt_pwd1.text), StringUtil.trim(txt_pwd2.text)];
		}

		public function get onClose():ISignal
		{
			return _onClose ||= new NativeMappedSignal(btn_close, MouseEvent.CLICK, MouseEvent);
		}
	}
}
