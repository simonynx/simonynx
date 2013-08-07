package fj1.modules.login.signals
{
	import org.osflash.signals.*;
	import org.osflash.signals.utilities.SignalSet;

	public class LoginSignal extends SignalSet
	{
		private var _login:ISignal;
		private var _selectRoleSuccess:ISignal;
		private var _loginFailed:ISignal;

		public function LoginSignal()
		{
			super();
		}

		public function get login():ISignal
		{
			return _login ||= getSignal("login", Signal);
		}

		public function get selectRoleSuccess():ISignal
		{
			return _selectRoleSuccess ||= getSignal("selectRoleSuccess", Signal);
		}

		/////////////////////////////////////////////////
		public function get loginFailed():ISignal
		{
			return _loginFailed ||= getSignal("loginFailed", Signal);
		}
	}
}
