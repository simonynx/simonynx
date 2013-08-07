package fj1.modules.login.model
{
	import fj1.common.GameInstance;
	import fj1.modules.login.model.vo.RoleInfo;
	import fj1.modules.login.signals.LoginModelSignal;
	import flash.utils.getTimer;
	import tempest.common.mvc.base.Actor;

	public class LoginModel extends Actor
	{
		private var _signals:LoginModelSignal;
		private var _offlineTime:uint = 0;
		private var _offlineFlag:uint = 0;
		private var _isShowDelBtn:Boolean;
		public static const ROLE_NUM_MAX:int = 5;
		public static const P2_MAXLENGTH:int = 6;

		public var selectRole:RoleInfo;

		public function LoginModel()
		{
		}

		public function get offlineFlag():uint
		{
			return _offlineFlag;
		}

		public function getRemainOfflineTimes():int
		{
			return _offlineTime - getTimer() / 1000;
		}

		public function get signals():LoginModelSignal
		{
			return _signals ||= new LoginModelSignal();
		}

		public function receivedLines(lines:Array, newAcc:Boolean):void
		{
			signals.linesReceived.dispatch(lines, newAcc);
		}

		/**
		 * 初始化角色列表
		 * @param remainOfflineTimes
		 * @param roles
		 */
		public function initRoles(remainOfflineTimes:uint, roles:Array):void
		{
			_offlineFlag = remainOfflineTimes % 10;
			_offlineTime = getTimer() / 1000 + ((remainOfflineTimes / 10) >> 0);
//			roles = roles.reverse();
			while (roles.length < ROLE_NUM_MAX)
			{
				roles.push(null);
			}
			GameInstance.roles = roles;
			signals.roleListUpdate.dispatch();
		}

		/**
		 * 添加角色
		 * @param role
		 */
		public function addRole(role:RoleInfo):void
		{
			GameInstance.roles.unshift(role);
			signals.roleListUpdate.dispatch();
		}

		/**
		 * 删除角色
		 * @param index
		 */
		public function removeRole(index:int):void
		{
			var arr:Array = GameInstance.roles;
			for (var i:int = 0; i < arr.length; i++)
			{
				var roleInfo:RoleInfo = RoleInfo(arr[i]);
				if (roleInfo && roleInfo.index == index)
				{
					arr.splice(i, 1);
					arr.push(null);
					signals.roleListUpdate.dispatch();
					break;
				}
			}
		}

		/**
		 * 获取角色数量
		 * @return
		 *
		 */
		public function get roleNum():int
		{
			var roles:Array = GameInstance.roles;
			var count:int = 0;
			for each (var roleInfo:RoleInfo in roles)
			{
				if (roleInfo)
					++count;
			}
			return count;
		}

		public function get isShowDelBtn():Boolean
		{
			return _isShowDelBtn;
		}

		public function set isShowDelBtn(value:Boolean):void
		{
			_isShowDelBtn = value;
		}
	}
}
