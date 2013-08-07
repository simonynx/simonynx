package fj1.modules.chat.view
{
	import fj1.common.GameInstance;
	import fj1.common.res.hint.vo.*;
	import fj1.common.staticdata.*;
	import fj1.manager.DirtyWordManager;
	import fj1.manager.MessageManager;
	import fj1.modules.chat.helper.ChatStringHelper;
	import fj1.modules.chat.model.ChatModel;
	import fj1.modules.chat.model.interfaces.IChatLinkAdapter;
	import fj1.modules.chat.model.vo.ChannelListItemData;
	import fj1.modules.chat.model.vo.ChatData;
	import fj1.modules.chat.service.ChatService;
	import fj1.modules.chat.singles.ChatSignal;
	import fj1.modules.chat.view.components.*;

	import flash.events.*;
	import flash.utils.getTimer;

	import tempest.common.keyboard.KeyCodes;
	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.common.mvc.base.Mediator;
	import tempest.engine.SceneCharacter;
	import tempest.ui.PopupManager;
	import tempest.ui.components.TCombobox;
	import tempest.ui.events.ListEvent;
	import tempest.utils.ListenerManager;
	import tempest.utils.StringUtil;

	public class MainChatMediator extends Mediator
	{
		private static const log:ILogger = TLog.getLogger(MainChatMediator);
		[Inject]
		public var mainChatPanel:MainChatPanel;
		[Inject]
		public var signal:ChatSignal;
		[Inject]
		public var service:ChatService;
		[Inject]
		public var model:ChatModel;
		private var _listenerMananger:ListenerManager;
		private var _isCleanInputText:Boolean = true;

		public function MainChatMediator()
		{
			super();
		}

		public override function onRegister():void
		{
			_listenerMananger = new ListenerManager();
			//默认输入频道
			setInputChannel(ChatConst.CHANNEL_ROUND);
			//默认输出频道
			mainChatPanel.chatPanel.setOutputChannel(ChatConst.CHANNEL_ALL);
			MessageManager.registerChatShower(HintConst.HINT_PLACE_CHAT, showText);
			addSignal(signal.setInputChannel, setInputChannel);
			addSignal(signal.setOutputChannel, onSetOutputChannel);
			addSignal(signal.resive, onResive);
			//输入框
			mainChatPanel.rtf_input.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			mainChatPanel.rtf_input.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			mainChatPanel.rtf_input.textfield.addEventListener(TextEvent.TEXT_INPUT, onTextInput);
			_listenerMananger.addEventListener(mainChatPanel.chatPanel.tlist2_chat_content, ListEvent.ITEM_RENDER_CREATE, onChatItemRenderCreate);
			//输入框表情选择按钮
			mainChatPanel.btn_face.addEventListener(MouseEvent.CLICK, onClick);
			//输入框表情选择面板
			addSignal(mainChatPanel.smileylistPanel.selectedSignal, onSmileySelect);
//			var splugin:ShortcutPlugin = new ShortcutPlugin();
//			splugin.addShortcut(ChatModel.instance.smileys);
//			mainChatPanel._rtf_input.addPlugin(splugin);
			//发送按钮
			mainChatPanel.btn_send.addEventListener(MouseEvent.CLICK, onSend);
			//频道选择列表
			mainChatPanel._btn_change_CH.addEventListener(Event.SELECT, onCHListSelect);
			addSignal(signal.addLink, addLink);
			addSignal(signal.focusToText, focusToText);
		}

		private function onClick(event:MouseEvent):void
		{
			mainChatPanel.smileylistPanel.items = model.smileys;
			mainChatPanel.smileylistPanel.play();
		}

		private function onChatItemRenderCreate(event:ListEvent):void
		{
			RichTextFieldRender(event.itemRender).rtf.addEventListener(TextEvent.LINK, onTextLink);
		}

		/**
		 * 文本链接
		 * @param event
		 *
		 */
		private function onTextLink(event:TextEvent):void
		{
			model.onTextLink(event, mainChatPanel.chatPanel);
		}

		private function showText(hintData:HintData):void
		{
			var chatPack:ChatData = new ChatData();
			chatPack.channelId = HintConfig(hintData.hintConfig).chatChannel;
			if (chatPack.channelId == ChatConst.CHANNEL_HEARSAY)
			{
				//对传言采用不同的字符串解析方式
				var hearsayData:HearsayHintData = HearsayHintData(hintData);
				chatPack.content = ChatStringHelper.formatHearsayForChat(hearsayData.hintConfig.pattern, hearsayData.params, hearsayData.itemParams, HearsayHintConfig(hearsayData.hintConfig).trackLink, HearsayHintConfig(hearsayData.
					hintConfig).trackLinkName, hearsayData.hearsayTeamID, model);
			}
			else
			{
				chatPack.content = hintData.content;
			}
			chatPack.isSystemMsg = true;
			onResive(chatPack);
		}

		private function onTextInput(event:TextEvent):void
		{
			//不允许输入"<"、"┆"
			if (event.text.indexOf("<") != -1 || event.text.indexOf("┆") != -1)
			{
				event.preventDefault();
				return;
			}
			//快捷键切换频道
			if (event.text == " ")
			{
				var toChannel:int = ChatConst.getChannelIdByShortCutStr(mainChatPanel.rtf_input.text);
				if (toChannel > 0)
				{
					setInputChannel(toChannel);
					event.preventDefault();
				}
			}
		}

		/**
		 * 设置输入频道
		 * @param channelId
		 * @param targetName
		 * @param guid
		 * @param setItemSelect
		 * @return 输入频道是否被修改
		 *
		 */
		public function setInputChannel(channelId:int, targetName:String = null, guid:int = 0, setItemSelect:Boolean = true):Boolean
		{
			if (setItemSelect)
			{
				mainChatPanel._btn_change_CH.selectedItem = mainChatPanel.getMenuData(channelId);
			}
			//焦点切换到聊天框
			mainChatPanel.setChatFocus();
			model.currentInputChannel = channelId;
			var ret:Boolean = true;
			if (channelId == ChatConst.CHANNEL_PRIVATE)
			{
				if (!targetName)
				{
					ret = false;
				}
				else if (model.currentChatTarget == targetName)
				{
					ret = false;
				}
				else if (targetName == GameInstance.mainCharData.name)
				{
					model.currentChatTarget = targetName;
					//					MessageManager.instance.addHintById_client(1107, "不能和自己聊天"); //不能和自己聊天
					ret = false;
				}
				else
				{
					//发送设置私聊请求
					service.sendPrivateChatTarget(targetName, guid);
					model.currentChatTarget = targetName;
					ret = true;
				}
			}
			else
			{
				model.currentChatTarget = null;
				ret = true;
			}
			if (ret)
			{
				cleanInput();
			}
			return ret;
		}

		private function onSetOutputChannel(channelId:int):void
		{
			mainChatPanel.chatPanel.setOutputChannel(channelId);
		}

		/**
		 * 清空输入框
		 *
		 */
		private function cleanInput():void
		{
			if (_isCleanInputText)
			{
				mainChatPanel.rtf_input.clear();
				model.sendLinksBuffer = [];
				//保持私聊对象显示
				if (model.currentInputChannel == ChatConst.CHANNEL_PRIVATE)
				{
					if (model.currentChatTarget)
					{
						mainChatPanel.rtf_input.append("/" + model.currentChatTarget + " ", null, false, mainChatPanel.txtFormat);
					}
					else
					{
						mainChatPanel.rtf_input.append("/");
					}
					mainChatPanel.setTextFieldSelection(mainChatPanel.rtf_input.textfield.length); //设置光标显示在文本末尾				
				}
			}
			else
			{
				_isCleanInputText = true;
			}
		}

		/**
		 * 接收聊天包
		 * @param chatEntity
		 *
		 */
		public function onResive(chatData:ChatData):void
		{
			if (ChatConst.channelItemSendable(chatData.channelId))
			{
				ChatStringHelper.analyisItems(chatData, model);
			}
			//解析物品之后，再和谐敏感词
//			if (chatData.channelId != ChatConst.CHANNEL_GM
//				&& ChatConst.channelDirtyWordCheckNeeded(chatData.channelId)
//				&& !chatData.isGM
//				&& !(GameInstance.mainCharData.isGM && GameInstance.mainChar.id == chatData.senderId)) //和谐敏感词的条件
//			{
//				replaceDirtyWord(chatData);
//			}
			chatData.contentBuilded = ChatStringHelper.buildChatString(chatData, model);
//			ChatStringHelper.analyisSimleys(chatData);
			//添加聊天文本
			if ((chatData.channelId == ChatConst.CHANNEL_HORN && chatData.senderId) || (chatData.channelId == ChatConst.CHANNEL_SUPERHORN && chatData.senderId))
			{
				model.appendContent(chatData, ChatConst.CHANNEL_HORN);
			}
			else
			{
				//屏蔽黑名单
//				if (GameInstance.model.friend.getEntity(FriendConst.TYPE_BLACK, chatData.senderId))
//				{
//					return;
//				}
			}
			model.appendContent(chatData);
			//加泡泡
			if (chatData.channelId == ChatConst.CHANNEL_PRIVATE || chatData.channelId == ChatConst.CHANNEL_ROUND || chatData.channelId == ChatConst.CHANNEL_TEAM)
			{
				var sender:SceneCharacter = GameInstance.scene.getCharacterById(chatData.senderId);
				if (sender)
				{
//					sender.talk(chatData.content.replace(/#\w{2}/g, function():String
//					{
//						//替换表情占位符
//						var shortcut:String = String(arguments[0]);
//						var simleyObj:Object = ChatModel.instance.getSmileyByShortCut(shortcut);
//						if (simleyObj)
//						{
//							return "";
//						}
//						else
//						{
//							return arguments[0];
//						}
//					}));
					var result:Object = ChatStringHelper.analyisSimleys2(chatData.contentPure);
					sender.talk(result.content, result.simleys);
				}
			}
		}

		private function replaceDirtyWord(chatData:ChatData):void
		{
			//在敏感词检测前，临时物品链接占位符
			var tempItems:Array = chatData.items.slice(); //item临时副本
			var reg:RegExp = /\[.*?\]/g;
			var index:int = 0;
			var itemFiltedContent:String = chatData.content.replace(reg, function():String
			{
				var matched:String = String(arguments[0]);
				for (var i:int = 0; i < tempItems.length; ++i)
				{
					var item:IChatLinkAdapter = IChatLinkAdapter(tempItems[i]);
					if ("[" + item.nameInput + "]" == matched /*matched*/)
					{
						tempItems.splice(i, 1);
						return "<" + (i + index++) + ">";
					}
				}
				return arguments[0];
			});
			//替换敏感词
			itemFiltedContent = DirtyWordManager.replaceDirtyWord(itemFiltedContent);
			reg = /<.*?>/g;
			chatData.content = itemFiltedContent.replace(reg, function():String
			{
				var matched:String = String(arguments[0]);
				var pos:int = parseInt(matched.substring(1, matched.length - 1));
				var item:IChatLinkAdapter = IChatLinkAdapter(chatData.items[pos]);
				return "[" + item.nameInput + "]";
			});
		}

		/*************************************************输入框处理**************************************************************/
		private function onKeyDown(event:KeyboardEvent):void
		{
			var curText:String = mainChatPanel.rtf_input.text;
			var deleteChar:String;
			var deletePos:int;
			switch (event.keyCode)
			{
				case KeyCodes.BACKSPACE.keyCode: //删除物品链接
					deletePos = mainChatPanel.rtf_input.textfield.selectionBeginIndex - 1; //删除的位置
					deleteChar = curText.charAt(deletePos);
					if (deleteChar != "]")
					{
						return;
					}
					removeItemLink(curText, deletePos);
					break;
				case KeyCodes.DELETE.keyCode: //删除物品链接
					deletePos = mainChatPanel.rtf_input.textfield.selectionBeginIndex; //删除的位置
					deleteChar = curText.charAt(deletePos);
					if (deleteChar != "[")
					{
						return;
					}
					var endIndex:int = curText.indexOf("]", deletePos + 1);
					if (endIndex == -1)
					{
						return;
					}
					removeItemLink(curText, endIndex);
					break;
			}
		}

		private function onKeyUp(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case KeyCodes.ENTER.keyCode:
					if (mainChatPanel.rtf_input.textfield.selectable)
					{
//					mainChatPanel.setFocusToScreen(); //焦点切换到场景
						onSend(null);
					}
					break;
			}
		}

		/**
		 * 移除整个物品链接
		 * 对应移除物品发送缓存中同名的物品数据
		 * 在多个物品同名的情况下，根据其在重复的物品中的索引来删除对应的缓存物品数据
		 * @param curText
		 * @param deletePos
		 *
		 */
		private function removeItemLink(curText:String, deletePos:int):void
		{
			//获取聊天文本中删除位置之前的所有物品链接
			var itemNameDataArray:Array = getItemNamesInStr(curText, deletePos);
			if (itemNameDataArray.length == 0)
			{
				return;
			}
			//获取被删除的物品名称（最后一项）并获取其出现的次数
			var nameDataToRemove:Object = itemNameDataArray[itemNameDataArray.length - 1];
			var nameRepeatCount:int = getNameRepeatCount(itemNameDataArray, nameDataToRemove.name);
			//删除物品发送缓存中对应物品
			removeItemInSendBuffer(nameDataToRemove.name, nameRepeatCount - 1);
			//整体删除物品链接文本
			mainChatPanel.rtf_input.clear();
			var textAfterRemoveLink:String = StringUtil.replaceByPos(curText, nameDataToRemove.start, nameDataToRemove.end, "");
			mainChatPanel.rtf_input.append(textAfterRemoveLink, null, false, mainChatPanel.txtFormat);
			//设置光标位置
			mainChatPanel.setTextFieldSelection(nameDataToRemove.start);
		}

		/**
		 * 获取物品名称在文本中出现的次数
		 * @param nameDataArray
		 * @param name
		 * @return
		 *
		 */
		private function getNameRepeatCount(nameDataArray:Array, name:String):int
		{
			var count:int = 0;
			for each (var nameData:Object in nameDataArray)
			{
				if (nameData.name == name)
				{
					++count;
				}
			}
			return count;
		}

		/**
		 * 删除物品发送缓存中对应名称的物品
		 * @param name 物品名称
		 * @param pos 删除第几个重复的物品
		 *
		 */
		private function removeItemInSendBuffer(name:String, repeatPos:int):void
		{
			var curPos:int = 0;
			var itemsBuffer:Array = model.sendLinksBuffer;
			for (var i:int = 0; i < itemsBuffer.length; i++)
			{
				var item:IChatLinkAdapter = IChatLinkAdapter(itemsBuffer[i]);
				if (item.nameInput == name)
				{
					if (curPos == repeatPos)
					{
						itemsBuffer.splice(i, 1);
						break;
					}
					else
					{
						++curPos;
					}
				}
			}
		}

		/**
		 * 获取字符串中所有物品名称
		 * @param text
		 * @param endPos
		 * @return
		 *
		 */
		private function getItemNamesInStr(text:String, endPos:int):Array
		{
			var start:int = 0;
			var nameStart:int = -1;
			var nameEnd:int = -1;
			var nameStrArray:Array = [];
			while (start < endPos)
			{
				nameStart = text.indexOf("[", start);
				if (nameStart == -1)
				{
					return nameStrArray;
				}
				nameEnd = text.indexOf("]", start + 1);
				if (nameEnd == -1)
				{
					return nameStrArray;
				}
				var itemName:String = text.substring(nameStart + 1, nameEnd);
				if (itemName.length > 0)
				{
					nameStrArray.push({name: itemName, start: nameStart, end: nameEnd});
				}
				start = nameEnd + 1;
			}
			return nameStrArray;
		}

		/**
		 * 添加链接到输入框
		 * @param goodsEntity
		 *
		 */
		public function addLink(dataObj:IChatLinkAdapter):void
		{
			var nameStr:String = "[" + dataObj.nameInput + "]";
			//检查字符串长度
			if (nameStr.length + mainChatPanel.rtf_input.content.length > ChatConst.MAX_INPUT_LEN)
			{
				return;
			}
			model.sendLinksBuffer.push(dataObj);
			mainChatPanel.rtf_input.append(nameStr, null, false, mainChatPanel.rtf_input.defaultTextFormat);
			//设置焦点到聊天框
			mainChatPanel.setChatFocus();
		}

		/*************************************************************************************************************************/
		/**
		 * 发送
		 * @param event
		 *
		 */
		private function onSend(event:Event):void
		{
			//替换输入框中的表情为占位符
//			var chatModel:ChatModel = ChatModel.instance;
//			var xml:XML = mainChatPanel._rtf_input.exportXML();
//			var content:String = xml.text;
//			var spriteXMLList:XMLList = xml.sprites;
//			if (spriteXMLList)
//			{
//				var spritesXML:XMLList = spriteXMLList[0].sprite;
//				var count:int = 0;
//				for each (var spriteXML:XML in spritesXML)
//				{
//					var smiley:Object = chatModel.getSmileyByLink(spriteXML.@src);
//					content = StringUtil.addAt(smiley.shortcut, content, parseInt(spriteXML.@index) + 2 * count);
//				}
//			}
			var content:String = StringUtil.trim(mainChatPanel.rtf_input.content);
//			var content:String = StringUtil.trim(mainChatPanel._rtf_input.text);
			//记录输入内容
			mainChatPanel.inputLogger.logInput(content);
			//设置到私聊 
			var switchData:Array = tryToSwitchChannel(content);
			if (!switchData)
			{
				cleanInput();
				return;
			}
			content = String(switchData[0]);
			var channelSwitched:Boolean = Boolean(switchData[1]); //频道是否被切换
			var hasSwitchFlag:Boolean = Boolean(switchData[2]); //是否包含频道切换字符"/"
//			var friend:FriendInfo = SociatyHelper.getFirendInfoByName(_chatStateManager.currentChatTarget);
//			var guid:int = friend ? friend.id : 0;
			var guid:int = 0;
			//检查发送条件
			if (!checkSend(model.currentInputChannel, content, channelSwitched, hasSwitchFlag, guid))
			{
				//清空
				cleanInput();
				return;
			}
			//构建聊天包并发送
			buildChatAndSend(content);
			//清空
			cleanInput();
		}

		/**
		 * 检查发送条件
		 * @param channelId 频道Id
		 * @param text 文本
		 * @param channelSwitched 是否切换过频道
		 * @return
		 *
		 */
		private function checkSend(channelId:int, text:String, channelSwitched:Boolean, hasSwitchFlag:Boolean, _guid:int):Boolean
		{
//			if (channelId == ChatConst.CHANNEL_HORN)
//			{
//				var numberCounter:ItemNumCounter = ItemNumCounterManager.instance.getCounter(ItemSpecailConst.ITEM_TEMPLATE_CLARION);
//				if (numberCounter.num == 0)
//				{
//					var hornItem:ItemData = ItemDataFactory.createByID(0, 0, ItemSpecailConst.ITEM_TEMPLATE_CLARION);
//					ShortCutHintManager.show(ShortCutHintConst.ID_HORN, 2106, hornItem, function(obj:Object):void
//					{
//						GameInstance.signal.mall.queryItem.dispatch(ItemSpecailConst.ITEM_TEMPLATE_CLARION);
//					});
//					return false;
//				}
//			}
			if (channelId == ChatConst.CHANNEL_TEAM && !GameInstance.mainCharData.isInTeam)
			{
				MessageManager.instance.addHintById_client(1109, "您不在队伍中"); //您不在队伍中
				return false;
			}
			if (channelId == ChatConst.CHANNEL_GUILD && !GameInstance.mainCharData.isInGuild)
			{
				MessageManager.instance.addHintById_client(1110, "您还没有加入%s，无法使用%s频道", GuildConst.guildStr, GuildConst.guildStr);
				return false;
			}
			if (channelId == ChatConst.CHANNEL_BATTLELAND)
			{
//				var actTempl:ActivityTemplate = ActivityManager.getActivityTemplate(ExplorationConst.GEWACTIVITY);
//				if (!actTempl)
//				{
//					log.error("找不到活动id = " + ExplorationConst.GEWACTIVITY + " 对应的活动配置ActivityTemplate");
//					return false;
//				}
//				if (actTempl.mapid != GameInstance.scene.id)
//				{
//					MessageManager.instance.addHintById_client(1119, "您還沒進入戰場，無法使用戰場頻道");
//					return false;
//				}
			}
//			//检查玩家等级
//			if (channelId == ChatConst.CHANNEL_WORLD && GameInstance.mainCharData.level < ChatConst.CHANNEL_WORLD_LEVEL_REQ)
//			{
//				MessageManager.instance.addHintById_client(1104, "您等级过低"); //您等级过低
//				return false;
//			}
			//检查冷却时间
			if (!GameInstance.mainCharData.isGM)
			{
				var sendTime:int = getTimer();
				var timeInterval:int = (sendTime - model.sendTimeList[model.currentInputChannel] as int) / 1000
				if (timeInterval < model.getChannelCD(channelId, GameInstance.mainCharData.level))
				{
					//在冷却时间内
					var timeRemain:int = model.getChannelCD(channelId, GameInstance.mainCharData.level) - timeInterval;
					if (channelId == ChatConst.CHANNEL_HORN)
					{
					}
					MessageManager.instance.addHintById_client(1116, "您還處于發言間隔中，冷卻時間剩余%s秒", timeRemain);
					_isCleanInputText = false;
					return false;
				}
			}
			//都是空格
			if (/^[\s]*$/g.exec(text))
			{
				if (!channelSwitched)
				{
					MessageManager.instance.addHintById_client(1103, "不许发送空信息"); //不许发送空信息
				}
				return false;
			}
			//检查聊天对象
			if (channelId == ChatConst.CHANNEL_PRIVATE)
			{
				if (!hasSwitchFlag) //没有指定私聊对象
				{
					model.currentChatTarget = "";
					//					MessageManager.instance.addHintById_client(1108, "该玩家已经离线或者下线"); //找不到该玩家
					return false;
				}
				if (GameInstance.mainCharData.name == model.currentChatTarget) //和自己聊天
				{
					MessageManager.instance.addHintById_client(1107, "不能和自己聊天"); //不能和自己聊天
					return false;
				}
//				if (GameInstance.model.friend.getEntity(FriendConst.TYPE_BLACK, _guid))
//				{
//					MessageManager.instance.addHintById_client(1111, "该玩家已经被你屏蔽了！"); //您在该频道被禁言！
//					return false;
//				}
			}
			//检查是否被禁言
			if (model.channelState[channelId] == ChatConst.CHANNEL_STATE_DISABLE)
			{
				MessageManager.instance.addHintById_client(1105, "您在该频道被禁言！"); //您在该频道被禁言！
				return false;
			}
			//检查输入内容  
			if (!checkContent(text))
			{
				MessageManager.instance.addHintById_client(1106, "您输入的文字中含有非法字符！"); //您输入的文字中含有非法字符！
				return false;
			}
			model.sendTimeList[model.currentInputChannel] = sendTime;
			return true;
		}

		/**
		 * 尝试通过输入文本设置频道
		 * @param content
		 * @return
		 *
		 */
		private function tryToSwitchChannel(content:String):Array
		{
			var error:Boolean = false; //是否切换失败
			var channelSwitched:Boolean = false; //频道是否被切换
			var hasSwitchFlag:Boolean = false; //是否包含频道切换字符"/"
			if (content.charAt(0) == "/")
			{
				hasSwitchFlag = true;
				if (content.length == 2)
				{
					//设置到其他频道
					var toChannel:int = ChatConst.getChannelIdByShortCutStr(content);
					if (toChannel > 0)
					{
						setInputChannel(toChannel);
						channelSwitched = true;
					}
					else
					{
						MessageManager.instance.addHintById_client(1101, "无效的频道编号"); //无效的频道编号
						error = true;
					}
					content = "";
				}
				else if (content.length > 2)
				{
					//设置到私聊
					var spIndex:int = content.indexOf(" ");
					var chatTarget:String;
					if (spIndex > 0)
						chatTarget = content.substring(1, spIndex);
					else
						chatTarget = content.substring(1);
					channelSwitched = setInputChannel(ChatConst.CHANNEL_PRIVATE, chatTarget);
					content = content.substr(chatTarget.length + 2);
				}
			}
			return !error ? [content, channelSwitched, hasSwitchFlag] : null;
		}

		/**
		 * 检查输入内容
		 * @param text
		 * @return
		 *
		 */
		private function checkContent(text:String):Boolean
		{
			//
			return true;
		}

		/**
		 * 频道列表选择
		 * @param event
		 *
		 */
		private function onCHListSelect(event:Event):void
		{
			var channelData:ChannelListItemData = TCombobox(event.currentTarget).selectedItem as ChannelListItemData;
			setInputChannel(channelData.channelId, null, 0, false);
		}

		/**
		 * 构建聊天包并发送
		 * @param content
		 *
		 */
		private function buildChatAndSend(content:String):void
		{
			//构建聊天包
			var chatData:ChatData = new ChatData();
			chatData.channelId = model.currentInputChannel;
			chatData.content = content;
			chatData.items = model.sendLinksBuffer.slice();
			//将物品数据合并入字符串中
			ChatStringHelper.pushItems(chatData);
			//缓存本地聊天包
			//发送到场景服务器的聊天包 和 号角包 不走缓存
			var chatId:int = model.getNextChatId();
			if (chatData.channelId != ChatConst.CHANNEL_ROUND
				&& chatData.channelId != ChatConst.CHANNEL_HORN && chatData.channelId != ChatConst.CHANNEL_BATTLELAND)
			{
				model.selfMsgBuff[chatId] = chatData;
			}
			//发送			
			if (!service.sendChatPacket(chatData))
			{
				service.sendChat(chatData.channelId, chatId, chatData.content); //向聊天服务器发送
			}
			//接收
			chatData.senderName = GameInstance.mainCharData.name;
			chatData.senderId = GameInstance.mainChar.id;
			chatData.isGM = GameInstance.mainCharData.isGM;
			if (chatData.channelId == ChatConst.CHANNEL_ROUND)
			{
				signal.resive.dispatch(chatData);
			}
		}

		/**
		 * 选中表情
		 * @param smiley
		 *
		 */
		private function onSmileySelect(smiley:Object):void
		{
			//检查字符串长度
			if (smiley.shortcut.length + mainChatPanel.rtf_input.content.length > ChatConst.MAX_INPUT_LEN)
			{
				return;
			}
			mainChatPanel.rtf_input.append(smiley.shortcut, null, false, mainChatPanel.rtf_input.defaultTextFormat);
			//设置焦点到聊天框
			mainChatPanel.setChatFocus();
			mainChatPanel.rtf_input
		}

		private function focusToText():void
		{
			if (mainChatPanel._isFocusInChat)
			{
				mainChatPanel.setChatFocus();
			}
		}
	}
}
