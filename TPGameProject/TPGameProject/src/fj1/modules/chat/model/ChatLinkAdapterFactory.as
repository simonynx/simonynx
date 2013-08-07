package fj1.modules.chat.model
{
	import fj1.common.staticdata.ChatConst;
	import fj1.modules.chat.model.chatlinkAdapters.ChatItemLinkAdapter;
	import fj1.modules.chat.model.chatlinkAdapters.ChatPositionLinkAdapter;
	import fj1.modules.chat.model.interfaces.IChatLinkAdapter;

	public class ChatLinkAdapterFactory
	{
		/**
		 * 通过聊天字符串中的物品数据部分，解析并创建IChatLinkAdapter实例
		 * @param type
		 * @param paramArray
		 * @param index
		 * @param chatLinkId
		 * @return
		 *
		 */
		public static function createByCententMask(type:int, paramArray:Array, index:int, chatLinkId:int):IChatLinkAdapter
		{
			switch (type)
			{
				case ChatConst.LINK_TYPE_ITEM:
					return ChatItemLinkAdapter.createByCententMask(paramArray, index, chatLinkId);
				case ChatConst.LINK_TYPE_POS:
					return ChatPositionLinkAdapter.createByCententMask(paramArray, index, chatLinkId);
				default:
					throw new Error("链接数据类型错误type = " + type);
					break;
			}
		}

		/**
		 * 通过聊天框链接中的参数，解析并创建IChatLinkAdapter实例
		 * @param type
		 * @param paramArray
		 * @return
		 *
		 */
		public static function createByLinkParam(type:String, paramArray:Array):IChatLinkAdapter
		{
			switch (type)
			{
				case ChatConst.LINK_PREFIX_ITEM:
					return ChatItemLinkAdapter.createByLinkParam(paramArray);
				case ChatConst.LINK_PREFIX_POS:
					return ChatPositionLinkAdapter.createByLinkParam(paramArray);
				default:
					throw new Error("链接数据类型错误type = " + type);
					break;
			}
		}
	}
}
