package fj1.modules.login.net
{
	import com.adobe.crypto.SHA1;

	import fj1.common.GameConfig;
	import fj1.common.GameInstance;
	import fj1.common.GameState;
	import fj1.common.config.CustomConfig;
	import fj1.common.helper.TAlertHelper;
	import fj1.common.net.GameClient;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.vo.line.LineInfo;
	import fj1.manager.MessageManager;
	import fj1.manager.NetManager;
	import fj1.modules.login.model.LoginModel;
	import fj1.modules.login.model.vo.RoleInfo;
	import fj1.modules.login.signals.LoginSignal;
	import fj1.modules.login.signals.LoginUISignals;
	import fj1.modules.scene.signals.SceneSignals;

	import tempest.common.logging.*;
	import tempest.common.mvc.base.Actor;
	import tempest.common.net.TSocket;
	import tempest.common.net.vo.*;
	import tempest.common.staticdata.Colors;
	import tempest.core.ISocket;
	import tempest.ui.components.TAlert;

	public class LoginService extends Actor
	{
		[Inject]
		public var loginModel:LoginModel;

		[Inject]
		public var loginUISignals:LoginUISignals;

		[Inject]
		public var loginSignals:LoginSignal;

		private static const log:ILogger = TLog.getLogger(LoginService);
		public static const CMD_AUTH_LOGON_CHALLENGE:uint = 0x00;
		public static const CMD_AUTH_LOGON_PROOF:uint = 0x01;
		public static const SMSG_AUTH_CHALLENGE:uint = 0x001; //验证帐号	 
		public static const SMSG_AUTH_RESPONSE:uint = 0x002; //验证返回	 
		public static const CMSG_PING:uint = 0x003; //ping
		public static const SMSG_PONG:uint = 0x004; //ping返回	 
		public static const CMSG_AUTH_SESSION:uint = 0x005; //验证SessionKey		 
		public static const CMSG_CHAR_CREATE:uint = 0x006; //请求创建角色		 
		public static const SMSG_CHAR_CREATE:uint = 0x007; //请求创建角色	 
		public static const CMSG_CHAR_ENUM:uint = 0x008; //查询角色列表		 
		public static const SMSG_CHAR_ENUM:uint = 0x009; //服务器返回角色列表		 
		public static const CMSG_CHAR_DELETE:uint = 0x00A; //请求删除角色	 
		public static const SMSG_CHAR_DELETE:uint = 0x00B; //请求删除角色
		public static const CMSG_PLAYER_LOGIN:uint = 0x00E; //选择角色登入	 
		public static const CMD_REALM_LIST:uint = 0x10;
		public static const CMD_AUTH_SECPSWD:uint = 0x20; //二次密码
		public static const SMD_AUTH_LOGON_BIND:uint = 0x40;
		///////////////////////////////////////////////////////////////////////////
		public static const SUCCESS:uint = 0x00; //校验通过
		public static const FAIL_IP_BANNED:uint = 0x01; //ip被封
		public static const FAIL_BANNED:uint = 0x02; //账号冻结
		public static const FAIL_INCORRECT_PASSWORD:uint = 0x05; //密码错误
		public static const TIME_OUT:uint = 0x06; //超时
		//*****************************************************
		public static const HAVE_SECONDPWD:uint = 0; //有二次密码
		public static const NOTHAVE_SECONDPWD:uint = 1; //没有二次密码
		public static const SECONDPWD_FAILD:uint = 2; //二次密码错误
		public static const SECONDPWD_OVER:uint = 3; //二次密码错误超过上限
		public static const SECONDPWD_SUCC:uint = 4; //二次密码登入成功
		public static const SECONDPWD_INPUT:uint = 5; //登入二次密码（前端上发）
		public static const SECONDPWD_REPAIR:uint = 6; //修改二次密码（前端上发）
		public static const SECONDPWD_AUTH:uint = 7; //校验二次密码（前端上发）
		//
		private var p2_key:int; //服务器下发的随机值

		public override function init():void
		{
			NetManager.loginSocket.mapOpcodes([CMD_AUTH_LOGON_PROOF, CMD_REALM_LIST, SMD_AUTH_LOGON_BIND, CMD_AUTH_SECPSWD], loginSocketHandler);
			GameClient.socket.mapOpcodes([SMSG_AUTH_CHALLENGE], authChallengeHandler); /*验证返回*/
			GameClient.socket.mapOpcodes([SMSG_AUTH_RESPONSE], authResponseHandler); /*验证返回*/
			GameClient.socket.mapOpcodes([SMSG_CHAR_ENUM], characterOverviewHandler); /*劫色列表*/
			GameClient.socket.mapOpcodes([SMSG_CHAR_CREATE], characterCreateHandler); /*角色创建*/
			GameClient.socket.mapOpcodes([SMSG_CHAR_DELETE], characterDeleteHandler); /*角色删除*/
			GameClient.socket.mapOpcodes([CMSG_PLAYER_LOGIN], characterSelectHandler); /*角色删除*/
		}

		public override function dispose():void
		{
			NetManager.loginSocket.unmapOpcodes([CMD_AUTH_LOGON_PROOF, CMD_REALM_LIST, SMD_AUTH_LOGON_BIND, CMD_AUTH_SECPSWD]);
		}

		private function loginSocketHandler(socket:ISocket, packet:TPacketIn):void
		{
			var result:uint;
			switch (packet.cmd)
			{
				case CMD_AUTH_LOGON_PROOF:
					result = packet.readUnsignedByte();
					switch (result)
					{
						case SUCCESS: //校验通过
							GameState.LoggedIn = true;
							//获取SessionKey
							GameConfig.sessionKey = packet.readString();
							//请求服务器列表
							loginUISignals.showTipPanel.dispatch(LanguageManager.translate(45003, "正在查询线路列表..."));
							sendRequestGateServerAddress();
							break;
						case FAIL_INCORRECT_PASSWORD:
							loginUISignals.showLoginPanel.dispatch();
							TAlertHelper.showAlert(1713, "密码错误或该帐号不存在!");
							break;
						case TIME_OUT:
							loginUISignals.showLoginPanel.dispatch();
							TAlertHelper.showAlert(1710, "登陆超时!");
							break;
					}
					break;
				case SMD_AUTH_LOGON_BIND:
					result = packet.readUnsignedByte(); //封号类型
					var banDate:uint = packet.readUnsignedInt(); //冻结时间
					var unbanDate:uint = packet.readUnsignedInt(); //解除时间
					var banBy:String = packet.readUTF(); //冻结人
					var banReason:String = packet.readUTF(); //冻结原因
					switch (result)
					{
						case FAIL_BANNED:
							loginUISignals.showLoginPanel.dispatch();
							if (banDate == unbanDate)
							{
								if (CustomConfig.instance.show_band_resion == 1)
								{
									TAlertHelper.showAlert(1711, "该帐号已被永久冻结,请联系GM!\n冻结时间:%s\n冻结原因:%s", new Date(banDate * 1000).toLocaleString(), banReason);
								}
								else
								{
									TAlert.Show(LanguageManager.translate(50454, "该帐号已被冻结,请联系GM!"));
								}
							}
							else
							{
								if (CustomConfig.instance.show_band_resion == 1)
								{
									TAlertHelper.showAlert(1712, "该帐号已被冻结,请联系GM!\n冻结时间:%s\n冻结原因:%s\n解除时间:%s", new Date(banDate * 1000).toLocaleString(), banReason, new Date(unbanDate * 1000).toLocaleString());
								}
								else
								{
									TAlert.Show(LanguageManager.translate(50454, "该帐号已被冻结,请联系GM!"));
								}
							}
							break;
						case FAIL_IP_BANNED:
							loginUISignals.showLoginPanel.dispatch();
							TAlertHelper.showAlert(1715, "当前IP被禁止登陆,请联系GM!");
							break;
					}
					break;
				case CMD_REALM_LIST:
					loginUISignals.showLineSelectPanel.dispatch();
					var list:Array = [];
					var li:LineInfo;
					var count:uint = packet.readUnsignedByte();
					for (var i:int = 0; i != count; i++)
					{
						li = new LineInfo();
						li.id = packet.readUnsignedInt();
						//处理服务器名，区分游戏服务器类型
						var temp:Array = packet.readUTF().split("@");
						li.name = temp[0];
						if (temp.length > 1)
						{
							li.type = parseInt(temp[1]);
						}
						li.host = packet.readString();
						li.port = packet.readUnsignedInt();
						li.state = packet.readUnsignedByte();
						list.push(li);
					}
					list.sortOn(["state", "id"], [Array.NUMERIC, Array.NUMERIC]);
					GameInstance.lines = list;
					var newAcc:Boolean = ((packet.bytesAvailable > 0) ? packet.readUnsignedByte() : 1) == 0;
					//断开登陆服务器
					NetManager.loginSocket.close();
					loginModel.receivedLines(list, newAcc);
					break;
				case CMD_AUTH_SECPSWD: //二次密码
					result = packet.readUnsignedByte();
					var times:int = packet.readUnsignedByte(); //错误次数
					p2_key = packet.readUnsignedInt(); //随机值
					switch (result)
					{
						case NOTHAVE_SECONDPWD:
							loginUISignals.showP2SetPanel.dispatch();
							break;
						case HAVE_SECONDPWD:
							loginUISignals.showP2Panel.dispatch();
							break;
						case SECONDPWD_FAILD:
							TAlert.Show(LanguageManager.translate(1075, "密码错误，已累计错误{0}次，累计错误次数达10次将限制登陆", times));
							loginUISignals.showP2Panel.dispatch();
							break;
						case SECONDPWD_OVER:
							loginUISignals.showTipPanel.dispatch(LanguageManager.translate(1076, "密码错误次数已达10次，已被断开链接，请8小时后再进行尝试"), Colors.Red);
							break;
						case SECONDPWD_SUCC:
							break;
					}
					break;
				default:
					break;
			}
		}

		private function authChallengeHandler(socket:ISocket, packet:TPacketIn):void
		{
			var encrypt:int = packet.readUnsignedByte();
			if (encrypt == 1)
			{
				TSocket(socket).protect = true;
			}
			log.info("收到验证轮询回复 协议加密:" + encrypt);
			sendAuthSessionkey();
			//开始心跳
			GameClient.HeartStart();
		}

		private static const AUTH_OK:int = 0x0C;
		private static const AUTH_CLIENT_VERSION_ERROR:int = 0x1D;
		private static const AUTH_SERVER_VERSION_ERROR:int = 0x1E;
		private static const AUTH_WALLOW:int = 0X20;

		private function authResponseHandler(socket:ISocket, packet:TPacketIn):void
		{
			var result:uint = packet.readUnsignedByte();
			log.log("收到验证返回{0}", result);
			switch (result)
			{
				case AUTH_OK:
					GameState.LineConnected = true;
					if (GameState.HeroInited)
					{
						sendCharacterSelectRequest(loginModel.selectRole.index, GameConfig.currentCharacter_guid);
					}
					else
					{
						//						GameInstance.ui.loginUI.showRoleSelectPanel();
						loginUISignals.showTipPanel.dispatch(LanguageManager.translate(45006, "正在获取角色列表..."));
						sendCharacterOverview();
					}
					break;
				case AUTH_CLIENT_VERSION_ERROR:
					//					CONFIG::debugging
					//				{
					//					TAlert.Show("客户端版本过低！");
					//				}
					break;
				case AUTH_SERVER_VERSION_ERROR:
					//					CONFIG::debugging
					//				{
					//					TAlert.Show("客户端版本过高！");
					//				}
					break;
				case AUTH_WALLOW:
					MessageManager.instance.addHintById_client(1807, "根据青少年保护法，未满16周岁的青少年凌晨0~6点无法进入游戏");
					break;
			}
		}

		private function characterOverviewHandler(socket:ISocket, packet:TPacketIn):void
		{
			var charArray:Array = [];
			var _offlineTimes:uint = packet.readUnsignedInt();
			var _charCount:int = packet.readUnsignedByte();
			for (var i:int = 0; i != _charCount; i++)
			{
				var _charInfo:RoleInfo = new RoleInfo();
				_charInfo.index = packet.readUnsignedByte();
				_charInfo.name = packet.readUTF();
				packet.readUnsignedByte();
				packet.readUnsignedByte();
//				_charInfo.profession = packet.readUnsignedByte();
//				_charInfo.gender = packet.readUnsignedByte();
				_charInfo.headIcon = packet.readUnsignedByte();
				_charInfo.level = packet.readUnsignedByte();
				_charInfo.mapId = packet.readUnsignedShort();
				_charInfo.dir = packet.readUnsignedShort();
				_charInfo.posX = packet.readUnsignedShort();
				_charInfo.posY = packet.readUnsignedShort();
				_charInfo.state = packet.readUnsignedInt();
				_charInfo.equip = packet.readUnsignedInt();
				charArray.push(_charInfo);
			}
			loginModel.isShowDelBtn = packet.readByte() ? true : false;
			loginModel.initRoles(_offlineTimes, charArray);
			if (loginModel.roleNum > 0)
			{
				GameConfig.selectRole = charArray[0];
				sendCharacterSelectRequest(GameConfig.selectRole.index, 0);
			}
			else
			{
				loginUISignals.showRoleCreatePanel.dispatch();
			}
		}

		private static const CHAR_CREATE_SUCCESS:uint = 0x2F; //创建成功
		private static const CHAR_CREATE_ERROR:uint = 0x30; //服务器创建失败
		private static const CHAR_CREATE_NAME_IN_USE:uint = 0x32; //姓名已被使用
		private static const CHAR_CREATE_SERVER_LIMIT:uint = 0x35; //角色数已达上限
		private static const CHAR_NAME_NO_NAME:uint = 0x59; //姓名为空
		private static const CHAR_NAME_SUCCESS:uint = 0x60; //cxf
		private static const CHAR_NAME_INVALID_CHARACTER:uint = 0x61; //姓名非法
		private static const CHAR_NAME_TOO_LONG:uint = 0x62; //姓名过长
		private static const CHAR_NAME_TOO_SHORT:uint = 0x63; //姓名过短
		private static const CHAR_CREATE_PROFESSIONERROR:uint = 0x68; //职业不对
		private static const CHAR_CREATE_GENDERERROR:uint = 0x69; //性别不对
		private static const CHAR_DELETE_SUCCESS:uint = 0x70; //cxf

		private function characterCreateHandler(socket:ISocket, packet:TPacketIn):void
		{
			var _result:uint = packet.readUnsignedByte();
			switch (_result)
			{
				case CHAR_CREATE_SUCCESS:
					var newRole:RoleInfo = new RoleInfo();
					newRole.index = packet.readUnsignedByte();
					newRole.name = packet.readUTF();
					packet.readUnsignedByte(); //DEBUG
					packet.readUnsignedByte();
//					newRole.profession = packet.readUnsignedByte();
//					newRole.gender = packet.readUnsignedByte();
					newRole.headIcon = packet.readUnsignedByte();
					newRole.level = packet.readUnsignedByte();
					newRole.mapId = packet.readUnsignedShort();
					newRole.dir = packet.readUnsignedShort();
					newRole.posX = packet.readUnsignedShort();
					newRole.posY = packet.readUnsignedShort();
					newRole.state = packet.readUnsignedInt();
					newRole.equip = packet.readUnsignedInt();
					newRole.isNew = true;
					//					GameInstance.ui.loginUI.showRoleSelectPanel();
					loginModel.addRole(newRole);
					GameConfig.selectRole = newRole;
					loginUISignals.showTipPanel.dispatch(LanguageManager.translate(45008, "正在进入游戏..."));
					sendCharacterSelectRequest(newRole.index, 0);
					break;
				case CHAR_CREATE_ERROR:
					loginUISignals.showRoleCreatePanel.dispatch();
					TAlertHelper.showAlert(1701, "创建失败");
					break;
				case CHAR_CREATE_NAME_IN_USE:
					loginUISignals.showRoleCreatePanel.dispatch();
					TAlertHelper.showAlert(1702, "姓名已被使用");
					break;
				case CHAR_CREATE_SERVER_LIMIT:
					loginUISignals.showRoleCreatePanel.dispatch();
					TAlertHelper.showAlert(1703, "角色数已达上限");
					break;
				case CHAR_NAME_NO_NAME:
					loginUISignals.showRoleCreatePanel.dispatch();
					TAlertHelper.showAlert(1704, "姓名为空");
					break;
				case CHAR_NAME_INVALID_CHARACTER:
					loginUISignals.showRoleCreatePanel.dispatch();
					TAlertHelper.showAlert(1705, "姓名非法");
					break;
				case CHAR_NAME_TOO_LONG:
					loginUISignals.showRoleCreatePanel.dispatch();
					TAlertHelper.showAlert(1706, "姓名过长");
					break;
				case CHAR_NAME_TOO_SHORT:
					loginUISignals.showRoleCreatePanel.dispatch();
					TAlertHelper.showAlert(1707, "姓名过短");
					break;
				case CHAR_CREATE_PROFESSIONERROR:
					loginUISignals.showRoleCreatePanel.dispatch();
					TAlertHelper.showAlert(1708, "职业不对");
					break;
				case CHAR_CREATE_GENDERERROR:
					loginUISignals.showRoleCreatePanel.dispatch();
					TAlertHelper.showAlert(1709, "性别不对");
					break;
			}
		}

		private function characterDeleteHandler(socket:ISocket, packet:TPacketIn):void
		{
//			var index:int = packet.readUnsignedByte();
//			loginModel.removeRole(index);
//			//			GameInstance.ui.loginUI.showRoleSelectPanel();
//			if (loginModel.roleNum > 0)
//			{
//				loginUISignals.showRoleSelectPanel.dispatch();
//			}
//			else
//			{
//				loginUISignals.showRoleCreatePanel.dispatch();
//			}
			//			TAlertHelper.ShowAlert(1725, "删除角色成功");
		}

		private function characterSelectHandler(socket:ISocket, packet:TPacketIn):void
		{
			var result:int = packet.readUnsignedByte();
			log.info("接收角色选择返回{0}", result);
			switch (result)
			{
				case 2: //SUCCESS
					GameState.RoleSelected = true;
					if (GameState.HeroInited)
					{
						GameInstance.signal.sceneSignals.reloadScene.dispatch();
					}
					else
					{
						loginSignals.selectRoleSuccess.dispatch();
					}
					break;
			}
		}

		//////////////////////////////////////////////////////登陆服消息/////////////////////////////////////////////////////////////////////////////
		/**
		 * 发送验证登陆询问
		 * @param account
		 */
		public function sendAuthLogonChallenge():void
		{
			var pk:TPacketOut = new TPacketOut(CMD_AUTH_LOGON_CHALLENGE);
			pk.writeUnsignedInt(CustomConfig.instance.user_id);
			pk.writeUnsignedInt(CustomConfig.instance.time);
//			pk.writeByte(CustomConfig.instance.cm);
			pk.writeByte(0); //硬编码屏蔽防沉迷
			pk.writeUnsignedInt(CustomConfig.instance.sid); //服务器编号
			pk.writeLenString(CustomConfig.instance.sign, 40);
			pk.writeLenString(CustomConfig.instance.plat, 128);
			NetManager.sendToLS(pk);
			log.info("发送验证登陆问询");
		}

		/**
		 * 发送查询网关服地址
		 */
		public function sendRequestGateServerAddress():void
		{
			var pk:TPacketOut = new TPacketOut(CMD_REALM_LIST);
			pk.writeShort(0);
			NetManager.sendToLS(pk);
			log.info("发送请求线路列表");
		}

		/**
		 * 二次密码（修改二次密码）
		 * @param kind 二次密码类型
		 * @param pwd 密码
		 * @param newPWD 新密码
		 *
		 */
		public function sendAuthP2(pwd:String):void
		{
			var user_id:int = CustomConfig.instance.user_id;
			var pk:TPacketOut = new TPacketOut(CMD_AUTH_SECPSWD);
			pk.writeByte(SECONDPWD_AUTH);
			//
			var by:TByteArray = new TByteArray();
			by.writeUnsignedInt(p2_key);
			by.writeMultiByte(SHA1.hash(user_id + pwd).toUpperCase(), "gb2312");
			pk.writeLenString(SHA1.hashBytes(by).toUpperCase(), 40);
			//
			pk.writeLenString(SHA1.hash(user_id + "0").toUpperCase(), 40);
			NetManager.sendToLS(pk);
		}

		/**
		 * 修改二次密码
		 * @param pwd 当前密码
		 * @param newPwd 新密码
		 */
		public function sendModifyP2(pwd:String, newPwd:String):void
		{
			var user_id:int = CustomConfig.instance.user_id;
			var pk:TPacketOut = new TPacketOut(CMD_AUTH_SECPSWD);
			pk.writeByte(SECONDPWD_REPAIR);
			//
			var by:TByteArray = new TByteArray();
			by.writeUnsignedInt(p2_key);
			by.writeMultiByte(SHA1.hash(user_id + pwd).toUpperCase(), "gb2312");
			pk.writeLenString(SHA1.hashBytes(by).toUpperCase(), 40);
			//
			pk.writeLenString(SHA1.hash(user_id + newPwd).toUpperCase(), 40);
			NetManager.sendToLS(pk);
		}

		/**
		 * 创建二次密码
		 * @param pwd
		 */
		public function sendCreateP2(pwd:String):void
		{
			var user_id:int = CustomConfig.instance.user_id;
			var pk:TPacketOut = new TPacketOut(CMD_AUTH_SECPSWD);
			pk.writeByte(SECONDPWD_INPUT);
			//
			pk.writeLenString(SHA1.hash(user_id + pwd).toUpperCase(), 40);
			//
			pk.writeLenString(SHA1.hash(user_id + "0").toUpperCase(), 40);
			NetManager.sendToLS(pk);
		}

		/**
		 * 发送验证SessionKey
		 */
		public function sendAuthSessionkey():void
		{
			var _packet:TPacketOut = new TPacketOut(CMSG_AUTH_SESSION);
			_packet.writeUnsignedInt(CustomConfig.instance.sid);
			_packet.writeUnsignedInt(CustomConfig.instance.user_id);
			_packet.writeLenString(GameConfig.sessionKey, 40);
			GameClient.socket.send(_packet);
			log.info("发送验证Session");
		}

		public function sendCharacterOverview():void
		{
			var _packet:TPacketOut = new TPacketOut(CMSG_CHAR_ENUM);
			GameClient.socket.send(_packet);
			log.info("发送请求角色列表");
		}

		/**
		 * 发送角色创建请求
		 * @param name 角色名
		 * @param profession 角色职业
		 * @param gender 性别
		 * @param headIcon 头像
		 */
		public function sendCharacterCreateRequest(name:String, cardId:int):void
		{
			var packet:TPacketOut = new TPacketOut(CMSG_CHAR_CREATE);
			packet.writeUTF(name);
			packet.writeInt(cardId);
			GameClient.socket.send(packet);
			log.info("发送创建角色 name:{0} cardId:{1}", name, cardId);
		}

		/**
		 * 角色删除请求
		 * @param index
		 */
		public function sendCharacterDeleteRequest(index:int):void
		{
			var packet:TPacketOut = new TPacketOut(CMSG_CHAR_DELETE);
			packet.writeByte(index);
			GameClient.socket.send(packet);
			log.info("发送角色删除 index:{0}", index);
		}

		/**
		 * 发送角色选择请求
		 * @param index
		 */
		public function sendCharacterSelectRequest(index:int, guid:int):void
		{
			var packet:TPacketOut = new TPacketOut(CMSG_PLAYER_LOGIN);
			packet.writeByte(index);
			packet.writeUnsignedInt(guid);
			GameClient.socket.send(packet);
			log.info("发送角色选择 index:{0} guid:{1}", index, guid);
		}
	}
}
