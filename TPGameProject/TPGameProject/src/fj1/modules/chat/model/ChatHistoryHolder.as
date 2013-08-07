package fj1.modules.chat.model
{
	import fj1.common.data.interfaces.IChatHistoryHolder;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import tempest.ui.events.DataEvent;

	[Event(name = "data", type = "tempest.ui.events.DataEvent")]
	public class ChatHistoryHolder extends EventDispatcher implements IChatHistoryHolder
	{
		protected var _strHistory:String;
		protected var _strLineLenVec:Vector.<int>;
		protected var _maxLine:int;

		public function ChatHistoryHolder(maxLine:int = int.MAX_VALUE)
		{
			_strHistory = "";
			_maxLine = maxLine;
			_strLineLenVec = new Vector.<int>();
			super(this);
		}

		/**
		 * 添加一句话
		 * @param value
		 *
		 */
		public function appendDialog(value:String):void
		{
			if (!value)
				return;
			if (_strLineLenVec.length >= _maxLine)
			{
				//删除首个句子
				removeFirst();
			}
			//添加当前句子
			addDialog(value);
			dispatchEvent(new Event(Event.CHANGE));
		}

		protected function removeFirst():void
		{
			var len:int = _strLineLenVec.shift();
			if (len == _strHistory.length)
			{
				_strHistory = "";
			}
			else
			{
				_strHistory = _strHistory.substr(len + 1);
			}
		}

		protected function addDialog(value:String):void
		{
			_strHistory += _strHistory == "" ? value : "\n" + value;
			_strLineLenVec.push(value.length);
		}

		/**
		 *
		 * @return
		 *
		 */
		public function get strHistory():String
		{
			return _strHistory;
		}

		public function clean():void
		{
			_strHistory = "";
			_strLineLenVec = new Vector.<int>();
			dispatchEvent(new DataEvent(DataEvent.DATA, _strHistory));
		}
	}
}
