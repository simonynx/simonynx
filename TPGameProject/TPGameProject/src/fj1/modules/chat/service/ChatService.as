package fj1.modules.chat.service
{
	import fj1.common.net.ChatClient;
	import fj1.common.net.GameClient;
	import fj1.common.staticdata.ChatConst;
	import fj1.modules.chat.model.vo.ChatData;
	import fj1.modules.chat.singles.ChatSignal;

	import tempest.common.mvc.base.Actor;
	import tempest.common.net.vo.TPacketIn;
	import tempest.common.net.vo.TPacketOut;
	import tempest.core.ISocket;
	import tempest.manager.GMCommandMananger;

	public class ChatService extends Actor
	{
		[Inject]
		public var signal:ChatSignal;
		//游戏服
		public static const CMSG_MESSAGECHAT:uint = 0x018; //聊天包
		public static const MSG_SET_PRIVATECHATER:uint = 0x007; //设置私聊对象
		//中心服
		public static const MSG_CHATCHANNEL_SAY:uint = 0x008; //各频道的聊天信息

		public function ChatService()
		{
			super();
		}

		override public function init():void
		{
			//游戏服
			GameClient.socket.mapOpcodes([CMSG_MESSAGECHAT], chatHandler);
			//中心服
			ChatClient.socket.mapOpcodes([MSG_SET_PRIVATECHATER], setPrivateCharterHandler);
		}

		public function chatHandler(socket:ISocket, packet:TPacketIn):void
		{
			var chatEntity:ChatData = new ChatData();
			chatEntity.channelId = packet.readUnsignedByte();
			chatEntity.senderId = packet.readUnsignedInt();
			chatEntity.isGM = packet.readUnsignedByte() == 1 ? true : false;
			chatEntity.senderName = packet.readUTF();
			chatEntity.content = packet.readUTF();
			signal.resive.dispatch(chatEntity);
		}

		/**
		 *  发送聊天包
		 * @param packData
		 *
		 */
		public function sendChatPacket(packData:ChatData):Boolean
		{
			/////
			var packet:TPacketOut = new TPacketOut(CMSG_MESSAGECHAT);
			if (packData.content.indexOf(":") == 0) //前端GM命令
			{
				GMCommandMananger.exec(packData.content);
				return true;
			}
			if (packData.content.indexOf(".") == 0) //GM命令
			{
				packet.writeByte(ChatConst.CHANNEL_GM);
				packet.writeUTF(packData.content);
				GameClient.socket.send(packet);
				return true;
			}
			else if (packData.channelId == ChatConst.CHANNEL_ROUND || packData.channelId == ChatConst.CHANNEL_HORN || packData.channelId == ChatConst.CHANNEL_SUPERHORN || packData.channelId == ChatConst.
				CHANNEL_BATTLELAND)
			{
				packet.writeByte(packData.channelId);
				packet.writeUTF(packData.content);
				GameClient.socket.send(packet);
				return true;
			}
			else
			{
				return false;
			}
		}

		/*******************************************中心服**************************************************/
		/**
		 * 发送聊天包
		 * @param packData
		 *
		 */
		public function sendChat(channelId:int, chatId:int, content:String):void
		{
			var packet:TPacketOut = new TPacketOut(MSG_CHATCHANNEL_SAY);
			packet.writeByte(channelId);
			packet.writeShort(chatId); //状态标识
			packet.writeUTF(content);
			ChatClient.socket.send(packet);
		}
		private static const SET_PRIVATE_BY_GUID:int = 1;
		private static const SET_PRIVATE_BY_NAME:int = 2;

		/**
		 * 设置私聊对象
		 * @param name
		 *
		 */
		public function sendPrivateChatTarget(name:String, guid:int = 0):void
		{
			var packet:TPacketOut = new TPacketOut(MSG_SET_PRIVATECHATER);
			if (guid > 0)
			{
				packet.writeByte(SET_PRIVATE_BY_GUID);
				packet.writeUnsignedInt(guid);
			}
			else
			{
				packet.writeByte(SET_PRIVATE_BY_NAME);
				packet.writeUTF(name);
			}
			ChatClient.socket.send(packet);
		}

		public function setPrivateCharterHandler(socket:ISocket, packet:TPacketIn):void
		{
			var name:String = packet.readUTF();
			signal.setInputChannel.dispatch(ChatConst.CHANNEL_PRIVATE, name);
		}
	}
}
