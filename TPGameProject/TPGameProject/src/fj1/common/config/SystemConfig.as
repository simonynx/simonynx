package fj1.common.config
{
	import tempest.common.logging.TLog;

	public class SystemConfig
	{
		/**
		 * 日志等级
		 * @default
		 */
		public static const LOG_LEVEL:int = TLog.LEVEL_DEBUG;
		/**
		 * 帧率
		 * @default
		 */
		public static const FPS:int = 30;
//		/**
//		 * 网络协议
//		 * 用于校验客户端是否和服务器协议一致
//		 * @default
//		 */
//		public static const SOCKET_PROTOCO:int = 2;
	}
}
