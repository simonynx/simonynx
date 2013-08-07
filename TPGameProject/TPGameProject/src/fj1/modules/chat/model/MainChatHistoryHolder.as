package fj1.modules.chat.model
{
	import fj1.common.GameInstance;
	import fj1.common.data.interfaces.IChatHistoryHolder;
	import fj1.common.staticdata.ChatConst;
	import fj1.modules.chat.helper.ChatStringHelper;
	import fj1.modules.chat.model.vo.ChatData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import tempest.ui.collections.TArrayCollection;

	[Event(name = "change", type = "flash.events.Event")]
	public class MainChatHistoryHolder extends EventDispatcher implements IChatHistoryHolder
	{
		/**
		 * 综合聊天记录
		 */
		public var allChatArray:TArrayCollection = new TArrayCollection();
		/**
		 * 世界聊天记录
		 */
		public var worldChatArray:TArrayCollection = new TArrayCollection();
		/**
		 * 队伍聊天记录
		 */
		public var teamChatArray:TArrayCollection = new TArrayCollection();
		/**
		 * 公会聊天记录
		 */
		public var gulldChatArray:TArrayCollection = new TArrayCollection();
		/**
		 * 附近聊天记录
		 */
		public var roundChatArray:TArrayCollection = new TArrayCollection();
		/**
		 * 私聊聊天记录
		 */
		public var privateChatArray:TArrayCollection = new TArrayCollection();
		/**
		 * 交互聊天记录
		 */
		public var mutualChatArray:TArrayCollection = new TArrayCollection();
		/**
		 * 传言聊天记录
		 */
		public var hearsayChatArray:TArrayCollection = new TArrayCollection();
		/**
		 * 战场聊天记录
		 */
		public var battleLandChatArray:TArrayCollection = new TArrayCollection();
		/**
		 * 当前显示窗口的聊天记录
		 */
		private var _currShowChat:TArrayCollection;
		/**
		 * 是否播放私聊按钮的光效
		 */
		public var isPlayPrivate:Boolean = false;
		private var _maxLine:int;
		private var model:ChatModel;

		public function MainChatHistoryHolder(maxLine:int = int.MAX_VALUE, model:ChatModel = null)
		{
			_maxLine = maxLine;
			this.model = model;
			super(this);
		}

		/**
		 * 当前显示窗口的聊天记录
		 */
		public function get currShowChat():TArrayCollection
		{
			return _currShowChat;
		}

		public function appendDialog(value:ChatData):void
		{
			/*************************根据聊天包的channelId来获取当前的聊天数组*********************************/
			/*************************如果是信息消息*********************************/
			if (value.channelId == ChatConst.CHANNEL_INFO)
			{
				addDialogToArray(value, allChatArray);
				addDialogToArray(value, worldChatArray);
				addDialogToArray(value, teamChatArray);
				addDialogToArray(value, gulldChatArray);
				addDialogToArray(value, roundChatArray);
				addDialogToArray(value, privateChatArray);
				addDialogToArray(value, mutualChatArray);
				addDialogToArray(value, hearsayChatArray);
				addDialogToArray(value, battleLandChatArray);
			}
			/*************************不是信息消息*********************************/
			else
			{
				if (value.channelId != ChatConst.CHANNEL_HEARSAY) //传言频道不显示在综合当中
				{
					addDialogToArray(value, allChatArray);
				}
				var chatArray:TArrayCollection = getChatArray(value.channelId);
				if (chatArray)
				{
					addDialogToArray(value, chatArray);
				}
			}
			//检测当前的消息是否是密聊，如果是且当前的输出频道不是密聊频道、发送者不是当前的玩家，那就令密聊播放光效，否则就不播放
			if (value.channelId == ChatConst.CHANNEL_PRIVATE && model.currentOutPutChannel != value.channelId && model.historyHolder.isPlayPrivate == false && GameInstance.mainCharData.
				name != value.senderName)
			{
				dialogAddedSignal.dispatch(true);
			}
//			dispatchEvent(new Event(Event.CHANGE));
		}
		private var _dialogAddedSignal:ISignal;

		public function get dialogAddedSignal():ISignal
		{
			return _dialogAddedSignal ||= new Signal();
		}

		/**
		 *
		 * @param value
		 *
		 */
		public function appendDialog2(value:ChatData):void
		{
			var chatArray:TArrayCollection = getChatArray(value.channelId);
			if (chatArray)
			{
				addDialogToArray(value, chatArray);
			}
		}

		private function addDialogToArray(chatHistoryData:ChatData, currentArray:TArrayCollection):void
		{
			if (currentArray.length >= _maxLine)
			{
				currentArray.removeItemAt(0);
			}
			currentArray.addItem(chatHistoryData);
		}

		public function get strHistory():String
		{
			return null;
		}

		/**
		 *当点击清除按钮的时候，清除当前频道的所有信息
		 */
		public function clean():void
		{
			_currShowChat.source = [];
		}

		public function switchCurrentChat(type:int):void
		{
			_currShowChat = getChatArray(type);
			dispatchEvent(new Event(Event.CHANGE));
		}

		/**
		 * 获取当前聊天窗口的聊天记录
		 */
		private function getChatArray(type:int):TArrayCollection
		{
			switch (type)
			{
				case ChatConst.CHANNEL_ALL:
					return allChatArray;
				case ChatConst.CHANNEL_HEARSAY:
					return hearsayChatArray;
				case ChatConst.CHANNEL_WORLD:
					return worldChatArray;
				case ChatConst.CHANNEL_TEAM:
					return teamChatArray;
				case ChatConst.CHANNEL_GUILD:
					return gulldChatArray;
				case ChatConst.CHANNEL_ROUND:
					return roundChatArray;
				case ChatConst.CHANNEL_PRIVATE:
					return privateChatArray;
				case ChatConst.CHANNEL_MUTUAL:
					return mutualChatArray;
				case ChatConst.CHANNEL_BATTLELAND:
					return battleLandChatArray;
				default:
					return null;
			}
		}
	}
}
