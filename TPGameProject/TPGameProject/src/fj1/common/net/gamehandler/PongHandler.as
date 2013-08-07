package fj1.common.net.gamehandler
{
	import fj1.common.net.GameClient;
	import flash.utils.getTimer;
	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.common.net.IPacketHandler;
	import tempest.core.ISocket;
	import tempest.common.net.vo.TPacketIn;

	public class PongHandler implements IPacketHandler
	{
		private static const log:ILogger = TLog.getLogger(PongHandler);

		public function handPacket(socket:ISocket,packet:TPacketIn):void
		{
			var ping:uint = packet.readUnsignedInt();
			if (GameClient.ping != ping)
			{
				log.warn("场景服丢失ping send:" + GameClient.ping + " receive:" + ping);
				return;
			}
			GameClient.latency = (getTimer() - GameClient.pingTime) * 0.5;
			log.info("场景服心跳返回 延迟：" + GameClient.latency);
		}
	}
}
