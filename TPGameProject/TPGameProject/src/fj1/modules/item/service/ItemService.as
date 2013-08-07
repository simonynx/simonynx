package fj1.modules.item.service
{
	import fj1.common.GameInstance;
	import fj1.common.data.dataobject.HeroDepot;
	import fj1.common.data.dataobject.items.ItemData;
	import fj1.common.helper.ObjectCreateHelper;
	import fj1.common.data.factories.ItemDataFactory;
	import fj1.common.data.interfaces.ISlotItem;
	import fj1.common.helper.UpdatePropsHelper;
	import fj1.common.net.GameClient;
	import fj1.common.net.tcpLoader.base.TCPLoader;
	import fj1.common.net.tcpLoader.base.TCPLoaderGroup;
	import fj1.common.net.tcpLoader.base.TCPLoaderManager;
	import fj1.common.res.guide.GuideResManager;
	import fj1.common.res.guide.vo.GuideConfig;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.staticdata.ItemConst;
	import fj1.common.staticdata.ItemSpecailConst;
	import fj1.common.staticdata.ObjectUpdateConst;
	import fj1.common.ui.TWindowManager;
	import fj1.common.vo.character.Hero;
	import fj1.manager.MessageManager;
	import fj1.manager.SlotItemManager;
	import fj1.modules.item.signals.ItemSignal;

	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.common.mvc.base.Actor;
	import tempest.common.net.vo.TPacketIn;
	import tempest.common.net.vo.TPacketOut;
	import tempest.core.ISocket;
	import tempest.engine.SceneCharacter;
	import tempest.ui.events.InputDialogEvent;

	public class ItemService extends Actor
	{
		private static var log:ILogger = TLog.getLogger(ItemService);
		[Inject]
		public var signal:ItemSignal;
		/*******************物品装备指令******************/
		/***********游戏服*************/
		public static const SMSG_UPDATE_ITEM:uint = 0x014; //更新对象压缩数据
		public static const MSG_USE_ITEM:uint = 0x016; //使用物品
		public static const CMSG_EQUIP_ITEM:uint = 0x032; //装备一物品
		public static const CMSG_UNEQUIP_POS:uint = 0x034; //卸载一装备位上的装备
		public static const CMSG_MOVEPOS_ITEM:uint = 0x036; //物品移动位置
		public static const MSG_DROP_ITEM:uint = 0x038; //丢弃物品
		public static const MSG_SPLIT_ITEM:uint = 0x039; //拆分物品
		public static const SMSG_DEL_ITEM:uint = 0x089; //删除物品
		public static const MSG_BACKPACK_SYN:int = 0x132; //背包数据刷新
		public static const CMSG_ITEM_BATCHUSE:int = 0x181; //物品批量使用
		/**********************仓库操作指令*******************/
		public static const MSG_OPEN_DEPOT:uint = 0x091; //打开仓库
		public static const MSG_MODIFY_DEPOT_PWD:uint = 0x092; //修改仓库密码
		public static const CMSG_DEPOT_ADDMONEY:uint = 0x093; //仓库放入金钱
		public static const CMSG_DEPOT_REMOVEMONEY:uint = 0x094; //仓库取出金钱
		public static const SMSG_DEPOT_UPDATE:uint = 0x098; //仓库更新
		public static const SMSG_DEPOT_EXPAND:uint = 0x096; //仓库扩容
		public static const SMSG_DEPOT_ALREADY_CREATE:uint = 0x097; //已经有仓库初始化

		/***********中心服*************/
		public function ItemService()
		{
			super();
		}

		public override function init():void
		{
			GameClient.socket.mapOpcodes([SMSG_UPDATE_ITEM], itemUpdateHandler);
			GameClient.socket.mapOpcodes([MSG_USE_ITEM], itemUseHandler); /*物品使用*/
			GameClient.socket.mapOpcodes([MSG_SPLIT_ITEM], itemSplictHandler); /*装备拆分*/
			GameClient.socket.mapOpcodes([SMSG_DEL_ITEM], itemRemoveHandler); /*物品移除*/
			GameClient.socket.mapOpcodes([MSG_OPEN_DEPOT], depotOpenHandler); /*打开仓库*/
			GameClient.socket.mapOpcodes([MSG_MODIFY_DEPOT_PWD], depotPwdModifyHandler); /*修改密码*/
			GameClient.socket.mapOpcodes([SMSG_DEPOT_UPDATE], depotUpdate); /*更新仓库*/
			GameClient.socket.mapOpcodes([SMSG_DEPOT_EXPAND], depotExpend); /*仓库扩容*/
			GameClient.socket.mapOpcodes([SMSG_DEPOT_ALREADY_CREATE], depotInitCreateHandler); /*已经有仓库初始化*/
		}

		/****************************************物品操作*****************************************************/
		public function itemRemoveHandler(socket:ISocket, packet:TPacketIn):void
		{
			var guid:uint = packet.readUnsignedInt();
			SlotItemManager.instance.setItem(guid, null);
			signal.removeItemByGuid.dispatch(guid);
		}

		/**
		 * 更新对象压缩数据
		 * @param socket
		 * @param packet
		 *
		 */
		public function itemUpdateHandler(socket:ISocket, packet:TPacketIn):void
		{
			while (packet.bytesAvailable)
			{
				var updateData:Object = UpdatePropsHelper.parsePropPacket(packet); //{type: updateType, guid: guid, props: props, templateId: templateId};
				var item:ISlotItem;
				//更新类型分支
				switch (updateData.type) //对象更新类型
				{
					case ObjectUpdateConst.UPDATETYPE_VALUES: //更新属性
						item = ISlotItem(SlotItemManager.instance.getItem(updateData.guid));
						ObjectCreateHelper.updateObj(item, updateData.props, true);
						break;
					case ObjectUpdateConst.UPDATETYPE_CREATE_OBJECT: //创建对象
						item = ISlotItem(ItemDataFactory.create(GameInstance.mainChar.id, updateData.guid, updateData.props, true, packet, true));
						SlotItemManager.instance.Add(item);
						break;
				}
			}
		}

		public function sendItemUse(guId:uint, pos:int):void
		{
			var packet:TPacketOut = new TPacketOut(MSG_USE_ITEM);
			packet.writeUnsignedInt(guId);
			packet.writeByte(pos);
			GameClient.socket.send(packet);
			log.info("发送物品使用 id:{0} pos:{1}", guId, pos);
		}

		public function itemUseHandler(socket:ISocket, packet:TPacketIn):void
		{
			var guid:uint = packet.readUnsignedInt();
			var item:ItemData = SlotItemManager.instance.getItem(guid) as ItemData;
			if (!item)
				return;
			item.startCD();
			signal.itemUsed.dispatch(item);
//			if (item.templateId == ItemSpecailConst.ITEM_TEMPLATE_TIANSHEN)
//			{
//				//使用天神优惠券后弹窗
//				TWindowManager.instance.showPopup2(null, MallPanel.NAME, false, false, TWindowManager.MODEL_USE_OLD, null, null, MallConst.TAB_INDEX_TIANSHEN);
//			}
//			var hero:Hero = GameInstance.mainCharData;
//			if (item.type == ItemConst.TYPE_VIP && !hero.getStatus(StatusConst.STATUS_ID_VIP) && hero.level <= 10)
//			{
//				//使用VIP卡后弹窗
//				var guideConfig:GuideConfig = GuideResManager.getStageConfig(0, 0, 176);
//				if (guideConfig)
//				{
//					GuideViewManager.showImageWindow(guideConfig, function():void
//					{
//						var guideConfig:GuideConfig = GuideManager.currentStepConfig;
//						if (guideConfig)
//						{
//							var taskData:TaskData = GameInstance.model.task.getTaskData(guideConfig.taskId);
//							TaskHelper.continueTask(taskData);
//						}
//					});
//				}
//			}
		}

		/**
		 *使用多个物品
		 * @param guId
		 * @param num
		 *
		 */
		public function sendMutiUse(guId:int, num:int):void
		{
			var packet:TPacketOut = new TPacketOut(CMSG_ITEM_BATCHUSE);
			packet.writeUnsignedInt(guId);
			packet.writeUnsignedInt(num);
			GameClient.socket.send(packet);
			log.info("批量使用物品 id:{0} num:{1}", guId, num);
		}

		public function sendItemMove(guId:uint, oldSlot:uint, newSlot:uint):void
		{
			var packet:TPacketOut = new TPacketOut(CMSG_MOVEPOS_ITEM);
			packet.writeUnsignedInt(guId);
			packet.writeUnsignedInt(oldSlot);
			packet.writeUnsignedInt(newSlot);
			GameClient.socket.send(packet);
			log.info("发送物品移动 id:{0} oldPos:{1} newPos:{2}", guId, oldSlot, newSlot);
		}

		public function sendItemSplit(guId:uint, slot:int, newSlot:int, splitNum:int):void
		{
			var packet:TPacketOut = new TPacketOut(MSG_SPLIT_ITEM);
			packet.writeUnsignedInt(guId);
			packet.writeByte(slot);
			packet.writeShort(splitNum);
			GameClient.socket.send(packet);
			log.info("发送物品拆分 id:{0} pos:{1} newPos:{2} num:{3}", guId, slot, newSlot, splitNum);
		}
		private const SPLIT_ITEM_FAILD:int = 0; //失败
		private const SPLIT_ITEM_SUCCESS:int = 1; //成功

		public function itemSplictHandler(socket:ISocket, packet:TPacketIn):void
		{
			var success:int = packet.readByte();
			if (success == SPLIT_ITEM_SUCCESS)
				MessageManager.instance.addHintById_client(10, "拆分成功"); //拆分成功
			else
				MessageManager.instance.addHintById_client(11, "拆分失败"); //拆分失败
		}

		public function sendDropItem(guId:uint, slot:int):void
		{
			var packet:TPacketOut = new TPacketOut(MSG_DROP_ITEM);
			packet.writeUnsignedInt(guId);
			packet.writeByte(slot);
			GameClient.socket.send(packet);
			log.info("发送丢弃物品 id:{0} pos:{1}", guId, slot);
		}

		public function sendEquip(guId:uint, slot:int):void
		{
			var packet:TPacketOut = new TPacketOut(CMSG_EQUIP_ITEM);
			packet.writeUnsignedInt(guId);
			packet.writeByte(slot);
			GameClient.socket.send(packet);
			log.info("发送穿装备 id:{0} pos:{1}", guId, slot);
		}

		public function sendUnEquip(guId:uint, slot:int, targetSlot:int):void
		{
			var packet:TPacketOut = new TPacketOut(CMSG_UNEQUIP_POS);
			packet.writeUnsignedInt(guId);
			packet.writeByte(slot);
			packet.writeByte(targetSlot);
			GameClient.socket.send(packet);
			log.info("发送脱装备 id:{0} pos:{1} slot:{2}", guId, slot, targetSlot);
		}

		/**************************************仓库操作函数****************************************************/
		/**
		 * 打开仓库
		 * @param npcId
		 * @param pwd
		 *
		 */
		public function sendDepotOpen(npcId:int):void
		{
			var packet:TPacketOut = new TPacketOut(MSG_OPEN_DEPOT);
			packet.writeUnsignedInt(npcId);
			GameClient.socket.send(packet);
			log.info("发送请求打开仓库 npcId:{0}", npcId);
		}
		private static const SUCCESS:int = 1;
		private static const NEED_PWD:int = 2;
		private static const PWD_ERROR:int = 3;
		private static const FAIL:int = 0;

		public function depotOpenHandler(socket:ISocket, packet:TPacketIn):void
		{
			var npcId:int = packet.readUnsignedInt();
			var type:int = packet.readUnsignedByte();
			switch (type)
			{
				case SUCCESS:
					var heroDepot:HeroDepot = HeroDepot.instance;
					heroDepot.money = packet.readUnsignedInt();
					heroDepot.magicCristal = packet.readUnsignedInt();
					//获取NPC
					var npc:SceneCharacter = GameInstance.scene.getCharacterById(npcId);
					signal.showHeroBag.dispatch(TWindowManager.MODEL_USE_OLD, true);
					signal.showHeroDepot.dispatch(npc, true);
					break;
				case NEED_PWD:
//					var npc2:SceneCharacter = GameInstance.scene.getCharacterById(npcId);
//					var dialog:TInputDialog = TInputDialog.Show(null, LanguageManager.translate(2038, "请输入仓库密码："), "输入密码", true, TInputDialog.OK | TInputDialog.CANCEL, onDepotOpenEnsult);
//					dialog.textInput.passwordModel(6);
//					dialog.textInput.restrict = RegexUtil.Number;
//					dialog.data = npc2;
//					HeroDepot.instance.hasPwd = true;
					break;
				case PWD_ERROR:
					MessageManager.instance.addHintById_client(10003, "密码错误"); //密码错误
					break;
				case FAIL:
					MessageManager.instance.addHintById_client(12, "打开仓库失败"); //打开仓库失败
					break;
			}
		}

		/**
		 * 确定打开仓库
		 * @param event
		 *
		 */
//		private function onDepotOpenEnsult(event:InputDialogEvent):void
//		{
//			switch (event.flag)
//			{
//				case TInputDialog.OK:
//					GameClient.sendDepotOpen(SceneCharacter(TInputDialog(event.currentTarget).data).id);
//					break;
//				case TInputDialog.CANCEL:
//					break;
//			}
//		}
		/**
		 *  修改仓库密码
		 * @param pwdOld
		 * @param pwdNew
		 *
		 */
		public function sendDepotPwdModify(pwdOld:String, pwdNew:String):void
		{
			var packet:TPacketOut = new TPacketOut(MSG_MODIFY_DEPOT_PWD);
			packet.writeUTF(pwdOld);
			packet.writeUTF(pwdNew);
			GameClient.socket.send(packet);
		}

		public function depotPwdModifyHandler(socket:ISocket, packet:TPacketIn):void
		{
			var type:int = packet.readByte();
			switch (type)
			{
				case 2:
					HeroDepot.instance.hasPwd = true;
					MessageManager.instance.addHintById_client(10002, "密码修改成功"); //密码修改成功
//					GameInstance.ui.heroDepotPanel._btn_pwd.text = LanguageManager.translate(2040, "修改密码");
					break;
				case 1:
					HeroDepot.instance.hasPwd = false;
					MessageManager.instance.addHintById_client(10002, "密码修改成功"); //密码修改成功
					break;
				case 0:
					MessageManager.instance.addHintById_client(10007, "密码修改失败"); //密码修改失败
					break;
			}
		}

		/**
		 * 存钱
		 * @param moneyAdd
		 *
		 */
		public function sendDepotMoneySave(moneyAdd:int, magicCristalAdd:int):void
		{
			var packet:TPacketOut = new TPacketOut(CMSG_DEPOT_ADDMONEY);
			packet.writeUnsignedInt(moneyAdd);
			packet.writeUnsignedInt(magicCristalAdd);
			GameClient.socket.send(packet);
		}

		/**
		 * 取钱
		 * @param moneyGet
		 *
		 */
		public function sendDepotMoneyGet(moneyGet:int, magicCristalGet:int):void
		{
			var packet:TPacketOut = new TPacketOut(CMSG_DEPOT_REMOVEMONEY);
			packet.writeUnsignedInt(moneyGet);
			packet.writeUnsignedInt(magicCristalGet);
			GameClient.socket.send(packet);
		}

		/**
		 * 更新仓库
		 * @param socket
		 * @param packet
		 *
		 */
		public function depotUpdate(socket:ISocket, packet:TPacketIn):void
		{
			var money:int = packet.readUnsignedInt();
			var magicCristal:int = packet.readUnsignedInt();
			HeroDepot.instance.money = money;
			HeroDepot.instance.magicCristal = magicCristal;
		}

		/**
		 * 仓库扩容
		 * @param socket
		 * @param packet
		 *
		 */
		public function depotExpend(socket:ISocket, packet:TPacketIn):void
		{
			var size:int = packet.readUnsignedByte();
			SlotItemManager.instance.resetSize(ItemConst.CONTAINER_DEPOT, size);
		}

		/**
		 * 已经有仓库初始化
		 * @param socket
		 * @param packet
		 *
		 */
		public function depotInitCreateHandler(socket:ISocket, packet:TPacketIn):void
		{
			var size:int = packet.readUnsignedInt();
			SlotItemManager.instance.resetSize(ItemConst.CONTAINER_DEPOT, size);
		}
	}
}
