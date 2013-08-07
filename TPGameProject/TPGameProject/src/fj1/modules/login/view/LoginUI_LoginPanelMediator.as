package fj1.modules.login.view
{
	import com.adobe.crypto.SHA1;

	import fj1.common.config.CustomConfig;
	import fj1.common.GameConfig;
	import fj1.common.GameInstance;
	import fj1.common.helper.TAlertHelper;
	import fj1.modules.login.signals.LoginSignal;
	import fj1.modules.login.view.ui.components.LoginPanel;

	import flash.utils.getTimer;

	import tempest.common.mvc.base.Mediator;
	import tempest.common.net.vo.TByteArray;

	public class LoginUI_LoginPanelMediator extends Mediator
	{
		[Inject]
		public var loginSignal:LoginSignal;

		public function LoginUI_LoginPanelMediator()
		{
			super();
		}

		private function get loginPanel():LoginPanel
		{
			return this.viewComponet;
		}

		override public function onRegister():void
		{
			addSignal(loginPanel.onLogin, onLoginHandler);
		}

		override public function onRemove():void
		{
		}

		private function onLoginHandler(account:String, password:String):void
		{
			CONFIG::debugging
			{
				if (account.length == 0)
				{
					TAlertHelper.showAlert(1716, "帐号不能为空");
					return;
				}
				if (password.length == 0)
				{
					password = "123456";
//					TAlertHelper.ShowAlert(1717, "密码不能为空");
//					return;
				}
				CustomConfig.instance.user_id = parseInt(account);
				CustomConfig.instance.time = new Date().getTime() / 1000;
				CustomConfig.instance.cm = 0;
				CustomConfig.instance.plat = "qyfz";
				//
				var _by:TByteArray = new TByteArray();
				_by.writeUnsignedInt(CustomConfig.instance.user_id);
				_by.writeUnsignedInt(CustomConfig.instance.time);
				_by.writeByte(CustomConfig.instance.cm);
				_by.writeMultiByte(password, "gb2312");
				CustomConfig.instance.sign = SHA1.hashBytes(_by).toUpperCase();
				//发送登陆请求
				loginSignal.login.dispatch();
				loginPanel.startRipping(2 * 1000);
			}
		}
	}
}
