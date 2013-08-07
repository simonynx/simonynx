package fj1.modules.chat.view
{
	import fj1.common.GameInstance;
	import fj1.common.data.dataobject.ItemNumCounter;
	import fj1.common.data.dataobject.items.ItemData;
	import fj1.common.data.factories.ItemDataFactory;
	import fj1.common.net.ChatClient;
	import fj1.common.net.GameClient;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.staticdata.ChatConst;
	import fj1.common.staticdata.ItemConst;
	import fj1.common.staticdata.ItemSpecailConst;
	import fj1.common.staticdata.ShortCutHintConst;
	import fj1.common.ui.TWindowManager;
	import fj1.manager.ItemNumCounterManager;
	import fj1.manager.MessageManager;
	import fj1.modules.chat.helper.ChatStringHelper;
	import fj1.modules.chat.model.ChatModel;
	import fj1.modules.chat.model.interfaces.IChatLinkAdapter;
	import fj1.modules.chat.model.vo.ChatData;
	import fj1.modules.chat.service.ChatService;
	import fj1.modules.chat.singles.ChatSignal;
	import fj1.modules.chat.view.components.HornInputPanel;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.utils.getTimer;
	import tempest.common.keyboard.KeyCodes;
	import tempest.common.mvc.base.Mediator;
	import tempest.ui.components.textFields.TRichTextField;
	import tempest.utils.HtmlUtil;
	import tempest.utils.StringUtil;

	public class HornInputMediator extends Mediator
	{
		[Inject]
		public var hornInputPanel:HornInputPanel;
		[Inject]
		public var signal:ChatSignal;
		[Inject]
		public var service:ChatService;
		[Inject]
		public var model:ChatModel;

		public function HornInputMediator()
		{
			super();
		}

		public override function onRegister():void
		{
			addSignal(hornInputPanel.sendHorn, sendHorn);
			addSignal(hornInputPanel.selectFace, selectFace);
			addSignal(hornInputPanel.rtfKeyDown, onKeyDown);
			addSignal(hornInputPanel.rtfKeyUp, onKeyUp);
			addSignal(hornInputPanel.rtfText, onTextInput);
			addSignal(hornInputPanel.buyNormal, buyNormal);
			addSignal(hornInputPanel.buySuper, buySuper);
			addSignal(hornInputPanel.smileylistPanel.selectedSignal, onSmileySelect);
			addSignal(signal.addHornItemLink, addHornItemLink);
		}

		private function sendHorn(evt:MouseEvent):void
		{
			var content:String = StringUtil.trim(hornInputPanel.rtf_input.content);
			if (!checkSend(content))
				return;
			//构建聊天包并发送
			buildChatAndSend(content);
			hornInputPanel.rtf_input.clear();
		}

		/**
		 *检查可否发送
		 * @param content
		 * @return
		 *
		 */
		private function checkSend(content:String):Boolean
		{
			if (hornInputPanel._group.selectedButton == hornInputPanel.cbx_normal)
				if (!checkItem(ItemSpecailConst.ITEM_TEMPLATE_CLARION, ChatConst.CHANNEL_HORN))
					return false;
			if (hornInputPanel._group.selectedButton == hornInputPanel.cbx_super)
			{
				if (!checkItem(ItemSpecailConst.ITEM_TEMPLATE_SUPERCLARION, ChatConst.CHANNEL_SUPERHORN))
					return false;
			}
			//都是空格
			if (/^[\s]*$/g.exec(content))
			{
				MessageManager.instance.addHintById_client(1103, "無法發送空白信息");
				return false;
			}
			//检查输入内容  
			if (!checkContent(content))
			{
				MessageManager.instance.addHintById_client(1106, "您输入的文字中含有非法字符！"); //您输入的文字中含有非法字符！
				return false;
			}
			return true;
		}

		/**
		 *添加物品链接
		 *
		 */
		private function addHornItemLink(dataObj:IChatLinkAdapter):void
		{
			var nameStr:String = "[" + dataObj.nameInput + "]";
			//检查字符串长度
			if (nameStr.length + hornInputPanel.rtf_input.content.length > ChatConst.MAX_HORN_INPUT)
			{
				return;
			}
			model.sendLinksBuffer.push(dataObj);
			hornInputPanel.rtf_input.append(nameStr, null, false, hornInputPanel.rtf_input.defaultTextFormat);
			//设置焦点到聊天框
			hornInputPanel.setChatFocus();
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
			chatData.content = content;
			chatData.items = model.sendLinksBuffer.slice();
			//将物品数据合并入字符串中
			ChatStringHelper.pushItems(chatData);
			if (hornInputPanel._group.selectedButton == hornInputPanel.cbx_normal)
			{
				chatData.channelId = ChatConst.CHANNEL_HORN;
			}
			if (hornInputPanel._group.selectedButton == hornInputPanel.cbx_super)
			{
				chatData.channelId = ChatConst.CHANNEL_SUPERHORN;
			}
			//发送			
			service.sendChatPacket(chatData);
			//接收
			chatData.senderName = GameInstance.mainCharData.name;
			chatData.senderId = GameInstance.mainChar.id;
			chatData.isGM = GameInstance.mainCharData.isGM;
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
		 *检查号角数量
		 * 冷却时间
		 * @param id
		 * @param channelID
		 * @return
		 *
		 */
		private function checkItem(id:int, channelID:int):Boolean
		{
			var numberCounter:ItemNumCounter = ItemNumCounterManager.instance.getCounter(id);
			if (numberCounter.num == 0)
			{
				var hornItem:ItemData = ItemDataFactory.createByID(0, 0, id);
//				ShortCutHintManager.show(ShortCutHintConst.ID_HORN, 2106, hornItem, function(obj:Object):void
//				{
//					GameInstance.signal.mall.queryItem.dispatch(id);
//				});
				MessageManager.instance.addHintById_client(1117, "號角數量不足，無法發送信息");
				return false;
			}
			//检查冷却时间
			if (!GameInstance.mainCharData.isGM)
			{
				var sendTime:int = getTimer();
				var timeInterval:int = (sendTime - model.sendTimeList[channelID] as int) / 1000;
				if (timeInterval < model.getChannelCD(channelID, GameInstance.mainCharData.level))
				{
					//在冷却时间内
					var timeRemain:int = model.getChannelCD(channelID, GameInstance.mainCharData.level) - timeInterval;
					MessageManager.instance.addHintById_client(1116, "您還處于發言間隔中，冷卻時間剩余%s秒", timeRemain);
					return false;
				}
			}
			return true;
		}

		private function selectFace(evt:MouseEvent):void
		{
			hornInputPanel.smileylistPanel.items = model.smileys;
			hornInputPanel.smileylistPanel.play();
		}

		private function onSmileySelect(smiley:Object):void
		{
			//检查字符串长度
			if (smiley.shortcut.length + hornInputPanel.rtf_input.content.length > ChatConst.MAX_HORN_INPUT)
			{
				return;
			}
			hornInputPanel.rtf_input.append(smiley.shortcut, null, false, hornInputPanel.rtf_input.defaultTextFormat);
			//设置焦点到聊天框
			hornInputPanel.setChatFocus();
		}

		private function onKeyDown(evt:KeyboardEvent):void
		{
			var curText:String = hornInputPanel.rtf_input.text;
			var deleteChar:String;
			var deletePos:int;
			switch (evt.keyCode)
			{
				case KeyCodes.BACKSPACE.keyCode: //删除物品链接
					deletePos = hornInputPanel.rtf_input.textfield.selectionBeginIndex - 1; //删除的位置
					deleteChar = curText.charAt(deletePos);
					if (deleteChar != "]")
					{
						return;
					}
					removeItemLink(curText, deletePos);
					break;
				case KeyCodes.DELETE.keyCode: //删除物品链接
					deletePos = hornInputPanel.rtf_input.textfield.selectionBeginIndex; //删除的位置
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
					removeItemLink(curText, deletePos);
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
			hornInputPanel.rtf_input.clear();
			var textAfterRemoveLink:String = StringUtil.replaceByPos(curText, nameDataToRemove.start, nameDataToRemove.end, "");
			hornInputPanel.rtf_input.append(textAfterRemoveLink, null, false, hornInputPanel.txtFormat);
			//设置光标位置
			hornInputPanel.setTextFieldSelection(nameDataToRemove.start);
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

		private function onKeyUp(evt:KeyboardEvent):void
		{
			switch (evt.keyCode)
			{
				case KeyCodes.ENTER.keyCode:
					sendHorn(null);
					break;
			}
		}

		private function onTextInput(evt:TextEvent):void
		{
			//不允许输入"<"、"┆"
			if (evt.text.indexOf("<") != -1 || evt.text.indexOf("┆") != -1)
			{
				evt.preventDefault();
				return;
			}
		}

		private function buyNormal(evt:MouseEvent):void
		{
//			GameInstance.signal.mall.queryItem.dispatch(ItemSpecailConst.ITEM_TEMPLATE_CLARION);
		}

		private function buySuper(evt:MouseEvent):void
		{
//			GameInstance.signal.mall.queryItem.dispatch(ItemSpecailConst.ITEM_TEMPLATE_SUPERCLARION);
		}
	}
}
