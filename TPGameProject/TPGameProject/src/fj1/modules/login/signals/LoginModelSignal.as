package fj1.modules.login.signals
{
	import org.osflash.signals.ISignal;
	import org.osflash.signals.PrioritySignal;
	import org.osflash.signals.Signal;
	import org.osflash.signals.utilities.SignalSet;

	public class LoginModelSignal extends SignalSet
	{
		private var _linesReceived:ISignal;
		private var _rolesReceived:ISignal;
		private var _createRoleReceived:ISignal;
		private var _delRoleReceived:ISignal;
		private var _roleListUpdate:ISignal;

		public function LoginModelSignal()
		{
			super();
		}

		/**
		 * 角色列表更新
		 * @return
		 */
		public function get roleListUpdate():ISignal
		{
			return _roleListUpdate ||= getSignal("roleListUpdate", Signal);
		}

		public function get linesReceived():ISignal
		{
			return _linesReceived ||= getSignal("receivedLines", PrioritySignal);
		}

		public function get rolesReceived():ISignal
		{
			return _rolesReceived ||= getSignal("rolesReceived", PrioritySignal);
		}

		public function get createRoleReceived():ISignal
		{
			return _createRoleReceived ||= getSignal("createRoleReceived", PrioritySignal);
		}

		public function get delRoleReceived():ISignal
		{
			return _delRoleReceived ||= getSignal("delRoleReceived", PrioritySignal);
		}
	}
}
