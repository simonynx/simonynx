package fj1.manager
{
	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.common.net.TSocket;
	import tempest.common.net.vo.TPacketOut;
	import tempest.core.ISocket;

	/**
	 * 网络管理器
	 * @author wushangkun
	 */
	public class NetManager
	{
		private static const log:ILogger = TLog.getLogger(NetManager);
		public static const loginSocket:TSocket = new TSocket("login");
		public static const chatSocket:TSocket = new TSocket("chat");
		public static const lineSocket:TSocket = new TSocket("line");

		/**
		 * 建立socket连接
		 * @param socket 套接字
		 * @param host 地址
		 * @param port 端口
		 * @param connectHandler 连接回调
		 * @param ioErrorHandler 错误回调
		 * @param securityErrorHandler 安全错误回调
		 * @param closeHandler 关闭回调
		 * @param socketDataHandler 数据到达回调
		 */
		static public function connect(socket:TSocket, host:String, port:int, connectHandler:Function = null, ioErrorHandler:Function = null, securityErrorHandler:Function = null, closeHandler:Function =
			null, socketDataHandler:Function = null):void
		{
			if (socket.connected)
				return;
			if (connectHandler != null)
				socket.signals.connect.addOnce(connectHandler);
			if (ioErrorHandler != null)
				socket.signals.ioError.addOnce(ioErrorHandler);
			if (securityErrorHandler != null)
				socket.signals.securityError.addOnce(securityErrorHandler);
			if (closeHandler != null)
				socket.signals.close.addOnce(closeHandler);
			if (socketDataHandler != null)
				socket.signals.socketData.addOnce(socketDataHandler);
			socket.connect(host, port);
		}

		/**
		 * 发送封包
		 * @param packet 包
		 * @param socket 套接字
		 */
		static public function send(packet:TPacketOut, socket:TSocket):void
		{
			if (!socket.connected)
			{
				log.warn("发送封包时socket未连接 name:{0}", socket.name);
				return;
			}
			socket.send(packet);
		}

		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/**
		 * 发送到登陆服
		 * @param packet
		 */
		static public function sendToLS(packet:TPacketOut):void
		{
			send(packet, loginSocket);
		}

		/**
		 * 发送到聊天服
		 * @param packet
		 */
		static public function sendToCS(packet:TPacketOut):void
		{
			send(packet, chatSocket);
		}

		/**
		 * 发送到场景服
		 * @param packet
		 */
		static public function sendToGS(packet:TPacketOut):void
		{
			send(packet, lineSocket);
		}
	}
}
