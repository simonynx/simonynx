package fj1.modules.scene.net
{
	import fj1.common.GameInstance;
	import fj1.common.net.GameClient;
	import fj1.common.staticdata.SceneCharacterType;
	import fj1.modules.scene.signals.SceneSignals;

	import flash.geom.Point;

	import tempest.common.graphics.TLine;
	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.common.mvc.base.Actor;
	import tempest.common.net.vo.TPacketIn;
	import tempest.common.net.vo.TPacketOut;
	import tempest.core.ISocket;
	import tempest.engine.SceneCharacter;
	import tempest.engine.helper.MoveHelper;

	public class SceneService extends Actor
	{
		private static const log:ILogger = TLog.getLogger(SceneService);

		public static const MSG_MOVE_RUN:uint = 0x012; //玩家移动
		public static const MSG_TRANSPOTR_REQUEST:uint = 0x019; //传送请求
		public static const SMSG_MODIFY_POS:uint = 0x095; //坐标修正
		public static const CMSG_PLAYER_LOGIN_ENTER:uint = 0x022; //请求进入场景	 
		public static const SMSG_PLAYER_INITFINISH:uint = 0x0DD; //上线所有角色数据下发完毕


		[Inject]
		public var sceneSignals:SceneSignals;

		public function SceneService()
		{
			super();
		}

		public override function init():void
		{
			GameClient.socket.mapOpcodes([MSG_MOVE_RUN], objectMoveHandler);
			GameClient.socket.mapOpcodes([SMSG_MODIFY_POS], updatePositionHandler); /*坐标修正*/
			GameClient.socket.mapOpcodes([SMSG_PLAYER_INITFINISH], handlerInitedHandler); /*坐标修正*/
			GameClient.socket.mapOpcodes([MSG_TRANSPOTR_REQUEST], transportHandler); /*传送地图*/
		}

		private function objectMoveHandler(socket:ISocket, packet:TPacketIn):void
		{
			var guid:uint = packet.readUnsignedInt();
			var obj:SceneCharacter = GameInstance.scene.getCharacterById(guid) as SceneCharacter;
			if (obj)
			{
				if (obj.type == SceneCharacterType.MONSTER) //屏蔽怪物移动
				{
					return;
				}

				var type:uint = packet.readUnsignedByte(); //暂未使用
				var dir:uint = packet.readUnsignedByte();
				var cont:uint = packet.readUnsignedByte();
				var path:Array = [];
				for (var i:int = 0; i != cont; i++)
				{
					var p:Point = new Point(packet.readUnsignedShort(), packet.readUnsignedShort());
					path.push(p);
				}
				if (path.length == 2)
				{
//					if (obj.type == SceneCharacterType.PLAYER)
//					{
//						var moveCallBack:MoveCallBack = null;
//						if (obj.follower != null) //第三方玩家同步召唤兽非战斗状态的跟随
//						{
//							if (Pet(obj.follower.data).moveModel == 0)
//							{
//								moveCallBack = new MoveCallBack();
//								moveCallBack.onWalkThrough = PetHelper.onCharWalkThrough;
//							}
//						}
//					}
					MoveHelper.walk0(obj, new TLine(path[0], path[1]).split(), null, -1, 0, null);
				}
			}
		}

		public function updatePositionHandler(socket:ISocket, packet:TPacketIn):void
		{
			var guid:uint = packet.readUnsignedInt();
			var char:SceneCharacter = GameInstance.mainChar;
			if (guid != char.id)
			{
				char = GameInstance.scene.getCharacterById(guid);
			}
			if (char)
			{
				var x:int = packet.readUnsignedShort();
				var y:int = packet.readUnsignedShort();
				var o:int = packet.readUnsignedByte();
				char.reviseTile(x, y);
			}
		}

		private function transportHandler(socket:ISocket, packet:TPacketIn):void
		{
			var transportId:uint = packet.readUnsignedInt();
			var mapId:uint = packet.readUnsignedInt();
			var posX:uint = packet.readUnsignedInt();
			var posY:uint = packet.readUnsignedInt();
			sceneSignals.switchScene.dispatch(mapId);
			GameInstance.mainChar.tile_x = posX;
			GameInstance.mainChar.tile_y = posY;
		}

		private function handlerInitedHandler(socket:ISocket, packet:TPacketIn):void
		{
			var moveType:int = packet.readByte(); //移动类型  无效
			log.info("主角初始化完成!");
		}

		////////////////////////////////////////////////发送指令函数/////////////////////////////////////////////////////

		/**
		 * 传送请求
		 * @param guid
		 */
		public function sendTransportRequest(guid:uint):void
		{
			var packet:TPacketOut = new TPacketOut(MSG_TRANSPOTR_REQUEST);
			packet.writeUnsignedInt(guid);
			GameClient.socket.send(packet);
			log.info("发送传送点触发 id:{0}", guid);
		}

		/**
		 * 发送移动信息
		 * @param moveType
		 * @param orientation
		 * @param path
		 * @param petPosition
		 * @param petOrientation
		 */
		public function sendMove(moveType:int, dir:int, path:Array, petPosition:Point = null, petOrientation:int = 0):void
		{
			if (path && path.length != 0)
			{
				var packet:TPacketOut = new TPacketOut(MSG_MOVE_RUN);
				packet.writeByte(moveType);
				packet.writeByte(dir);
				packet.writeByte(path.length);
				for (var i:int = 0; i != path.length; i++)
				{
					packet.writeShort(path[i].x);
					packet.writeShort(path[i].y);
				}
				if (moveType == 2 && petPosition != null)
				{
					packet.writeShort(petPosition.x);
					packet.writeShort(petPosition.y);
					packet.writeByte(petOrientation);
				}
				GameClient.socket.send(packet);
				log.info("发送移动信息 moveType:{0}, x:{1}, y:{2}", moveType, path[1].x, path[1].y); //DEBUG
			}
		}


		/**
		 * 发送进入游戏世界请求
		 */
		public function sendEnterWorldRequest():void
		{
			var packet:TPacketOut = new TPacketOut(CMSG_PLAYER_LOGIN_ENTER);
			GameClient.socket.send(packet);
			log.info("发送进入场景");
		}

		/**
		 * 传送请求
		 * @param guid
		 */
		public static function sendTransportRequest(guid:uint):void
		{
			var packet:TPacketOut = new TPacketOut(MSG_TRANSPOTR_REQUEST);
			packet.writeUnsignedInt(guid);
			GameClient.socket.send(packet);
			log.info("发送传送点触发 id:{0}", guid);
		}

	}
}
