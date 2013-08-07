package fj1.common.res.chat
{
	import fj1.common.res.ResManagerHelper;
	import fj1.common.res.chat.vo.SmileyInfo;

	public class ChatSmileyConfigManager
	{
		private static var _smileysConfigArray:Array = [];

		/**
		 * 加载表情配置
		 * @param xmlData
		 * @return
		 *
		 */
		public static function load(xmlData:*):Boolean
		{
			_smileysConfigArray = ResManagerHelper.getArray(SmileyInfo, xmlData);
			return _smileysConfigArray != null;
		}

		public static function get smileysConfigArray():Array
		{
			return _smileysConfigArray;
		}
	}
}
