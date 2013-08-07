package fj1.modules.chat.model.vo
{

	public class ChatData
	{
//		private var _chatLineId:int;
		public var channelId:int;
		public var senderId:int;
		public var senderName:String;
		public var content:String;
		public var items:Array = []; //{name:nameStr,data:IChatSendable,guid:guid}
		public var isSystemMsg:Boolean = false;
		public var fullChatString:String
		public var isGM:Boolean = false;
		public var simleys:Array = [];
		public var contentBuilded:String;
		public var contentPure:String; //玩家输入的原始文本

		public function ChatData()
		{
//			_chatLineId = chatLineId;
		}
//		public function get chatLineId():int
//		{
//			return _chatLineId;
//		}
	}
}
