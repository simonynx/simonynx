package fj1.common.net.gamehandler.back
{
	import fj1.common.GameInstance;
	import tempest.common.net.IPacketHandler;
	import tempest.common.net.vo.TPacketIn;
	import tempest.core.ISocket;

	public class TransportSuccessHandler implements IPacketHandler
	{
		public function handPacket(socket:ISocket, packet:TPacketIn):void
		{
			var tranID:int = packet.readUnsignedInt();
			var taskID:int = packet.readUnsignedInt();
			var npcID:int = packet.readUnsignedInt();
//			GameInstance.signal.scene.trasportComplete.dispatch(taskID, npcID);
		}
	}
}
