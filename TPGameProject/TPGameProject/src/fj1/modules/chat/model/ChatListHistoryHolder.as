package fj1.modules.chat.model
{
	import fj1.common.data.interfaces.IChatHistoryHolder;

	import flash.events.EventDispatcher;

	import tempest.ui.collections.TArrayCollection;

	public class ChatListHistoryHolder extends EventDispatcher implements IChatHistoryHolder
	{
		private var _maxLine:int;
		private var _historyList:TArrayCollection;

		public function ChatListHistoryHolder(maxLine:int)
		{
			_maxLine = maxLine;
			_historyList = new TArrayCollection();
		}

		public function clean():void
		{
			_historyList.source = [];
		}

		public function appendDialog(value:String):void
		{
			if (_historyList.length >= _maxLine)
			{
				_historyList.removeItemAt(0);
			}
			_historyList.addItem(value);
		}

		public function get historyList():TArrayCollection
		{
			return _historyList;
		}

		public function get strHistory():String
		{
			return null;
		}

	}
}
