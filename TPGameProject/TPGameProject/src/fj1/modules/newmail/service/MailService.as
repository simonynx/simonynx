package fj1.modules.newmail.service
{
	import fj1.common.data.dataobject.items.ItemData;
	import fj1.common.data.factories.ItemDataFactory;
	import fj1.common.helper.TAlertHelper;
	import fj1.common.net.ChatClient;
	import fj1.common.net.GameClient;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.ui.TWindowManager;
	import fj1.manager.DirtyWordManager;
	import fj1.manager.MessageManager;
	import fj1.modules.newmail.model.MailModel;
	import fj1.modules.newmail.model.vo.MailInfo;
	import fj1.modules.newmail.signals.MailSignal;
	import fj1.modules.newmail.view.components.MailInfoPanel;
	import tempest.common.mvc.base.Actor;
	import tempest.common.net.vo.TPacketIn;
	import tempest.common.net.vo.TPacketOut;
	import tempest.core.ISocket;

	public class MailService extends Actor
	{
		[Inject]
		public var model:MailModel;
		[Inject]
		public var signal:MailSignal;
		//中心服
		public static const CMSG_QUERY_MAIL:uint = 0x023; //查询所有邮件
		public static const SMSG_SEND_ALL_MAIL:uint = 0x020; //下发玩家所有邮件
		public static const CMSG_QUERY_MAIL_DETAIL:uint = 0x021; //请求查询某邮件详细内容
		public static const SMSG_SEND_MAIL_DETAIL:uint = 0x022; //下发某邮件详细内容
		public static const SMSG_MAIL_HAVEUNREAD:uint = 0x025; //有新邮件
		public static const CMSG_MAIL_DELETE:uint = 0x026; //删除邮件
		public static const CMSG_MAIL_PICKETAffix:uint = 0x027; //收取附件
		//游戏服
		public static const CMSG_WRITE_MAIL:uint = 0x0DE; //写邮件

		public function MailService()
		{
			super();
		}

		override public function init():void
		{
			ChatClient.socket.mapOpcodes([SMSG_SEND_ALL_MAIL], mailOpenListHandler); //下发邮件列表
			ChatClient.socket.mapOpcodes([SMSG_SEND_MAIL_DETAIL], mailInfoHandler); //下发某邮件详细内容
			ChatClient.socket.mapOpcodes([SMSG_MAIL_HAVEUNREAD], mailNewHandler); //有新邮件
			ChatClient.socket.mapOpcodes([CMSG_MAIL_PICKETAffix], mailAffixHandler); //收取附件的结果
		}

		/**
		 * 发送邮件
		 * @param addressee 收件人
		 * @param title 标题
		 * @param content 内容
		 * @param money 金钱
		 * @param itemGuidArr 附件guid数组
		 *
		 */
		public function sendMail(addressee:String, title:String, content:String, money:int, itemGuidArr:Array):void
		{
			var packet:TPacketOut = new TPacketOut(CMSG_WRITE_MAIL);
			packet.writeUTF(addressee);
			packet.writeUTF(title);
			packet.writeUTF(content);
			packet.writeUnsignedInt(money);
			for (var i:int = 0; i < itemGuidArr.length; i++)
			{
				packet.writeUnsignedInt(itemGuidArr[i]);
			}
			GameClient.socket.send(packet);
		}

		/**
		 * 服务端根据条件查询下发相应的邮件
		 * @param condition 如果是0查询所有，如果是guid查询这条邮件的信息
		 *
		 */
		public function sendRequestAllMail(condition:int):void
		{
			var packet:TPacketOut = new TPacketOut(CMSG_QUERY_MAIL);
			packet.writeInt(condition);
			ChatClient.socket.send(packet);
		}

		/**
		 * 下发邮件列表
		 * @param socket
		 * @param packet
		 *
		 */
		public function mailOpenListHandler(socket:ISocket, packet:TPacketIn):void
		{
			var mailNum:int = packet.readUnsignedByte(); //数量
			if (mailNum == 0)
				return;
			for (var i:int = 0; i < mailNum; i++)
			{
				var mailInfo:MailInfo = new MailInfo();
				mailInfo.guid = packet.readUnsignedInt(); //guid
				mailInfo.kind = packet.readUnsignedInt(); //类型
				mailInfo.sendTime = packet.readUTF(); //发送时间
				mailInfo.senderName = packet.readUTF(); //发件人名字
				mailInfo.title = DirtyWordManager.replaceDirtyWord(packet.readUTF()); //邮件标题
				mailInfo.ownTime = packet.readUnsignedByte(); //剩余时间
				mailInfo.readState = packet.readUnsignedByte(); //是否已读
				var iconKind:int; //邮件图标类型
				var isHaveMoney:int = packet.readUnsignedByte(); //是否有金钱
				var isHaveItem:int = packet.readUnsignedByte(); //是否有物品
				if (isHaveItem == 1)
				{
					iconKind = MailInfo.MAIL_ICON_ITEM;
				}
				else
				{
					if (isHaveMoney == 1)
						iconKind = MailInfo.MAIL_ICON_MONEY;
					else
						iconKind = MailInfo.MAIL_ICON_TEXT;
				}
				mailInfo.mailIcon = iconKind;
				switch (mailInfo.kind)
				{
					case MailInfo.MAIL_PERSONAL:
						break;
					case MailInfo.MAIL_SYSTEM:
						mailInfo.senderName = LanguageManager.translate(10003, "系统邮件");
						break;
					case MailInfo.MAIL_SALE_BUY:
						mailInfo.senderName = LanguageManager.translate(10003, "系统邮件");
						mailInfo.title = LanguageManager.translate(10004, "拍卖行（购买）");
						break;
					case MailInfo.MAIL_SALE_FAIL:
						mailInfo.senderName = LanguageManager.translate(10003, "系统邮件");
						mailInfo.title = LanguageManager.translate(10005, "拍卖行（出售失败）");
						break;
					case MailInfo.MAIL_SALE_SUCCESS:
						mailInfo.senderName = LanguageManager.translate(10003, "系统邮件");
						mailInfo.title = LanguageManager.translate(10006, "拍卖行（出售成功）");
						break;
					case MailInfo.MAIL_GUILD:
						mailInfo.senderName = LanguageManager.translate(10003, "系统邮件");
						mailInfo.title = LanguageManager.translate(10026, "解散公会");
						break;
					case MailInfo.MAIL_GUILD_WAR:
						mailInfo.senderName = LanguageManager.translate(10003, "系统邮件");
						mailInfo.title = LanguageManager.translate(1529, "神殿战");
						break;
					case MailInfo.MAIL_TEAM:
						mailInfo.senderName = LanguageManager.translate(10003, "系统邮件");
						mailInfo.title = LanguageManager.translate(1530, "遗失的物品");
						break;
					case MailInfo.MAIL_TOWER:
						mailInfo.senderName = LanguageManager.translate(10003, "系统邮件");
						mailInfo.title = LanguageManager.translate(10033, "试炼塔奖励");
						break;
					case MailInfo.MAIL_MARKET:
						mailInfo.senderName = LanguageManager.translate(10003, "系统邮件");
						mailInfo.title = LanguageManager.translate(10032, "信仰力交易所邮件");
						break;
					case MailInfo.MAIL_MARKET_SELL:
						mailInfo.senderName = LanguageManager.translate(10003, "系统邮件");
						mailInfo.title = LanguageManager.translate(10032, "信仰力交易所邮件");
						break;
					case MailInfo.MAIL_MARKET_BACK:
						mailInfo.senderName = LanguageManager.translate(10003, "系统邮件");
						mailInfo.title = LanguageManager.translate(10032, "信仰力交易所邮件");
						break;
					case MailInfo.MAIL_EXPLORATION_POINT:
						mailInfo.senderName = LanguageManager.translate(10003, "系统邮件");
						mailInfo.title = LanguageManager.translate(1035, "鋤草奪寶獎勵");
						break;
					case MailInfo.MAIL_EXPLORATION_RANK:
						mailInfo.senderName = LanguageManager.translate(10003, "系统邮件");
						mailInfo.title = LanguageManager.translate(1036, "鋤草奪寶排名獎勵");
						break;
					case MailInfo.MAIL_EXPLORATION_PRIZE:
						mailInfo.senderName = LanguageManager.translate(10003, "系统邮件");
						mailInfo.title = LanguageManager.translate(1037, "鋤草奪寶寶箱獎勵");
						break;
					case MailInfo.MAIL_WATCHSTAR:
						mailInfo.senderName = LanguageManager.translate(10003, "系统邮件");
						mailInfo.title = LanguageManager.translate(1079, "占星獎勵");
						break;
					case MailInfo.MailSort_ShenMoHort:
						mailInfo.senderName = LanguageManager.translate(10003, "系统邮件");
						mailInfo.title = LanguageManager.translate(81132, "神魔戰場獎勵");
						break;
					case MailInfo.MAIL_SHENMOTOUPIAO:
						mailInfo.senderName = LanguageManager.translate(10003, "系统邮件");
						mailInfo.title = LanguageManager.translate(100515, "竞猜奖励发放");
						break;
					case MailInfo.MAIL_PK_TAOTAISAI:
						mailInfo.senderName = LanguageManager.translate(10003, "系统邮件");
						mailInfo.title = LanguageManager.translate(1107, "PK赛奖励");
						break;
					case MailInfo.MAIL_PK_JUESAI:
						mailInfo.senderName = LanguageManager.translate(10003, "系统邮件");
						mailInfo.title = LanguageManager.translate(1107, "PK赛奖励");
						break;
				}
				model.mailListArr.addItem(mailInfo);
			}
			model.sortMail();
			signal.mailDataComplete.dispatch();
		}

		/**
		 * 发送查询某条邮件的详细信息
		 * @param guid 要查询的邮件的id
		 *
		 */
		public function sendRequestMailInfo(guid:int):void
		{
			var packet:TPacketOut = new TPacketOut(CMSG_QUERY_MAIL_DETAIL);
			packet.writeInt(guid);
			ChatClient.socket.send(packet);
		}

		/**
		 * 下发某邮件详细内容
		 * @param socket
		 * @param packet
		 *
		 */
		public function mailInfoHandler(socket:ISocket, packet:TPacketIn):void
		{
			var mailInfo:MailInfo = model.getMailInfoByID(model.guid);
			mailInfo.sendContent = packet.readUTF(); //发送内容
			var isCollect:int = packet.readByte(); //0未收取1已收取
			var money:int = packet.readUnsignedInt(); //发送的金钱
			var mojin:int = packet.readUnsignedInt(); //发送的魔金
			var stone:int = packet.readUnsignedInt(); //发送的魔石
			var itemNum:int = packet.readUnsignedByte(); //附件个数
			var myArr:Array = [];
			for (var i:int = 0; i < itemNum; i++)
			{
				var arr:Array = [];
				var item_guid:int = packet.readUnsignedInt(); //物品ID
				var item_template_id:int = packet.readUnsignedInt(); //物品模版ID
				var item_num:int = packet.readUnsignedInt(); //物品数量
				arr.push(item_guid, item_template_id, item_num);
				myArr.push(arr);
			}
			//判断邮件类型
			if (mailInfo.kind != MailInfo.MAIL_SYSTEM && mailInfo.kind != MailInfo.MAIL_SALE_BUY && mailInfo.kind != MailInfo.MAIL_SALE_FAIL && mailInfo.kind != MailInfo.MAIL_SALE_SUCCESS && mailInfo.
				kind != MailInfo.MAIL_MAGICWARD)
				mailInfo.sendContent = DirtyWordManager.replaceDirtyWord(mailInfo.sendContent);
			else
				mailInfo.sendContent = mailInfo.sendContent;
			//邮件是否已经收取
			if (isCollect == 0)
			{
				mailInfo.sendMoney = money;
				mailInfo.sendMoJin = mojin;
				mailInfo.sendStone = stone;
				mailInfo.itemArr = myArr;
			}
			else
			{
				mailInfo.itemArr = [];
			}
			var itemData:ItemData;
			switch (mailInfo.kind)
			{
				case MailInfo.MAIL_SALE_BUY:
					itemData = getItemData(arr);
					mailInfo.sendContent = LanguageManager.translate(10000, "您购买{0}个{1}成功，请及时收取物品", itemData.num, itemData.name);
					break;
				case MailInfo.MAIL_SALE_FAIL:
					itemData = getItemData(arr);
					mailInfo.sendContent = LanguageManager.translate(10001, "您出售的{0}已到期，请及时收取。", itemData.name);
					break;
				case MailInfo.MAIL_SALE_SUCCESS:
					var str:String;
					if (money != 0)
					{
						str = money + LanguageManager.translate(100002, "金币");
					}
					if (mojin != 0)
					{
						str = mojin + LanguageManager.translate(100003, "魔晶");
					}
					mailInfo.sendContent = LanguageManager.translate(10002, "您的寄售的物品已经成功出售，获得{0}请及时收取。", str);
					break;
				case MailInfo.MAIL_GUILD:
					mailInfo.sendContent = LanguageManager.translate(10027, "你所在的公会已经解散");
					break;
				case MailInfo.MAIL_TEAM:
					mailInfo.sendContent = LanguageManager.translate(1531, "组队中遗失的战利品");
					break;
				case MailInfo.MAIL_GUILD_WAR:
					mailInfo.sendContent = LanguageManager.translate(10030, "神殿战报名成功，每周三周六晚可加入神殿战争夺，神殿站淘汰赛时间 19:30-20:00 \n神殿站决赛时间 20：00-20：45");
					break;
				case MailInfo.MAIL_TOWER:
					itemData = getItemData(arr);
					mailInfo.sendContent = LanguageManager.translate(10031, "恭喜你获得{0}奖励", itemData.name);
					break;
				case MailInfo.MAIL_EXPLORATION_POINT:
					mailInfo.sendContent = LanguageManager.translate(1038, "在本次鋤草奪寶中你獲得以下獎勵。請及時收取。");
					break;
				case MailInfo.MAIL_EXPLORATION_RANK:
					mailInfo.sendContent = LanguageManager.translate(1039, "在本次鋤草奪寶中你獲得以下獎勵。請及時收取。");
					break;
				case MailInfo.MAIL_EXPLORATION_PRIZE:
					mailInfo.sendContent = LanguageManager.translate(1040, "在本次鋤草奪寶中，你從找到的寶箱中獲得了以下獎勵。請及時收取。");
					break;
				case MailInfo.MAIL_WATCHSTAR:
					mailInfo.sendContent = LanguageManager.translate(1078, "本次占星您獲得了以下獎勵，請及時收取。");
					break;
				case MailInfo.MailSort_ShenMoHort:
					mailInfo.sendContent = LanguageManager.translate(81131, "本次參加神魔戰場您獲得了以下獎勵，請及時收取。");
					break;
				case MailInfo.MailSort_ZaGuanZi:
					mailInfo.sendContent = LanguageManager.translate(1088, "本次參加砸罐子您獲得了以下獎勵，請及時收取。");
					break;
				case MailInfo.MAIL_SHENMOTOUPIAO:
					mailInfo.sendContent = LanguageManager.translate(100516, "本次神魔大战中，你支持的阵营获得了胜利！获得以下奖励，请及时收取。");
					break;
				case MailInfo.MAIL_PK_TAOTAISAI:
					mailInfo.sendContent = LanguageManager.translate(1108, "恭喜你，在【GOD】PK赛中，取得战果，获得丰厚奖励");
					break;
				case MailInfo.MAIL_PK_JUESAI:
					mailInfo.sendContent = LanguageManager.translate(1108, "恭喜你，在【GOD】PK赛中，取得战果，获得丰厚奖励");
					break;
			}
			TWindowManager.instance.showPopup2(null, MailInfoPanel.NAME);
			signal.updateMailContent.dispatch(mailInfo);
		}

		private function getItemData(itemArr:Array):ItemData
		{
			var itemData:ItemData = ItemDataFactory.createByID(0, itemArr[0], itemArr[1], null, itemArr[2]);
			return itemData;
		}

		/**
		 * 有新邮件
		 * @param socket
		 * @param packet
		 *
		 */
		public function mailNewHandler(socket:ISocket, packet:TPacketIn):void
		{
			var guid:int = packet.readUnsignedInt(); //guid
			MessageManager.instance.addHintById_client(2057, "你有新邮件，请查收");
			if (guid != 0)
			{
				if (model.mailListArr.length < 50)
				{
					model.guidArr.push(guid);
				}
				else
				{
					TAlertHelper.showAlert(2065, "你的邮箱已满，请处理邮件，避免查收不到新邮件");
				}
			}
			signal.changeMailIcon.dispatch();
		}

		/**
		 *  删除邮件
		 * @param arr 要删除邮件的数组 里面包含邮件的guid
		 *
		 */
		public function mailDelete(arr:Array):void
		{
			var packet:TPacketOut = new TPacketOut(CMSG_MAIL_DELETE);
			packet.writeByte(arr.length);
			for (var i:int = 0; i < arr.length; i++)
			{
				packet.writeInt(arr[i]);
			}
			ChatClient.socket.send(packet);
		}

		/**
		 *  收取附件
		 * @param guid 邮件的guid
		 *
		 */
		public function getMailAffix(guid:int):void
		{
			var packet:TPacketOut = new TPacketOut(CMSG_MAIL_PICKETAffix);
			packet.writeInt(guid);
			ChatClient.socket.send(packet);
		}

		/**
		 * 收取附件的结果
		 * @param socket
		 * @param packet
		 *
		 */
		public function mailAffixHandler(socket:ISocket, packet:TPacketIn):void
		{
			var mailGuid:int = packet.readUnsignedInt();
			var isOK:int = packet.readUnsignedByte();
			if (isOK == 1)
			{
				var mailInfo:MailInfo = model.getAndChangeMailState(mailGuid);
				model.delAffixAndMoneyData(mailInfo);
				MessageManager.instance.addHintById_client(2058, "成功提取附件");
			}
		}
	}
}
