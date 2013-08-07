package fj1.modules.chat.model.chatlinkAdapters
{
	import fj1.common.data.dataobject.items.ItemData;
	import fj1.common.staticdata.ChatConst;
	import fj1.common.staticdata.ItemQuality;
	import fj1.modules.chat.helper.ChatStringHelper;
	import fj1.modules.chat.model.interfaces.IChatLinkAdapter;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import tempest.ui.TPUGlobals;
	import tempest.utils.HtmlUtil;

	public class ChatItemLinkAdapter implements IChatLinkAdapter
	{
		public var itemGuid:int;
		public var name:String;
		public var quality:int;
		public var id:int;
		public var type:int;
		public var templateId:int;
		public var bind:int;
		public var senderId:int;

		public function ChatItemLinkAdapter(itemData:ItemData, linkId:int)
		{
			if (itemData)
			{
				this.itemGuid = itemData.guId;
				this.name = itemData.itemTemplate.name;
				this.quality = itemData.quality;
				this.type = itemData.itemTemplate.type;
				this.templateId = itemData.templateId;
				this.bind = itemData.playerBinded ? 1 : 0;
			}
			id = linkId;
		}

		/**
		 * 通过聊天字符串中的物品数据部分，解析并创建IChatLinkAdapter实例
		 * @param paramArray
		 * @param index
		 * @param chatLinkId
		 * @return
		 *
		 */
		public static function createByCententMask(paramArray:Array, index:int, chatLinkId:int):ChatItemLinkAdapter
		{
			var adapter:ChatItemLinkAdapter = new ChatItemLinkAdapter(null, chatLinkId);
			adapter.itemGuid = parseInt(paramArray[index] as String);
			adapter.name = paramArray[index + 1] as String;
			adapter.quality = parseInt(paramArray[index + 2]);
			adapter.type = parseInt(paramArray[index + 3]);
			adapter.templateId = parseInt(paramArray[index + 4]);
			adapter.bind = parseInt(paramArray[index + 5]);
			return adapter;
		}

		/**
		 * 通过聊天框链接中的参数，解析并创建IChatLinkAdapter实例
		 * @param paramArray
		 * @return
		 *
		 */
		public static function createByLinkParam(paramArray:Array):ChatItemLinkAdapter
		{
			var adapter:ChatItemLinkAdapter = new ChatItemLinkAdapter(null, int(paramArray[2]));
			adapter.senderId = int(paramArray[0]);
			adapter.itemGuid = int(paramArray[1]);
			adapter.type = int(paramArray[3]);
			adapter.templateId = int(paramArray[4]);
			adapter.bind = int(paramArray[5]);
			return adapter;
		}

		public function get nameInput():String
		{
			return name;
		}

		public function get properNumInContent():int
		{
			return 6;
		}

		public function isBind():Boolean
		{
			return bind > 0;
		}

		public function buildContentLinkMask():String
		{
			return ChatStringHelper.makeLinkMaskStr("", [ChatConst.LINK_TYPE_ITEM, itemGuid, name, quality, type, templateId, bind]);
		}

		public function buildItemLink(senderId:int):String
		{
			var link:String = HtmlUtil.link(ChatStringHelper.makeLinkParamMaskStr(ChatConst.LINK_PREFIX_ITEM, [senderId, itemGuid, id, type, templateId, bind]), "【" + name + "】", true);
			return HtmlUtil.color(ItemQuality.getColorString(quality), link, false);
		}

		public function onTextLink():void
		{
			textLinkSignal.dispatch(senderId, itemGuid, id, type, templateId, bind, TPUGlobals.stage.mouseX, TPUGlobals.stage.mouseY);
		}
		private var _textLinkSignal:ISignal;

		public function get textLinkSignal():ISignal
		{
			return _textLinkSignal ||= new Signal();
		}
	}
}
