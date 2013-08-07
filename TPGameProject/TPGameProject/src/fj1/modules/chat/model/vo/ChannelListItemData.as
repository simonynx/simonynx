package fj1.modules.chat.model.vo
{
	import fj1.common.staticdata.ChatConst;

	public class ChannelListItemData
	{
		public var channelId:int;

		public function ChannelListItemData(channelId:int)
		{
			this.channelId = channelId;
		}

		public function get label():String
		{
			return ChatConst.getChannelName(channelId);
		}
	}
}
