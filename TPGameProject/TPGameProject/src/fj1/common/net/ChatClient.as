package fj1.common.net
{
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import fj1.common.config.CustomConfig;
	import fj1.manager.MessageManager;
	
	import tempest.common.net.TSocket;
	import tempest.common.net.vo.TPacketOut;
	import tempest.common.time.vo.TimerData;
	import tempest.manager.TimerManager;
	
	import tpe.common.protect.NetProtect;

	public class ChatClient
	{
		//////////////////////////////////////////////////////////////
		private static var _socket:TSocket;
		private static var _netPeotect:NetProtect;
		private static var heartTimer:TimerData;
		public static var ping:uint = 0;
		public static var latency:uint = 0;
		public static const PING_MAX:uint = 255;
		public static var pingTime:uint = 0;
		//////////////////////////////////////////////////操作码//////////////////////////////////////////////////////////////////////////
		public static const CMSG_PING:uint = 0x003; //ping
		/*******************查询信息指令******************/
		public static const MSG_QUERY_OBJECT:uint = 0x00B; //查询物品/玩家

		public static function get socket():TSocket
		{
			if (_socket == null)
			{
				var throwError:Boolean = false;
				CONFIG::debugging
				{
					throwError = true;
				}
				_netPeotect = new NetProtect();
				_socket = new TSocket("chat", throwError, _netPeotect.encrypt, _netPeotect.decrypt);
				_socket.signals.connect.add(onSocketConnectHandler);
				_socket.signals.ioError.add(onSocketErrorHandler);
				_socket.signals.securityError.add(onSocketErrorHandler);
				_socket.signals.close.add(onSocketCloseHandler);
			}
			return _socket;
		}

		private static function onSocketConnectHandler(e:Event):void
		{
			//			HeartStart();
			socket.protect = false;
			_netPeotect.init();
		}

		private static function onSocketCloseHandler(e:Event):void
		{
			HeartStop();
			//			MessageManager.instance.addHintById_client(1113, "与聊天服务器断开!");
		}

		private static function onSocketErrorHandler(e:Event):void
		{
			MessageManager.instance.addHintById_client(1114, "连接聊天服务器失败!");
		}

		public static function HeartStart():void
		{
			if (heartTimer == null)
			{
				heartTimer = TimerManager.createNormalTimer(CustomConfig.instance.keeplive * 1000, 0, sendPing)
			}
			heartTimer.start();
		}

		public static function HeartStop():void
		{
			if (heartTimer)
			{
				heartTimer.stop();
			}
		}

		/**
		 * 发送心跳包
		 */
		public static function sendPing():void
		{
			pingTime = getTimer();
			var _packet:TPacketOut = new TPacketOut(CMSG_PING);
			_packet.writeUnsignedInt((ping += 1) % PING_MAX);
			_packet.writeUnsignedInt(latency);
			socket.send(_packet);
		}

		/**
		 * 查询玩家物品
		 * @param moneyGet
		 *
		 */
		public static function sendQueryObject(loaderId:int, playerId:uint, itemGuid:int, queryType:int):void
		{
			var packet:TPacketOut = new TPacketOut(MSG_QUERY_OBJECT);
			packet.writeUnsignedInt(playerId);
			packet.writeUnsignedInt(itemGuid);
			packet.writeUnsignedInt(loaderId);
			packet.writeByte(queryType);
			socket.send(packet);
		}
	}
}
