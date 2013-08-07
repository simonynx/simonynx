package fj1.modules.login.view.ui.components
{
	import assets.UIRoleLib;

	import com.adobe.crypto.SHA1;

	import fj1.common.GameConfig;
	import tempest.common.rsl.RslManager;
	import fj1.common.res.ResPaths;

	import flash.display.DisplayObjectContainer;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.utils.Timer;

	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeMappedSignal;

	import tempest.common.keyboard.KeyCodes;
	import tempest.common.net.vo.TByteArray;
	import tempest.common.rsl.TRslManager;
	import tempest.ui.components.TAlert;
	import tempest.ui.components.TButton;
	import tempest.ui.components.TComponent;
	import tempest.utils.Geom;
	import tempest.utils.StringUtil;

	public final class LoginPanel extends TComponent
	{
		public var txt_account:TextField; //帐号输入框
		public var txt_pwd:TextField; //密码输入框
		public var btn_login:SimpleButton; //登陆按钮
		public var btn_cancel:SimpleButton; //取消按钮
		public var btn_reg:SimpleButton; //注册按钮
		public var _btn_login:TButton; //登陆按钮
		public var _btn_reg:TButton; //注册按钮
		/////////////////////////////////////////////////////////
		private var _onLogin:Signal;

		public function LoginPanel()
		{
			super({horizontalCenter: 0, verticalCenter: 0}, RslManager.getDefinition(UIRoleLib.ui_login_Login));
		}

		protected override function init():void
		{
			super.init();
			txt_account = _proxy.txt_account;
			txt_pwd = _proxy.txt_pwd;
			btn_login = _proxy.btn_login;
			btn_cancel = _proxy.btn_cancel;
			btn_reg = _proxy.btn_reg;
			//
			txt_account.restrict = "0-9";
			txt_account.tabIndex = 0;
			_btn_login = new TButton(null, btn_login, null, function(e:Event):void
			{
				onLogin.dispatch(txt_account.text.replace(" ", ""), txt_pwd.text.replace(" ", ""));
			});
			_btn_reg = new TButton(null, btn_reg);
			_btn_reg.addEventListener(MouseEvent.CLICK, onRegHandler, false, 0, true);
			this.addEventListener(KeyboardEvent.KEY_UP, onEnterHandler, false, 0, true);
			//调试
			txt_account.text = "";
			txt_pwd.text = "";
		}

		private function onEnterHandler(e:KeyboardEvent):void
		{
			if (e.keyCode == KeyCodes.ENTER.keyCode)
			{
				onLogin.dispatch(txt_account.text.replace(" ", ""), txt_pwd.text.replace(" ", ""));
			}
		}

		private function onCancelHandler(e:MouseEvent):void
		{
			navigateToURL(new URLRequest("更新日志.txt"), "_bank");
		}

		private function onRegHandler(e:MouseEvent):void
		{
//			navigateToURL(new URLRequest(GameConfig.acc_host), "_bank");
		}

		public override function startRipping(timeOut:Number = 0):void
		{
			super.startRipping(timeOut);
			this.enabled = false;
		}

		public override function stopRipping(e:Event):void
		{
			super.stopRipping(e);
			this.enabled = true;
		}

		public function get onLogin():Signal
		{
			return _onLogin ||= new Signal(String, String);
		}
	}
}
