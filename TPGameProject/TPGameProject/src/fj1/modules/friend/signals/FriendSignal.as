package fj1.modules.friend.signals
{
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.osflash.signals.utilities.SignalSet;

	public class FriendSignal extends SignalSet
	{
		private var _showFriendPanel:ISignal;
		private var _delFriendHandler:ISignal;

		public function FriendSignal()
		{
			super();
		}

		/**
		 * 显示好友面板
		 * @return
		 *
		 */
		public function get showFriendPanel():ISignal
		{
			return getSignal("showFriendPanel", Signal);
		}

		/**
		 * 删除好友
		 * @return
		 *
		 */
		public function get delFriendHandler():ISignal
		{
			return getSignal("delFriendHandler", Signal);
		}

		/**
		 * 删除黑名单
		 * @return
		 *
		 */
		public function get delBlackHandler():ISignal
		{
			return getSignal("delBlackHandler", Signal);
		}

		/**
		 * 添加黑名单
		 * @return
		 *
		 */
		public function get addBlack():ISignal
		{
			return getSignal("addBlackHandler", Signal);
		}

		/**
		 * 删除仇人
		 * @return
		 *
		 */
		public function get delEnemyHandler():ISignal
		{
			return getSignal("delEnemyHandler", Signal);
		}

		/**
		 * 好友列表
		 * @return
		 *
		 */
		public function get friendListQuery():ISignal
		{
			return getSignal("friendListQuery", Signal);
		}

		/**
		 * 显示搜索玩家面板
		 * @return
		 *
		 */
		public function get showFindPanel():ISignal
		{
			return getSignal("showFindPanel", Signal)
		}

		/**
		 * 添加好友
		 * @return
		 *
		 */
		public function get addFriendHandler():ISignal
		{
			return getSignal("addFriendHandler", Signal);
		}

		/**
		 *添加仇人
		 * @return
		 *
		 */
		public function get addEnemy():ISignal
		{
			return getSignal("addEnemy", Signal);
		}

		/**
		 * 追踪仇人
		 * @return
		 *
		 */
		public function get enemyPosTrace():ISignal
		{
			return getSignal("enemyPosTrace", Signal);
		}

		/**
		 * 查找玩家
		 * @return
		 *
		 */
		public function get findPlayer():ISignal
		{
			return getSignal("findPlayer", Signal);
		}

		/**
		 * 查找玩家面板数据
		 * @return
		 *
		 */
		public function get findPlayerData():ISignal
		{
			return getSignal("findPlayerData", Signal);
		}

		/**
		 * 找不到玩家
		 * @return
		 *
		 */
		public function get cannotFindPlayer():ISignal
		{
			return getSignal("cannotFindPlayer", Signal);
		}

		/**
		 * 同意添加好友
		 * @return
		 *
		 */		
		public function get friendEnsureRequest():ISignal
		{
			return getSignal("friendEnsureRequest", Signal);
		}

		/**
		 *  拒绝添加好友
		 * @return
		 *
		 */		
		public function get friendRepulseRequest():ISignal
		{
			return getSignal("friendRepulseRequest", Signal);
		}
	}
}


