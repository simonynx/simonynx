package fj1.modules.chat.helper
{
	import fj1.common.GameInstance;
	import fj1.common.data.factories.ItemDataFactory;
	import fj1.common.res.item.ItemTemplateManager;
	import fj1.common.res.item.vo.ItemTemplate;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.staticdata.ChatConst;
	import fj1.common.staticdata.ColorConst;
	import fj1.common.staticdata.ItemQuality;
	import fj1.modules.chat.model.ChatLinkAdapterFactory;
	import fj1.modules.chat.model.ChatModel;
	import fj1.modules.chat.model.ChatMutualChannelProcesser;
	import fj1.modules.chat.model.chatlinkAdapters.ChatItemLinkAdapter;
	import fj1.modules.chat.model.interfaces.IChatLinkAdapter;
	import fj1.modules.chat.model.vo.ChatData;
	import fj1.modules.main.MainFacade;

	import flash.text.TextField;

	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.utils.HtmlUtil;
	import tempest.utils.StringUtil;

	public class ChatStringHelper
	{
		private static const log:ILogger = TLog.getLogger(ChatStringHelper);

		//------------------------------------------------------------------------
		//物品发送流程
		//addItemLink   --> 缓存物品
		//send			--> pushItems函数，读取缓存物品，组合字符串
		//resive		--> analyisItems解析字符串，获取物品数据并缓存
		//buildItemLink --> 读取缓存物品，拼凑链接字符串
		//onTextLink	--> 点击后去guid发送查询请求
		//------------------------------------------------------------------------
		//聊天内容构造逻辑
		/**
		 * 聊天内容构造逻辑
		 * @param chatEntity
		 * @return
		 *
		 */
		public static function buildChatString(chatEntity:ChatData, model:ChatModel = null):String
		{
			var color:String;
			var header:String;
			var name:String;
			var content:String;
			color = ChatConst.getColorString(chatEntity.channelId);
			header = buildHeader(chatEntity, color);
			name = buildName(chatEntity, ChatConst.getNameColor(), model);
			analyisSimleys(chatEntity, model);
			content = buildContent(chatEntity, color);
			var prefixIngonarXML:String = (header + name).replace(/<.*?>/g, "");
			for each (var simley:Object in chatEntity.simleys)
			{
				simley.index += prefixIngonarXML.length;
			}
			return header + name + content;
		}

		private static function buildHeader(chatEntity:ChatData, color:String):String
		{
			if (chatEntity.senderId == 0 && !(chatEntity.channelId == ChatConst.CHANNEL_HEARSAY || chatEntity.channelId == ChatConst.CHANNEL_MUTUAL))
			{
				color = ChatConst.getColorString(ChatConst.CHANNEL_INFO);
			}
			return HtmlUtil.color(color, "[" + ChatConst.getChannelName(chatEntity.channelId) + "] ");
		}

		/**
		 * 构建名字
		 * @param chatEntity
		 * @param color
		 * @return
		 *
		 */
		private static function buildName(chatEntity:ChatData, color:String, model:ChatModel = null):String
		{
			if (chatEntity.isSystemMsg || chatEntity.senderId == 0 || chatEntity.channelId == ChatConst.CHANNEL_HEARSAY || chatEntity.channelId == ChatConst.CHANNEL_MUTUAL)
			{
				return ""; //系统提示
			}
			else
			{
				if (chatEntity.channelId == ChatConst.CHANNEL_PRIVATE)
				{
					var heroName:String = GameInstance.mainCharData.name;
					var linkStr:String;
					if (chatEntity.senderName == heroName)
					{
						linkStr = LanguageManager.translate(12011, "你对{0} 说：", HtmlUtil.link("name┆" + model.currentChatTarget + "┆0", model.currentChatTarget, false));
					}
					else
					{
						linkStr = LanguageManager.translate(12012, "{0} 对你说：", HtmlUtil.link("name┆" + chatEntity.senderName + "┆" + chatEntity.senderId, chatEntity.senderName, false));
					}
					return HtmlUtil.color(color, linkStr);
				}
				else
				{
					return LanguageManager.translate(12013, "{0} 说：", HtmlUtil.color(color, HtmlUtil.link("name┆" + chatEntity.senderName + "┆" + chatEntity.senderId, (chatEntity.isGM ? "[GM]" : "") +
						chatEntity.senderName, false)));
				}
			}
		}

		/**
		 * 构造聊天内容字符串（包括文本链接构造）
		 * @param chatEntity
		 * @param color
		 * @return
		 *
		 */
		private static function buildContent(chatEntity:ChatData, color:String):String
		{
			if (chatEntity.senderId == 0 && (chatEntity.channelId != ChatConst.CHANNEL_HEARSAY && chatEntity.channelId != ChatConst.CHANNEL_MUTUAL))
			{
				color = ChatConst.getColorString(ChatConst.CHANNEL_INFO);
			}
			if (chatEntity.channelId == ChatConst.CHANNEL_MUTUAL)
			{
				//交互频道显示内容额外获取
				return ChatMutualChannelProcesser.getChatStr(chatEntity.content, chatEntity.senderId, chatEntity.senderName, color);
			}
			else if (chatEntity.channelId == ChatConst.CHANNEL_HEARSAY)
			{
				return HtmlUtil.color(color, chatEntity.content);
			}
			else
			{
				//替换物品文字为文字链接
				var tempItems:Array = chatEntity.items.slice(); //item临时副本
				var tempSenderId:int = chatEntity.senderId; //id临时副本
				var reg:RegExp = /\[.*?\]/g;
				var contentWithItems:String = chatEntity.content.replace(reg, function():String
				{
					for (var i:int = 0; i < tempItems.length; ++i)
					{
						var matched:String = String(arguments[0]);
						var item:IChatLinkAdapter = IChatLinkAdapter(tempItems[i]);
						if ("[" + item.nameInput + "]" == matched /*matched*/)
						{
							var ret:String = buildItemLink(tempSenderId, item);
							tempItems.splice(i, 1);
							return ret;
						}
					}
					return arguments[0];
				});
				return HtmlUtil.color(color, contentWithItems);
			}
		}

		/**
		 * 构造数据链接
		 * @param goodsEntity
		 * @return
		 *
		 */
		private static function buildItemLink(senderId:int, objData:IChatLinkAdapter):String
		{
			return objData.buildItemLink(senderId);
		}

		/**
		 * 删除物品字符串并解析成ChatItemData对象列表
		 * @param chatEntity
		 *
		 */
		public static function analyisItems(chatData:ChatData, model:ChatModel = null):void
		{
			if (chatData.channelId != ChatConst.CHANNEL_MUTUAL) //当交互频道时不解析物品
			{
				chatData.items = [];
				var itemArray:Array = chatData.content.split("<");
				chatData.content = itemArray[0];
				var index:int = 1;
				while (index < itemArray.length)
				{
					var type:int = parseInt(itemArray[index]);
					++index;
					var itemData:IChatLinkAdapter = ChatLinkAdapterFactory.createByCententMask(type, itemArray, index, model.getChatLinkId());
					index += itemData.properNumInContent;
					chatData.items.push(itemData);
				}
			}
		}

		/**
		 * 将表情占位符解析成表情, 并替换占位符
		 * @param chatData
		 *
		 */
		public static function analyisSimleys(chatData:ChatData, model:ChatModel = null):void
		{
			chatData.contentPure = chatData.content;
			var result:Object = ChatStringHelper.analyisSimleys2(chatData.content);
			chatData.content = result.content;
			chatData.simleys = result.simleys;
//			var regex:RegExp = /#\w{2}/g;
//			while (true)
//			{
//				var match:Object = regex.exec(chatData.content);
//				if (!match)
//				{
//					break;
//				}
//				var shortcut:String = match[0];
//				var simleyObj:Object = model.getSmileyByShortCut(shortcut);
//				if (simleyObj)
//				{
//					chatData.content = StringUtil.removeAt(chatData.content, match.index, match.index + shortcut.length);
//					regex.lastIndex = 0;
//					chatData.simleys.push({src: simleyObj.src, index: match.index});
//				}
//			}
		}

		/**
		 *
		 * @param chatString
		 * @return 结果集，包含content、simleys两个属性
		 *
		 */
		public static function analyisSimleys2(chatString:String):Object
		{
			var regex:RegExp = /#\w{2}/g;
			var model:ChatModel = MainFacade.instance.inject.getInstance(ChatModel) as ChatModel;
			var resultObj:Object = {};
			resultObj.content = chatString;
			while (true)
			{
				var match:Object = regex.exec(resultObj.content);
				if (!match)
				{
					break;
				}
				var shortcut:String = match[0];
				var simleyObj:Object = model.getSmileyByShortCut(shortcut);
				if (simleyObj)
				{
					resultObj.content = StringUtil.removeAt(resultObj.content, match.index, match.index + shortcut.length);
					regex.lastIndex = 0;
					if (!resultObj.simleys)
					{
						resultObj.simleys = [];
					}
					resultObj.simleys.push({src: simleyObj.src, index: match.index});
				}
			}
			return resultObj;
		}

//		/**
//		 * 将表情占位符解析成表情
//		 * @param chatData
//		 *
//		 */
//		public static function analyisSimleys(chatData:ChatData):void
//		{
//			var textIngonarXML:String = chatData.contentBuilded.replace(/<.*?>/g, "");
//			var regex:RegExp = /:\w/;
//			while (true)
//			{
//				var match:Object = regex.exec(textIngonarXML);
//				if (!match)
//				{
//					break;
//				}
//				textIngonarXML = textIngonarXML.replace(regex, "");
//				var shortcut:String = match[0];
//				var simleyObj:Object = ChatModel.instance.getSmileyByShortCut(shortcut);
//				if (simleyObj)
//				{
//					chatData.simleys.push({src: simleyObj.src, index: match.index});
//				}
//			}
//			chatData.contentBuilded = chatData.contentBuilded.replace(/:\w/g, function():String
//			{
//				var shortcut:String = String(arguments[0]);
//				var simleyObj:Object = ChatModel.instance.getSmileyByShortCut(shortcut);
//				if (simleyObj)
//				{
//					return "";
//				}
//				else
//				{
//					return arguments[0];
//				}
//			});
//		}
		/**
		 * 将 {guId,name}对象列表 合并入字符串中
		 * @param chatEntity
		 *
		 */
		public static function pushItems(chatData:ChatData):void
		{
			for (var i:int = 0; i < chatData.items.length; i++)
			{
				var itemData:IChatLinkAdapter = chatData.items[i];
				chatData.content += itemData.buildContentLinkMask();
			}
		}

		/**
		 * 构造聊天字符串中的链接数据部分(用于和服务端通信)
		 * @param dataArray
		 * @return
		 *
		 */
		public static function makeLinkMaskStr(prefix:String, dataArray:Array):String
		{
			var ret:String = prefix;
			for each (var data:Object in dataArray)
			{
				ret += "<" + data;
			}
			return ret;
		}

		/**
		 * 构造聊天框链接中的参数(用于文本链接参数)
		 * @param dataArray
		 * @return
		 *
		 */
		public static function makeLinkParamMaskStr(prefix:String, dataArray:Array):String
		{
			var ret:String = "";
			for each (var data:Object in dataArray)
			{
				ret += "]" + data;
			}
			return prefix + ret;
		}
		private static const ITEM_TEXT_STYLE:Object = {bold: true, italic: false};

		/**
		 * 构造传言字符串
		 * @param format
		 * @param params
		 * @return
		 *
		 */
		public static function formatHearsay(format:String, params:Array):String
		{
			return format.replace(/%([0-9]+?)([dusi])/g, function():String
			{
				var index:int = parseInt(arguments[1]);
				var flag:String = String(arguments[2]);
				var ret:String;
				if (flag == "i") //替换物品名称
				{
					var templateId:int = parseInt(params[index]);
					if (templateId)
					{
						var template:ItemTemplate = ItemTemplateManager.instance.get(templateId);
						if (template)
						{
							var text:String = template.name;
							text = HtmlUtil.tag("font", [{key: "color", value: ItemQuality.getColorString(template.quality)}], text);
							if (ITEM_TEXT_STYLE.bold)
							{
								text = HtmlUtil.bold(text);
							}
							if (ITEM_TEXT_STYLE.italic)
							{
								text = HtmlUtil.italic(text);
							}
							ret = text;
						}
					}
				}
				else
				{
					ret = params[index];
				}
				return ret;
			});
		}

		/**
		 * 构造传言字符串（聊天框）
		 * @param format
		 * @param params
		 * @return
		 *
		 */
		public static function formatHearsayForChat(format:String, params:Array, itemParams:Array, trackLink:String, trackLinkName:String, hearsayTeamID:int, model:ChatModel = null):String
		{
			var itemIndexArray:Array = [];
			var index:int;
			var flag:String;
			var ret:String;
			var text:String = format.replace(/%([0-9]+?)([dusi])/g, function():String
			{
				index = parseInt(arguments[1]);
				flag = String(arguments[2]);
				switch (flag)
				{
					case "i": //提取物品链接占位符序号到数组
						if (itemIndexArray.indexOf(index) == -1)
							itemIndexArray.push(index);
						ret = arguments[0];
						break;
					default:
						ret = params[index];
						break;
				}
				return ret;
			});
			itemIndexArray.sort(); //排序物品链接占位符序号
			text = text.replace(/%([0-9]+?)([dusi])/g, function():String
			{
				index = parseInt(arguments[1]);
				flag = String(arguments[2]);
				switch (flag)
				{
					case "i": //替换物品名称占位符序号到数组

						var templateId:int = parseInt(params[index]);
						var template:ItemTemplate = ItemTemplateManager.instance.get(templateId);
						if (template)
						{
							//根据序号获取占位符索引
							var ii:int = itemIndexArray.indexOf(index);
							var itemParam:Object = itemParams[ii]; //通过索引取出链接数据
							if (!itemParam)
							{
								log.error("物品参数不足");
							}
							var text:String = template.name;
							//创建物品链接数据
							var itemLinkData:ChatItemLinkAdapter = new ChatItemLinkAdapter(ItemDataFactory.createByTemplate(itemParam.playerId, itemParam.itemId, template), model.getChatLinkId());
							text = buildItemLink(itemParam.playerId, itemLinkData);
							text = HtmlUtil.tag("font", [{key: "color", value: ItemQuality.getColorString(template.quality)}], text);
							if (ITEM_TEXT_STYLE.bold)
							{
								text = HtmlUtil.bold(text);
							}
							if (ITEM_TEXT_STYLE.italic)
							{
								text = HtmlUtil.italic(text);
							}
							ret = text;
						}
						else
						{
							log.error("formatHearsayForChat() 无效的物品模板id：" + params[index]);
							ret = arguments[0];
						}
						break;
					default:
						ret = arguments[0];
						break;
				}
				return ret;
			});
			var str:String;
			if (trackLink)
				str = trackLink;
			else
				str = ChatConst.LINK_PREFIX_APPLYING + "┆" + String(hearsayTeamID);
			text += HtmlUtil.link(str, HtmlUtil.color(ColorConst.green, trackLinkName));
			return text;
		}
	}
}
