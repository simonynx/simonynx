package modules.main.business.scene.constants
{

	/**
	 * 在不同状态下，相同动作的avatarPart资源是不同的
	 * 如行走(Status.WALK)下，站立和骑乘动作不同，会使用不同资源
	 * @author linxun
	 *
	 */
	public class StatusType
	{
		public static const STAND:int = 0;
		public static const MOUNT:int = 1;
		public static const FLY:int = 2;
	}
}
