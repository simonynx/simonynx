package fj1.modules.friend.service
{
	import fj1.common.GameInstance;
	import fj1.common.net.ChatClient;
	import fj1.common.net.GameClient;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.res.map.MapResManager;
	import fj1.common.res.map.vo.MapRes;
	import fj1.common.staticdata.ChatConst;
	import fj1.common.staticdata.FriendConst;
	import fj1.common.ui.TAlertMananger;
	import fj1.manager.FloatIconManager;
	import fj1.manager.MessageManager;
	import fj1.modules.chat.helper.ChatStringHelper;
	import fj1.modules.chat.model.vo.ChatData;
	import fj1.modules.chat.singles.ChatSignal;
	import fj1.modules.friend.model.FindInfo;
	import fj1.modules.friend.model.FriendModel;
	import fj1.modules.friend.model.vo.BlackInfo;
	import fj1.modules.friend.model.vo.EnemyInfo;
	import fj1.modules.friend.model.vo.FriendInfo;
	import fj1.modules.friend.signals.FriendSignal;
	import fj1.modules.messageBox.model.MessageModel;
	import fj1.modules.messageBox.model.vo.MessageInfo;
	import fj1.modules.scene.util.MainCharWalkManager;
	import flash.geom.Point;
	import tempest.common.mvc.base.Actor;
	import tempest.common.net.vo.TPacketIn;
	import tempest.common.net.vo.TPacketOut;
	import tempest.core.ISocket;
	import tempest.ui.components.TAlert;
	import tempest.ui.events.TAlertEvent;

	public class FriendService extends Actor
	{
		[Inject]
		public var signal:FriendSignal;
		[Inject]
		public var model:FriendModel;
		[Inject]
		public var messageModel:MessageModel;
		[Inject]
		public var chatSignal:ChatSignal;
		//游戏服
		public static const MSG_FRIEND_REQUEST:uint = 0x130; //添加好友请求
		public static const MSG_FRIEND_REMOVE:uint = 0x101; //删除好友或黑名单请求
		public static const MSG_FRIENDS_ENUM:uint = 0x102; //下发好友列表
		public static const MSG_FRIEND_RESPONSE:uint = 0x103; //添加好友成功
		public static const MSG_BLACKLIST_REQUEST:uint = 0x104; //添加黑名单请求
		public static const MSG_BLACKLIST_ENUM:uint = 0x105; //下发黑名单列表
		public static const MSG_BLACKLIST_APPEND:uint = 0x106; //把好友移到黑名单请求
		public static const MSG_FRIEND_REJECT:uint = 0x1fe; //拒绝好友请求
		public static const SMSG_REL_UPDATE:uint = 0x1FD; //更新和下发好友黑名单数据
		public static const CMSG_REL_REMOVEALL:uint = 0x1F7; //清空黑名单
		public static const CMSG_ENEMYLIST_ENUM:uint = 0x137; //查询仇人列表
		public static const MSG_ENEMY_POS_TRACE:uint = 0x138; //查询仇人位置
		public static const MSG_SOCIAL_ENEMY_ADD:uint = 0x176; //添加仇人请求
		//中心服
		public static const MSG_QUERY_CHARINFO_BYNAME:uint = 0x030; //查找好友

		public function FriendService()
		{
			super();
		}

		override public function init():void
		{
			//游戏服
			GameClient.socket.mapOpcodes([MSG_FRIEND_REQUEST], friendRequestAskHandler);
			GameClient.socket.mapOpcodes([MSG_FRIEND_REMOVE], friendDelResponseHandler);
			GameClient.socket.mapOpcodes([MSG_FRIEND_RESPONSE], friendAddHandler);
			GameClient.socket.mapOpcodes([MSG_BLACKLIST_REQUEST], friendBlackAddHandler);
			GameClient.socket.mapOpcodes([MSG_BLACKLIST_APPEND], friendBlackAddHandler);
			GameClient.socket.mapOpcodes([MSG_FRIEND_REJECT], friendRepulseHandler);
			GameClient.socket.mapOpcodes([SMSG_REL_UPDATE], friendOpenHandler);
			GameClient.socket.mapOpcodes([CMSG_REL_REMOVEALL], friendDelAllBlackHandler);
			GameClient.socket.mapOpcodes([MSG_ENEMY_POS_TRACE], enemyPosTraceHandler);
			GameClient.socket.mapOpcodes([MSG_SOCIAL_ENEMY_ADD], enemyAddHandler);
			//中心服
			ChatClient.socket.mapOpcodes([MSG_QUERY_CHARINFO_BYNAME], findRequestHandler);
		}

		/**
		 * 发送添加好友请求返回
		 * @param socket
		 * @param packet
		 *
		 */
		public function friendRequestAskHandler(socket:ISocket, packet:TPacketIn):void
		{
			var amount:int = packet.readUnsignedByte();
			var guid:int = packet.readUnsignedInt(); //对方GUID
			var name:String = packet.readUTF();
			var str:String = LanguageManager.translate(9000, "想添加你为好友！");
			if (model.getEntity(FriendConst.TYPE_BLACK, guid))
			{
				sendRepulseRequest(guid);
			}
			else if (model.getEntity(FriendConst.TYPE_ENEMY, guid))
			{
				sendRepulseRequest(guid);
			}
			else
			{
				//系统设置拒绝接受好于请求
				if (model.autoRefuseRequest)
				{
					sendRepulseRequest(guid);
					return;
				}
				var messageInfo:MessageInfo = new MessageInfo(guid, name, MessageInfo.MESSAGE_KIND_FRIEND, str, agree, disagree);
				if (messageModel.friendMessage.length == 0)
				{
					FloatIconManager.instance.createIcon(MessageInfo.MESSAGE_KIND_FRIEND, FloatIconManager.NAME_FRIEND);
				}
				messageModel.addData(messageModel.friendMessage, messageInfo);
			}
		}

		private function agree(messageInfo:MessageInfo):void
		{
			sendFriendEnsureRequest(messageInfo.id);
		}

		private function disagree(messageInfo:MessageInfo):void
		{
			sendRepulseRequest(messageInfo.id);
			MessageManager.instance.addHintById_client(2004, "你拒绝了%s的好友请求", messageInfo.name);
		}

		/**
		 *发送添加好友请求
		 * @param guid
		 *
		 */
		public function sendFriendAddRequest(guid:uint):void
		{
			var packet:TPacketOut = new TPacketOut(MSG_FRIEND_REQUEST);
			packet.writeUnsignedInt(guid);
			GameClient.socket.send(packet);
		}

		/**
		 * 删除好友或黑名单或仇人返回
		 * @param socket
		 * @param packet
		 *
		 */
		public function friendDelResponseHandler(socket:ISocket, packet:TPacketIn):void
		{
			var succeed:int = packet.readUnsignedByte();
			if (succeed == FriendConst.ADD_SUCCEED)
			{
				var type:int = packet.readUnsignedByte();
				var guid:int = packet.readUnsignedInt();
				switch (type)
				{
					case FriendConst.TYPE_FRIEND:
						var friendInfo:FriendInfo = FriendInfo(model.removeEntity(FriendConst.TYPE_FRIEND, guid));
						if (friendInfo)
						{
							MessageManager.instance.addHintById_client(2003, "成功解除%s的%s关系", friendInfo.name, LanguageManager.translate(9004, "好友"));
						}
						break;
					case FriendConst.TYPE_BLACK:
						var blackInfo:BlackInfo = BlackInfo(model.removeEntity(FriendConst.TYPE_BLACK, guid));
						if (blackInfo)
						{
							MessageManager.instance.addHintById_client(2003, "成功解除%s的%s关系", blackInfo.name, LanguageManager.translate(9005, "黑名单"));
						}
						break;
					case FriendConst.TYPE_ENEMY:
						var enemyInfo:EnemyInfo = EnemyInfo(model.removeEntity(FriendConst.TYPE_ENEMY, guid));
						if (enemyInfo)
						{
							MessageManager.instance.addHintById_client(2003, "成功解除%s的%s关系", enemyInfo.name, LanguageManager.translate(9013, "仇人"));
						}
						break;
				}
			}
		}

		/**
		 *删除好友或黑名单或仇人
		 * @param guid
		 *
		 */
		public function sendFriendDelRequest(guid:uint, myint:int):void
		{
			var packet:TPacketOut = new TPacketOut(MSG_FRIEND_REMOVE);
			packet.writeUnsignedInt(guid);
			packet.writeByte(myint);
			GameClient.socket.send(packet);
		}

		/**
		 * 下发好友列表
		 *
		 */
		public function sendFriendRequest():void
		{
			var packet:TPacketOut = new TPacketOut(MSG_FRIENDS_ENUM);
			GameClient.socket.send(packet);
		}

		public function friendAddHandler(socket:ISocket, packet:TPacketIn):void
		{
			var amount:int = packet.readUnsignedByte();
			if (amount == FriendConst.ADD_SUCCEED)
			{
				var guid:int = packet.readUnsignedInt();
				var name:String = packet.readUTF();
				var lv:uint = packet.readUnsignedByte();
				var isOnline:Boolean = packet.readByte() != 0;
				model.addRelation(FriendConst.TYPE_FRIEND, new FriendInfo(name, lv, isOnline, guid));
				//恭喜你和%s成为好友
				MessageManager.instance.addHintById_client(2001, "恭喜你和%s成为好友", name);
			}
		}

		/**
		 *同意添加好友
		 * @param guid
		 *
		 */
		public function sendFriendEnsureRequest(guid:uint):void
		{
			var packet:TPacketOut = new TPacketOut(MSG_FRIEND_RESPONSE);
			packet.writeUnsignedInt(guid);
			GameClient.socket.send(packet);
		}

		/**
		 *  发送添加黑名单请求返回
		 * @param socket
		 * @param packet
		 *
		 */
		public function friendBlackAddHandler(socket:ISocket, packet:TPacketIn):void
		{
			var amount:int = packet.readUnsignedByte();
			if (amount == FriendConst.ADD_SUCCEED)
			{
				var guid:int = packet.readUnsignedInt();
				var name:String = packet.readUTF();
				var lv:uint = packet.readUnsignedByte();
				var isOnline:Boolean = packet.readByte() != 0;
				model.addRelation(FriendConst.TYPE_BLACK, new BlackInfo(name, lv, isOnline, guid));
				MessageManager.instance.addHintById_client(2002, "成功将%s添加到黑名单", name);
			}
		}

		/**
		 *发送添加黑名单请求
		 * @param friendInfo
		 *
		 */
		public function sendBlackAddRequest(guid:uint, name:String, level:int, online:int):void
		{
			var packet:TPacketOut = new TPacketOut(MSG_BLACKLIST_REQUEST);
			packet.writeUnsignedInt(guid);
			packet.writeUTF(name);
			packet.writeUnsignedInt(level);
			packet.writeUnsignedInt(online);
			GameClient.socket.send(packet);
		}

		/**
		 * 黑名单的发送请求
		 *
		 */
		public function sendBlackRequest():void
		{
			var packet:TPacketOut = new TPacketOut(MSG_BLACKLIST_ENUM);
			GameClient.socket.send(packet);
		}

		/**
		 *把好友添加到黑名单
		 * @param guid
		 *
		 */
		public function sendFriendMoveToRequest(guid:uint):void
		{
			var packet:TPacketOut = new TPacketOut(MSG_BLACKLIST_APPEND);
			packet.writeUnsignedInt(guid);
			GameClient.socket.send(packet);
		}

		/**
		 * 拒绝添加好友请求返回
		 * @param socket
		 * @param packet
		 *
		 */
		public function friendRepulseHandler(socket:ISocket, packet:TPacketIn):void
		{
			var amount:int = packet.readUnsignedByte();
			var name:String = packet.readUTF();
			MessageManager.instance.addHintById_client(2005, "%s拒绝了你的好友请求", name);
		}

		/**
		 *拒绝添加好友请求
		 * @param guid
		 *
		 */
		public function sendRepulseRequest(guid:uint):void
		{
			var packet:TPacketOut = new TPacketOut(MSG_FRIEND_REJECT);
			packet.writeUnsignedInt(guid);
			GameClient.socket.send(packet);
		}

		/**
		 * 更新好友数据
		 * @param socket
		 * @param packet
		 *
		 */
		public function friendOpenHandler(socket:ISocket, packet:TPacketIn):void
		{
			var result:int = packet.readUnsignedByte();
			if (result == FriendConst.ADD_SUCCEED)
			{
				var kind:int = packet.readUnsignedByte();
				var guid:int = packet.readUnsignedInt();
				var name:String = packet.readUTF();
				var lv:uint = packet.readUnsignedByte();
				var isOnline:Boolean = packet.readByte() != 0;
				switch (kind)
				{
					case FriendConst.TYPE_FRIEND:
						var friendInfo:FriendInfo = FriendInfo(model.getEntity(FriendConst.TYPE_FRIEND, guid));
						if (friendInfo)
						{
							friendInfo.level = lv;
							friendInfo.online = isOnline;
						}
						else
						{
							model.addRelation(FriendConst.TYPE_FRIEND, new FriendInfo(name, lv, isOnline, guid));
						}
						break;
					case FriendConst.TYPE_BLACK:
						var blackInfo:BlackInfo = BlackInfo(model.getEntity(FriendConst.TYPE_BLACK, guid));
						if (blackInfo)
						{
							blackInfo.level = lv;
							blackInfo.online = isOnline;
						}
						else
						{
							model.addRelation(FriendConst.TYPE_BLACK, new BlackInfo(name, lv, isOnline, guid));
						}
						break;
					case FriendConst.TYPE_ENEMY:
						var killTime:int = packet.readUnsignedInt();
						var profession:int = packet.readByte();
						var enemyInfo:EnemyInfo = EnemyInfo(model.getEntity(FriendConst.TYPE_ENEMY, guid));
						if (enemyInfo)
						{
							enemyInfo.level = lv;
							enemyInfo.killTime = killTime;
							//杀人数有变更的项放在开头
							model.removeEntity(FriendConst.TYPE_ENEMY, guid);
							model.addEntityAt(FriendConst.TYPE_ENEMY, enemyInfo, 0);
						}
						else
						{
							model.addEntityAt(FriendConst.TYPE_ENEMY, new EnemyInfo(guid, name, lv, profession, killTime, isOnline), 0);
						}
						break;
					default:
						break;
				}
			}
		}

		/**
		 * 清空黑名单或仇人
		 * @param socket
		 * @param packet
		 *
		 */
		public function friendDelAllBlackHandler(socket:ISocket, packet:TPacketIn):void
		{
			var amount:int = packet.readUnsignedByte();
			if (amount == FriendConst.TYPE_BLACK)
			{
				model.delAllData(FriendConst.TYPE_BLACK);
				MessageManager.instance.addHintById_client(2006, "清空黑名单成功！");
			}
			else if (amount == FriendConst.TYPE_ENEMY)
			{
				model.delAllData(FriendConst.TYPE_ENEMY);
				MessageManager.instance.addHintById_client(2027, "清空仇人列表成功！");
			}
		}

		/**
		 * 清空黑名单或仇人
		 *
		 */
		public function sendDelAll(type:int):void
		{
			var packet:TPacketOut = new TPacketOut(CMSG_REL_REMOVEALL);
			packet.writeByte(type);
			GameClient.socket.send(packet);
		}

		/**
		 * 仇人列表的发送请求
		 *
		 */
		public function sendEnmeyRequest():void
		{
			var packet:TPacketOut = new TPacketOut(CMSG_ENEMYLIST_ENUM);
			GameClient.socket.send(packet);
		}

		/**
		 * 仇人追踪结果
		 * @param socket
		 * @param packet
		 *
		 */
		public function enemyPosTraceHandler(socket:ISocket, packet:TPacketIn):void
		{
			var lineId:int = packet.readUnsignedByte();
			var mapId:int = packet.readInt();
			var posX:int = packet.readShort();
			var posY:int = packet.readShort();
			var mapRes:MapRes = MapResManager.getMapRes(mapId);
			if (!mapRes)
			{
				return;
			}
			//提示框
			var alert:TAlert = TAlertMananger.showAlert(9015, LanguageManager.translate(9015, "该玩家位于{0}线{1}地图 X：{2},Y：{3}", lineId, mapRes.name, posX, posY), false, TAlert.OK, function(e:TAlertEvent):void
			{
				if (e.flag == TAlert.OK)
				{
					MainCharWalkManager.heroWalk([mapId, new Point(posX, posY), 0], true);
				}
			});
			alert.setButtonText(TAlert.OK, LanguageManager.translate(50475, "追踪"));
			//构造交互频道聊天包并发送
			var chatPack:ChatData = new ChatData();
			chatPack.channelId = ChatConst.CHANNEL_MUTUAL;
			chatPack.content = ChatStringHelper.makeLinkMaskStr(ChatConst.MUTUAL_TYPE_ENEMY, [lineId, mapId, posX, posY]);
			chatSignal.resive.dispatch(chatPack);
		}

		/**
		 * 仇人追踪请求
		 *
		 */
		public function sendEnemyPosTrace(playerId:int):void
		{
			var packet:TPacketOut = new TPacketOut(MSG_ENEMY_POS_TRACE);
			packet.writeInt(playerId);
			GameClient.socket.send(packet);
		}

		/**
		 * 请求添加仇人
		 * @param socket
		 * @param packet
		 *
		 */
		public function enemyAddHandler(socket:ISocket, packet:TPacketIn):void
		{
			var resFlag:int = packet.readUnsignedByte();
			if (resFlag == FriendConst.ADD_SUCCEED)
			{
				var guid:int = packet.readUnsignedInt();
				var name:String = packet.readUTF();
				var level:int = packet.readUnsignedByte();
				var isOnline:Boolean = (packet.readByte() != 0);
				var times:int = packet.readUnsignedInt();
				var pro:int = packet.readUnsignedByte();
				model.addRelation(FriendConst.TYPE_ENEMY, new EnemyInfo(guid, name, level, pro, times, isOnline));
				MessageManager.instance.addHintById_client(2035, "成功将%s添加到仇人列表", name);
			}
			else
			{
				MessageManager.instance.addHintById_client(2037, "添加仇人失败");
			}
		}

		/**
		 *发送添加仇人请求
		 *
		 */
		public function sendEnemyAddRequest(guid:int):void
		{
			var packet:TPacketOut = new TPacketOut(MSG_SOCIAL_ENEMY_ADD);
			packet.writeUnsignedInt(guid);
			GameClient.socket.send(packet);
		}

		//************************中心服************************
		/**
		 * 根据名字查找玩家返回
		 * @param socket
		 * @param packet
		 *
		 */
		public function findRequestHandler(socket:ISocket, packet:TPacketIn):void
		{
			//在线状态
			var onLine:int = packet.readUnsignedByte();
			if (onLine == FriendConst.TYPE_ONLINE)
			{
				//guid
				var guid:int = packet.readUnsignedInt();
				//名字
				var name:String = packet.readUTF();
				//职业
				var profession:uint = packet.readUnsignedByte();
				//等级
				var lv:uint = packet.readUnsignedByte();
				//神力
				var power:uint = packet.readUnsignedInt();
				//
				var findInfo:FindInfo = new FindInfo(guid, name, lv, profession, onLine, power);
				model.findInfo = findInfo;
				//
				signal.findPlayerData.dispatch();
			}
			else
			{
				signal.cannotFindPlayer.dispatch();
			}
		}

		/**
		 * 根据名字查找玩家
		 * @param name
		 *
		 */
		public function findPlayerByName(name:String):void
		{
			var packet:TPacketOut = new TPacketOut(MSG_QUERY_CHARINFO_BYNAME);
			packet.writeUTF(name);
			packet.writeUnsignedInt(0);
			ChatClient.socket.send(packet);
		}
	}
}
