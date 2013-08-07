package fj1.modules.chat.model.chatlinkAdapters
{
	import fj1.common.staticdata.ChatConst;
	import fj1.common.staticdata.ItemQuality;
	import fj1.modules.chat.helper.ChatStringHelper;
	import fj1.modules.chat.model.interfaces.IChatLinkAdapter;
	import flash.geom.Point;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import tempest.engine.SceneCharacter;
	import tempest.engine.vo.map.MapTile;
	import tempest.engine.vo.move.MoveCallBack;
	import tempest.utils.HtmlUtil;

	public class ChatPositionLinkAdapter implements IChatLinkAdapter
	{
		public var id:int;
		public var mapName:String; //地图名字
		public var mapID:int;
		public var mapX:int;
		public var mapY:int;

		public function ChatPositionLinkAdapter(mapName:String, mapID:int, mapX:int, mapY:int)
		{
			this.mapName = mapName;
			this.mapID = mapID;
			this.mapX = mapX;
			this.mapY = mapY;
		}

		/**
		 * 通过聊天字符串中的链接数据部分，解析并创建IChatLinkAdapter实例
		 * @param paramArray
		 * @param index
		 * @param chatLinkId
		 * @return
		 *
		 */
		public static function createByCententMask(paramArray:Array, index:int, chatLinkId:int):ChatPositionLinkAdapter
		{
			var adapter:ChatPositionLinkAdapter = new ChatPositionLinkAdapter(String(paramArray[index]), parseInt(paramArray[index + 1]), parseInt(paramArray[index + 2]), parseInt(paramArray[index + 3]));
			adapter.id = chatLinkId;
			return adapter;
		}

		/**
		 * 通过聊天框链接中的参数，解析并创建IChatLinkAdapter实例
		 * @param paramArray
		 * @return
		 *
		 */
		public static function createByLinkParam(paramArray:Array):ChatPositionLinkAdapter
		{
			return new ChatPositionLinkAdapter(null, int(paramArray[0]), int(paramArray[1]), int(paramArray[2]));
		}

		public function buildItemLink(senderId:int):String
		{
			var link:String = HtmlUtil.link(ChatStringHelper.makeLinkParamMaskStr(ChatConst.LINK_PREFIX_POS, [mapID, mapX, mapY]),
				"【" + nameInput + "】", true);
			return link;
		}

		public function onTextLink():void
		{
//			MainCharWalkManager.heroWalk([mapID, new Point(mapX, mapY), 0], true, null);
		}

		public function buildContentLinkMask():String
		{
			return ChatStringHelper.makeLinkMaskStr("", [ChatConst.LINK_TYPE_POS, mapName, mapID, mapX, mapY]);
		}

		public function get properNumInContent():int
		{
			return 4;
		}

		public function get nameInput():String
		{
			return mapName + "(" + mapX + "," + mapY + ")";
		}
		private var _textLinkSignal:ISignal;

		public function get textLinkSignal():ISignal
		{
			return _textLinkSignal ||= new Signal();
		}
	}
}
