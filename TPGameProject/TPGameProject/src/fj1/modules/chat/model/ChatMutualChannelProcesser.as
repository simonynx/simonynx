package fj1.modules.chat.model
{
	import fj1.common.staticdata.ChatConst;

	import flash.utils.Dictionary;

	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;

	public class ChatMutualChannelProcesser
	{
		private static var log:ILogger = TLog.getLogger(ChatMutualChannelProcesser);
		private static var handlerDic:Dictionary = new Dictionary();

		/**
		 *
		 * @param type 类型
		 * @param resolveHandler 频道消息的显示函数，格式如：Function (type:String, senderId:int, senderName:String, color:String, params:Array):String
		 * 该回调函数返回的字符串中不能带有\t，否则将导致显示问题
		 *
		 */
		public static function registerMsgBuildHandler(type:String, resolveHandler:Function):void
		{
			handlerDic[type] = resolveHandler;
		}

		/**
		 * 解析交互聊天包，并分发处理
		 * 交互聊天包内容格式
		 * type<data1<data2<dataN
		 * @param pureData
		 * @param senderId
		 * @param senderName
		 * @param color
		 * @return
		 *
		 */
		public static function getChatStr(pureData:String, senderId:int, senderName:String, color:String):String
		{
			var dataArray:Array = pureData.split("<");
			var type:String = dataArray[0] as String;
			var params:Array = dataArray.slice(1);
			var handler:Function = handlerDic[type] as Function;
			if (handler == null)
			{
				log.error("无效的消息类型：type = " + type);
			}
			return handlerDic[type](type, senderId, senderName, color, params);
		}

		public static function buildLinkData(type:String, linkData:String):String
		{
			return ChatConst.LINK_PREFIX_MUTUAL + "]" + type + "]" + linkData;
		}
	}
}
