package fj1.modules.chat.model
{
	import fj1.common.GameInstance;
	import fj1.common.staticdata.ChatConst;
	import fj1.modules.chat.model.vo.ChatData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import tempest.common.time.vo.TimerData;
	import tempest.engine.vo.FunctionData;
	import tempest.manager.TimerManager;
	import tpm.magic.util.FrameUpdater;

	public class ChatHornHistoryHolder extends EventDispatcher
	{
		private var _chatHistoryList:Array;
		private var _maxLine:int;

		public function ChatHornHistoryHolder(maxLine:int = int.MAX_VALUE)
		{
			_chatHistoryList = [];
			_maxLine = maxLine;
			super(this);
		}

		public function get chatHistoryList():Array
		{
			return _chatHistoryList;
		}

		/**
		* 添加一句话
		* @param value
		*
		*/
		public function appendDialog(value:ChatData):void
		{
			if (!value)
				return;
			if (_chatHistoryList.length >= _maxLine)
			{
				//删除首个句子
				_chatHistoryList.shift();
			}
			_chatHistoryList.push(value); //添加当前句子
			FrameUpdater.instance.addFunctionData(new FunctionData(function():void
			{
				//删除首个句子
				_chatHistoryList.shift();
				dispatchEvent(new Event(Event.CHANGE));
			}, null, ChatConst.HORN_MSG_KEEP_TIME, 1, false));
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
}
