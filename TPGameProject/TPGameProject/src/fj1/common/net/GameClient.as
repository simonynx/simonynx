package fj1.common.net
{
	import com.adobe.crypto.SHA1;
	import com.adobe.utils.DictionaryUtil;
	import fj1.common.GameConfig;
	import fj1.common.GameInstance;
	import fj1.common.config.CustomConfig;
	import fj1.common.config.SystemConfig;
	import fj1.common.helper.TAlertHelper;
	import fj1.common.net.gamehandler.PongHandler;
	import fj1.common.net.gamehandler.back.TransportSuccessHandler;
	import fj1.common.net.gamehandler.objupdate.ObjectDestoryHandler;
	import fj1.common.net.gamehandler.objupdate.ObjectUpdateHandler;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.staticdata.ChatConst;
	import fj1.manager.MessageManager;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	import flash.utils.flash_proxy;
	import flash.utils.getTimer;
	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.common.net.TSocket;
	import tempest.common.net.vo.TByteArray;
	import tempest.common.net.vo.TPacketOut;
	import tempest.common.time.vo.TimerData;
	import tempest.core.ISocket;
	import tempest.engine.SceneCharacter;
	import tempest.engine.vo.config.MapConfig;
	import tempest.manager.TimerManager;
	import tempest.ui.components.TAlert;
	import tempest.ui.events.DataEvent;
	import tempest.ui.events.TAlertEvent;
	import tpe.common.protect.NetProtect;

	public class GameClient
	{
		///////////////////////////////////////////////////////////////////// 
		public static const CMSG_PING:uint = 0x003; //ping
		public static const SMSG_PONG:uint = 0x004; //ping返回	 
		/****************检测玩家名是否存在***************/
		public static const MSG_CHECK_NAME:uint = 0x0F0; //检测玩家名是否存在
		/****************属性更新系统***************/
		public static const SMSG_OBJECT_DESTROY:uint = 0x00D; //生物销毁		 
		public static const SMSG_UPDATE_OBJECT:uint = 0x013; //更新对象	 
		//
		/****************物品系统***************/
		public static const MSG_USE_ITEM:uint = 0x016; //使用物品
		public static const CMSG_MOVEPOS_ITEM:uint = 0x036; //物品移动位置
		public static const MSG_BACKPACK_SYN:int = 0x132; //背包数据刷新
		public static const MSG_DROP_ITEM:uint = 0x038; //丢弃物品
		/**********************移动*******************/
		public static const CMSG_CHAR_STOPMOVE:uint = 0x09F; //停止移动
		/**********************传送*******************/
		public static const CMSG_GO:uint = 0x0BD; //	传功能 
		////////////////////////////////////////////////////////////
		public static var ServerSeed:uint = 0;
		public static var ClientSeed:uint = 0;
		private static var _socket:TSocket;
		private static var _netPeotect:NetProtect;
		private static const log:ILogger = TLog.getLogger(GameClient);

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
				_socket = new TSocket("line", throwError, _netPeotect.encrypt, _netPeotect.decrypt);
//				if (CustomConfig.instance.protocol_protect != 0)
//				{
//					_socket.protect = true;
//				}
				_socket.signals.connect.add(onSocketConnectHandler);
				_socket.signals.ioError.add(onSocketErrorHandler);
				_socket.signals.close.add(onSocketCloseHandler);
				_socket.mapHandleClses([[SMSG_PONG, PongHandler],
					[SMSG_OBJECT_DESTROY, ObjectDestoryHandler], /*对象销毁*/
					[SMSG_UPDATE_OBJECT, ObjectUpdateHandler],
					[CMSG_GO, TransportSuccessHandler],
					]);
//				ScriptClient.mapHandleClses();
			}
			return _socket;
		}

		private static function onSocketConnectHandler(e:Event):void
		{
			log.info("游戏服务器连接成功!");
			socket.protect = false;
			_netPeotect.init();
//			HeartStart();
		}

		private static function onSocketErrorHandler(e:Event):void
		{
			TAlertHelper.showAlert(1722, "服务器连接失败!");
//			GameInstance.ui.loginUI.showLineSelectPanel();
		}
		public static var showAlert:Boolean = true;

		private static function onSocketCloseHandler(e:Event):void
		{
			HeartStop();
			if (showAlert)
			{
				TAlertHelper.showDialog(1723, "与游戏服务器断开", true, TAlert.OK, function(e:DataEvent):void
				{
					CustomConfig.instance.reload();
				});
			}
		}

		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		public static function Connect(host:String, port:int):void
		{
			if (!socket.connected)
				socket.connect(host, port);
		}

		public static function DisConnect():void
		{
			if (socket != null && socket.connected)
			{
				socket.close();
				HeartStop();
			}
		}
		private static var heartTimer:TimerData;

		public static function HeartStart():void
		{
			if (heartTimer == null)
			{
				heartTimer = TimerManager.createNormalTimer(CustomConfig.instance.keeplive * 1000, 0, sendPing);
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
		public static var ping:uint = 0;
		public static var latency:uint = 0;
		public static const PING_MAX:uint = 255;
		public static var pingTime:uint = 0;

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
			log.info("发送心跳 ping:{0} pingTime:{1}", ping, pingTime);
		}

		/**********************姓名检查***********************/
		/**
		 * 姓名检查
		 * @param type
		 * @param name
		 *
		 */
		public static function sendCheckNameRequest(type:int, name:String):void
		{
			var packet:TPacketOut = new TPacketOut(MSG_CHECK_NAME);
			packet.writeInt(type);
			packet.writeUTF(name);
			socket.send(packet);
		}

		/****************************************物品操作*****************************************************/
		public static function sendItemUse(guId:uint, pos:int):void
		{
			var packet:TPacketOut = new TPacketOut(MSG_USE_ITEM);
			packet.writeUnsignedInt(guId);
			packet.writeByte(pos);
			socket.send(packet);
			log.info("发送物品使用 id:{0} pos:{1}", guId, pos);
		}

		public static function sendItemMove(guId:uint, oldSlot:uint, newSlot:uint):void
		{
			var packet:TPacketOut = new TPacketOut(CMSG_MOVEPOS_ITEM);
			packet.writeUnsignedInt(guId);
			packet.writeUnsignedInt(oldSlot);
			packet.writeUnsignedInt(newSlot);
			socket.send(packet);
			log.info("发送物品移动 id:{0} oldPos:{1} newPos:{2}", guId, oldSlot, newSlot);
		}

		/**
		 * 发送整理请求
		 * @param containerType
		 * @param moveArray
		 *
		 */
		public static function sendTidyup(containerType:int, moveArray:Array):void
		{
			var packet:TPacketOut = new TPacketOut(MSG_BACKPACK_SYN);
			packet.writeByte(containerType);
			packet.writeShort(moveArray.length);
			for each (var moveOperate:Array in moveArray)
			{
				packet.writeUnsignedInt(moveOperate[0]); //guid
				packet.writeUnsignedInt(moveOperate[1]); //posOld
				packet.writeUnsignedInt(moveOperate[2]); //posNew
			}
			socket.send(packet);
		}

		public static function sendDropItem(guId:uint, slot:int):void
		{
			var packet:TPacketOut = new TPacketOut(MSG_DROP_ITEM);
			packet.writeUnsignedInt(guId);
			packet.writeByte(slot);
			socket.send(packet);
			log.info("发送丢弃物品 id:{0} pos:{1}", guId, slot);
		}

		/**
		 *主角停止移动
		 *
		 */
		public static function sendStopMove():void
		{
			var packet:TPacketOut = new TPacketOut(CMSG_CHAR_STOPMOVE);
			socket.send(packet);
		}

		/**
		*传送
		* @param placeID
		*
		*/
		public static function sendPlace(placeID:int, taskID:int, npcID:int):void
		{
			var packet:TPacketOut = new TPacketOut(CMSG_GO);
			packet.writeUnsignedInt(placeID);
			packet.writeUnsignedInt(taskID);
			packet.writeUnsignedInt(npcID);
			socket.send(packet);
		}
	}
}
