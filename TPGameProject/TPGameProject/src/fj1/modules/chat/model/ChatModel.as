package fj1.modules.chat.model
{
	import assets.ResLib;
	import fj1.common.GameConfig;
	import fj1.common.data.factories.ItemDataFactory;
	import fj1.common.data.interfaces.IChatHistoryHolder;
	import fj1.common.helper.MenuHelper;
	import fj1.common.net.tcpLoader.ItemLoader;
	import fj1.common.net.tcpLoader.base.TCPLoader;
	import fj1.common.res.ResManagerHelper;
	import fj1.common.res.chat.ChatSmileyConfigManager;
	import fj1.common.res.chat.vo.SmileyInfo;
	import fj1.common.staticdata.ChatConst;
	import fj1.common.staticdata.MenuOperationType;
	import fj1.common.ui.LoaderTipWindow;
	import fj1.common.ui.MenuDataItem;
	import fj1.common.ui.WindowGroup;
	import fj1.common.ui.tips.LoaderTip;
	import fj1.manager.MessageManager;
	import fj1.modules.chat.model.interfaces.IChatLinkAdapter;
	import fj1.modules.chat.model.vo.ChatData;
	import fj1.modules.chat.service.ChatService;
	import fj1.modules.chat.singles.ChatSignal;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.utils.Dictionary;
	import tempest.common.rsl.TRslManager;
	import tempest.common.staticdata.StyleSheetType;
	import tempest.ui.StyleSheetManager;
	import tempest.ui.TPUGlobals;
	import tempest.ui.UIStyle;
	import tempest.ui.collections.TArrayCollection;
	import tempest.ui.components.TComponent;
	import tempest.ui.components.TListMenu;
	import tempest.ui.components.TWindow;

	public class ChatModel
	{
		[Inject]
		public var signal:ChatSignal;
		[Inject]
		public var service:ChatService;
		private var nextChatId:int = 0;
		private var chatLinkId:int = 0;
		//输入频道
		public var currentInputChannel:int;
		//显示频道
		public var currentOutPutChannel:int;
		//聊天记录管理器
		private var _historyHolder:MainChatHistoryHolder;
		//号角聊天记录管理器
		private var _hornHistoryHolder:ChatHornHistoryHolder
		//待发送的物品缓存，发送后清空
		public var sendLinksBuffer:Array = [];
		//当前私聊对象
		public var currentChatTarget:String;
		/**
		 * 发送时间列表
		 */
		public var sendTimeList:Object = {};
		/**
		 * 频道状态列表
		 */
		public var channelState:Object = {};
		/**
		 * 未显示的聊天包缓存
		 */
		public var selfMsgBuff:Dictionary = new Dictionary();
		/**
		 * 表情
		 */
		private var _smileys:Array;
		[Bindable]
		public var disableChatWidthNotFriend:Boolean = false;

		public function ChatModel()
		{
			//初始化发送时间
			sendTimeList[ChatConst.CHANNEL_WORLD] = -100000000;
			sendTimeList[ChatConst.CHANNEL_ROUND] = -100000000;
			sendTimeList[ChatConst.CHANNEL_TEAM] = -100000000;
			sendTimeList[ChatConst.CHANNEL_GUILD] = -100000000;
			sendTimeList[ChatConst.CHANNEL_PRIVATE] = -100000000;
			sendTimeList[ChatConst.CHANNEL_HORN] = -100000000;
			sendTimeList[ChatConst.CHANNEL_HEARSAY] = -100000000;
			sendTimeList[ChatConst.CHANNEL_MUTUAL] = -100000000;
			sendTimeList[ChatConst.CHANNEL_SUPERHORN] = -100000000;
			sendTimeList[ChatConst.CHANNEL_BATTLELAND] = -100000000;
			//频道状态列表
			channelState[ChatConst.CHANNEL_WORLD] = ChatConst.CHANNEL_STATE_DEFAULT;
			channelState[ChatConst.CHANNEL_ROUND] = ChatConst.CHANNEL_STATE_DEFAULT;
			channelState[ChatConst.CHANNEL_TEAM] = ChatConst.CHANNEL_STATE_DEFAULT;
			channelState[ChatConst.CHANNEL_GUILD] = ChatConst.CHANNEL_STATE_DEFAULT;
			channelState[ChatConst.CHANNEL_PRIVATE] = ChatConst.CHANNEL_STATE_DEFAULT;
			channelState[ChatConst.CHANNEL_HORN] = ChatConst.CHANNEL_STATE_DEFAULT;
			channelState[ChatConst.CHANNEL_HEARSAY] = ChatConst.CHANNEL_STATE_DEFAULT;
			channelState[ChatConst.CHANNEL_MUTUAL] = ChatConst.CHANNEL_STATE_DEFAULT;
			channelState[ChatConst.CHANNEL_SUPERHORN] = ChatConst.CHANNEL_STATE_DEFAULT;
			channelState[ChatConst.CHANNEL_BATTLELAND] = ChatConst.CHANNEL_STATE_DEFAULT;
			_historyHolder = new MainChatHistoryHolder(ChatConst.MAX_LINE_CHAT, this);
			_hornHistoryHolder = new ChatHornHistoryHolder(ChatConst.MAX_LINE_HORN);
			_historyHolder.dialogAddedSignal.add(dialogAdded);
		}

		private function dialogAdded(bool:Boolean):void
		{
			signal.playPrivateEffect.dispatch(bool);
		}

		public function initSmileys():void
		{
			_smileys = [];
			var smileysConfigArray:Array = ChatSmileyConfigManager.smileysConfigArray;
			for each (var item:SmileyInfo in smileysConfigArray)
			{
				_smileys.push({shortcut: item.shortcut, src: TRslManager.getDefinition(item.link), link: item.link, desc: item.desc});
			}
//			_smileys = [{shortcut: "#a", src: TRslManager.getDefinition("expression1"), link: "expression1"}];
		}

		public function get smileys():Array
		{
			return _smileys;
		}

		public function getSmileyByLink(link:String):Object
		{
			for each (var smiley:Object in _smileys)
			{
				if (smiley.link == link)
				{
					return smiley;
				}
			}
			return null;
		}

		public function getSmileyByShortCut(shortcut:String):Object
		{
			for each (var smiley:Object in _smileys)
			{
				if (smiley.shortcut == shortcut)
				{
					return smiley;
				}
			}
			return null;
		}

		/**
		 * 生成聊天包的id
		 * @return
		 *
		 */
		public function getNextChatId():int
		{
			return nextChatId++;
		}

		/**
		 * 生成聊天物品的查询id
		 * @return
		 *
		 */
		public function getChatLinkId():int
		{
			return chatLinkId++;
		}

		/**
		 * 聊天记录管理
		 * @return
		 *
		 */
		public function get historyHolder():MainChatHistoryHolder
		{
			return _historyHolder;
		}

		/**
		 * 号角记录管理
		 * @return
		 *
		 */
		public function get hornHistoryHolder():ChatHornHistoryHolder
		{
			return _hornHistoryHolder;
		}

		/**
		 * 添加聊天内容
		 * @param chatEntity
		 *
		 */
		public function appendContent(chatEntity:ChatData, type:int = -1):void
		{
			if (!chatEntity)
				return;
			//聊天记录
			historyHolder.appendDialog(chatEntity);
			if (type == ChatConst.CHANNEL_HORN)
				signal.playNormalEffect.dispatch(chatEntity.channelId);
		}

		/**************************************ChatHelper移植过来的**********************************************/
		/**
		 * 设置私聊对象
		 * @param name
		 *
		 */
		public function setPrivateChatTarget(name:String, guid:int = 0):void
		{
			signal.setInputChannel.dispatch(ChatConst.CHANNEL_PRIVATE, name, guid);
		}

		public function setInputChannel(channelId:int, targetName:String = null, guid:int = 0):void
		{
			signal.setInputChannel.dispatch(channelId, targetName, guid);
		}

		public function getChannelCD(channelId:int, playerLevel:int):int
		{
			//			if (channelId != ChatConst.CHANNEL_WORLD)
			//			{
			return ChatConst.getChannelCD(channelId);
			//			}
			//			else
			//			{
			//				return 8;
			//				var temp:int = playerLevel > 90 ? 90 : playerLevel;
			//				if (temp > 20)
			//				{
			//					temp -= 20;
			//				}
			//				else
			//				{
			//					temp = 0;
			//				}
			//				temp = int((temp / 10) * 5);
			//				return (temp >= 40 ? 40 : 40 - temp);
			//			}
		}
		private var _itemTipWindowGroup:WindowGroup = new WindowGroup();

		public function processPlayerMenuSelect(operateType:int, playerChatData:Object):void
		{
			//			switch (operateType)
			//			{
			//				case MenuOperationType.CHAT:
			//					ChatHelper.setPrivateChatTarget(String(playerChatData.name), int(playerChatData.guid));
			//					break;
			//				case MenuOperationType.VIEW_INFO:
			//					if (playerChatData.guid == 0)
			//					{
			//						PlayerGuidLoaderManager.processGuid(playerChatData.name, function(guid:int):void
			//						{
			//							GameInstance.signal.attribute.queryPlayer.dispatch(guid);
			//						});
			//					}
			//					else
			//					{
			//						GameInstance.signal.attribute.queryPlayer.dispatch(playerChatData.guid);
			//					}
			//					break;
			//				case MenuOperationType.MAKE_FRIEND:
			//					if (playerChatData.guid == 0)
			//					{
			//						PlayerGuidLoaderManager.processGuid(playerChatData.name, function(guid:int):void
			//						{
			//							GameInstance.signal.friend.addFriendHandler.dispatch(guid);
			//						});
			//					}
			//					else
			//					{
			//						GameInstance.signal.friend.addFriendHandler.dispatch(playerChatData.guid);
			//					}
			//					break;
			//				case MenuOperationType.TEAM:
			//					if (playerChatData.guid == 0)
			//					{
			//						PlayerGuidLoaderManager.processGuid(playerChatData.name, function(guid:int):void
			//						{
			//							GameInstance.signal.team.makeTeamSignal.dispatch(guid, MakeTeamCommand.INVITE_KIND_OTHER);
			//						});
			//					}
			//					else
			//						GameInstance.signal.team.makeTeamSignal.dispatch(playerChatData.guid, MakeTeamCommand.INVITE_KIND_OTHER);
			//					break;
			//				case MenuOperationType.APPLICATION_TEAM:
			//					if (!GameInstance.mainCharData.isInTeam)
			//					{
			//						if (playerChatData.guid == 0)
			//						{
			//							PlayerGuidLoaderManager.processGuid(playerChatData.name, function(guid:int):void
			//							{
			//								GameInstance.signal.team.applyInTeamSignal.dispatch(guid);
			//							});
			//						}
			//						else
			//						{
			//							GameInstance.signal.team.applyInTeamSignal.dispatch(playerChatData.guid);
			//						}
			//					}
			//					else
			//					{
			//						MessageManager.instance.addHintById_client(1925, "你已经有队伍了");
			//					}
			//					break;
			//				case MenuOperationType.INVITE:
			//					if (playerChatData.guid == 0)
			//					{
			//						PlayerGuidLoaderManager.processGuid(playerChatData.name, function(guid:int):void
			//						{
			//							GameInstance.signal.guild.inviterInGuild.dispatch(guid);
			//						});
			//					}
			//					else
			//					{
			//						GameInstance.signal.guild.inviterInGuild.dispatch(playerChatData.guid);
			//					}
			//					break;
			//				case MenuOperationType.SEND_MAIL:
			//					GameInstance.signal.mail.writeMailForChat.dispatch(String(playerChatData.name));
			//					break;
			//				case MenuOperationType.COPY_NAME:
			//					System.setClipboard(String(playerChatData.name));
			//					break;
			//				case MenuOperationType.ENEMY:
			//					GameInstance.signal.friend.addEnemy.dispatch(playerChatData.guid);
			//				default:
			//					break;
			//			}
		}

		/**
		* 显示物品Tip
		* @param senderId
		* @param itemGuId
		* @param chatItemId
		* @param type
		* @param templateId
		* @param bind
		* @param stageX
		* @param stageY
		*
		*/
		public function showGoodsTip(senderId:int, itemGuId:int, chatItemId:int, type:int, templateId:int, bind:int, stageX:Number, stageY:Number):void
		{
			var tipWindow:LoaderTipWindow;
			//查找tip窗口是否已经在显示中
			tipWindow = _itemTipWindowGroup.find(LoaderTipWindow.NAME, function(tipWindow:LoaderTipWindow):Boolean
			{
				if (tipWindow.loaderId == chatItemId)
					return true;
				else
					return false;
			}) as LoaderTipWindow;
			if (tipWindow)
			{
				tipWindow.moveToTop();
				return; //已经有此窗口，返回
			}
			//打开新窗口
			tipWindow = new LoaderTipWindow(new LoaderTip(new UIStyle.tipBkSkin(), false, 4, 4, 200, StyleSheetManager.instance.getStyleSheet(StyleSheetType.DEFAULT)));
			tipWindow.addEventListener(Event.RESIZE, onTipWindowResize);
			//获取或创建loader
			var loader:TCPLoader = ChatItemLoaderManager.getLoader(chatItemId);
			if (!loader)
			{
				if (itemGuId != 0 && senderId != 0)
				{
					//					if (type == ItemConst.TYPE_ITEM_PET_SEAL)
					//					{
					//						//为宠物封印创建特殊的loader
					//						var item:PetEggSealData = SlotItemManager.instance.getItem(itemGuId) as PetEggSealData;
					//						if (!item)
					//						{
					//							item = PetEggSealData(ItemDataFactory.createByID(senderId, itemGuId, templateId));
					//						}
					//						item.playerBinded = bind != 0;
					//						loader = ChatItemLoaderManager.addLoader(chatItemId, new PetEggItemLoader(senderId, itemGuId, item));
					//					}
					//					else
					//					{
					loader = ChatItemLoaderManager.addLoader(chatItemId, new ItemLoader(senderId, itemGuId, templateId));
						//					}
				}
			}
			tipWindow.x = stageX;
			tipWindow.y = stageY;
			validatePos(tipWindow);
			_itemTipWindowGroup.showWindow(null, tipWindow, false, false, null, loader ? loader : ItemDataFactory.createByID(0, 0, templateId));
			tipWindow.loaderId = chatItemId;
			return;
		}

		private function onTipWindowResize(event:Event):void
		{
			validatePos(LoaderTipWindow(event.currentTarget));
		}

		private function validatePos(tipWindow:LoaderTipWindow):void
		{
			if (tipWindow.x >= TPUGlobals.app.width - tipWindow.width - 10)
				tipWindow.x = TPUGlobals.app.width - tipWindow.width;
			if (tipWindow.y >= TPUGlobals.app.height - tipWindow.height - 10)
				tipWindow.y = TPUGlobals.app.height - tipWindow.height;
		}

		/**
		 *  点击聊天框的文本链接处理
		 * @param event
		 * @param playerMenue
		 *
		 */
		public function onTextLink(event:TextEvent, panel:TComponent):void
		{
			var paramArray:Array = event.text.split((event.text.indexOf("┆") != -1) ? "┆" : "]");
			var type:String = paramArray[0];
			switch (type)
			{
				case ChatConst.LINK_PREFIX_NAME:
					MenuHelper.show(null, panel, panel.getParentView(TWindow) as TWindow, [MenuOperationType.CHAT,
						MenuOperationType.VIEW_INFO,
						MenuOperationType.MAKE_FRIEND,
						MenuOperationType.TEAM,
						MenuOperationType.SEND_MAIL,
						MenuOperationType.COPY_NAME,
						MenuOperationType.INVITE,
						MenuOperationType.ENEMY], {name: paramArray[1], guid: paramArray[2]}, onPlayerMenuSelect);
					break;
				case ChatConst.LINK_PREFIX_MUTUAL:
					signal.processMutualLink.dispatch(String(paramArray[1]), paramArray.slice(2));
					break;
				case ChatConst.LINK_PREFIX_GUILDTRSPORT:
					if (int(paramArray[5]) != GameConfig.currentLine % 10)
					{
						MessageManager.instance.addHintById_client(2709, "目标不在当前线路");
						return;
					}
					//					GameClient.sendGuildTransport(int(paramArray[1]), int(paramArray[2]), int(paramArray[3]), int(paramArray[4]));
					break;
				case ChatConst.LINK_PREFIX_OPEN_PANEL:
					break;
				case ChatConst.LINK_PREFIX_PASSID:
					//					SceneActionHelper.transport(paramArray[1] /*passID*/, paramArray[2] /*npcId*/);
					break;
				case ChatConst.LINK_PREFIX_WALKTO:
					//					SceneActionHelper.walkTo(paramArray[1], paramArray[2], paramArray[3], int(paramArray[4]));
					break;
				case ChatConst.LINK_PREFIX_APPLYING:
					//					GameInstance.signal.team.applyInTeamSignal.dispatch(paramArray[1]);
					break;
				case ChatConst.LINK_PREFIX_GUILDTRSPORT:
				default:
					var chatLinkAdapter:IChatLinkAdapter = ChatLinkAdapterFactory.createByLinkParam(type, paramArray.slice(1));
					chatLinkAdapter.textLinkSignal.add(onTextLinkSignal);
					break;
			}
		}

		private function onTextLinkSignal(senderId:int, itemGuId:int, chatItemId:int, type:int, templateId:int, bind:int, stageX:Number, stageY:Number):void
		{
			showGoodsTip(senderId, itemGuId, chatItemId, type, templateId, bind, TPUGlobals.stage.mouseX, TPUGlobals.stage.mouseY);
		}

		private function onPlayerMenuSelect(event:Event):void
		{
			var menu:TListMenu = TListMenu(event.currentTarget);
			processPlayerMenuSelect((menu.selectedItem as MenuDataItem).operateType, menu.data);
		}

		/**
		 *  发送聊天包到服务器
		 * @param str
		 * @param channelId
		 *
		 */
		public function sendChatToServer(str:String, channelId:int = 5):void
		{
			//构建聊天包
			var chatEntity:ChatData = new ChatData();
			chatEntity.channelId = channelId;
			chatEntity.content = str;
			var chatId:int = getNextChatId();
			if (!service.sendChatPacket(chatEntity))
			{
				service.sendChat(chatEntity.channelId, chatId, chatEntity.content); //向聊天服务器发送
			}
			//接收
			if (chatEntity.content.indexOf(".find") != -1 || chatEntity.channelId == ChatConst.CHANNEL_ROUND)
			{
				signal.resive.dispatch(chatEntity);
			}
		}
	}
}
