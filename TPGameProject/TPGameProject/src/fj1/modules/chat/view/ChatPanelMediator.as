package fj1.modules.chat.view
{
	import fj1.common.staticdata.ChatConst;
	import fj1.modules.chat.model.ChatModel;
	import fj1.modules.chat.model.vo.ChatData;
	import fj1.modules.chat.singles.ChatSignal;
	import fj1.modules.chat.view.components.ChatPanel;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import tempest.common.mvc.base.Mediator;
	import tempest.common.time.vo.TimerData;
	import tempest.manager.TimerManager;
	import tempest.ui.components.TRadioButton;
	import tempest.utils.ListenerManager;

	public class ChatPanelMediator extends Mediator
	{
		[Inject]
		public var signal:ChatSignal;
		[Inject]
		public var model:ChatModel;
		[Inject]
		public var view:ChatPanel;
		//
		private var timerData:TimerData;
		private var _listenerManager:ListenerManager;

		public function ChatPanelMediator()
		{
			super();
			_listenerManager = new ListenerManager();
		}

		public override function onRegister():void
		{
			addSignal(signal.playPrivateEffect, playPrivateEffect);
			model.historyHolder.addEventListener(Event.CHANGE, onChange);
			view.tlist2_chat_content.dataProvider = model.historyHolder.currShowChat;
			_listenerManager.addEventListener(view.btn_clean, MouseEvent.CLICK, onClean);
			_listenerManager.addEventListener(view.rbtn_channel_normal, Event.CHANGE, onChannelChange);
			_listenerManager.addEventListener(view.rbtn_channel_world, Event.CHANGE, onChannelChange);
			_listenerManager.addEventListener(view.rbtn_channel_team, Event.CHANGE, onChannelChange);
			_listenerManager.addEventListener(view.rbtn_channel_guild, Event.CHANGE, onChannelChange);
			_listenerManager.addEventListener(view.rbtn_channel_round, Event.CHANGE, onChannelChange);
			_listenerManager.addEventListener(view.rbtn_channel_private, Event.CHANGE, onChannelChange);
			_listenerManager.addEventListener(view.rbtn_channel_mutual, Event.CHANGE, onChannelChange);
			_listenerManager.addEventListener(view.rbtn_channel_hearsay, Event.CHANGE, onChannelChange);
			_listenerManager.addEventListener(view.rbtn_channel_battleLand, Event.CHANGE, onChannelChange);
			//
			timerData = TimerManager.createNormalTimer(100, 0, function():void
			{
				if (timerData.currentCount % 2 == 0)
				{
					view.rbtn_channel_private.goToFrame(1);
				}
				else
				{
					view.rbtn_channel_private.goToFrame(3);
				}
			}, null, null, null, false);
		}

		private function onChange(event:Event):void
		{
			view.tlist2_chat_content.dataProvider = model.historyHolder.currShowChat;
		}

		private function onClean(event:Event):void
		{
			model.historyHolder.clean();
		}

		/**
		 * 播放密聊光效
		 */
		private function playPrivateEffect(isPlay:Boolean):void
		{
			if (isPlay)
			{
				timerData.start();
				model.historyHolder.isPlayPrivate = true;
			}
			else
			{
				timerData.stop();
				model.historyHolder.isPlayPrivate = false;
			}
		}

		private function onChannelChange(event:Event):void
		{
			var bt:TRadioButton = event.currentTarget as TRadioButton;
			if (bt.selected)
			{
				model.currentOutPutChannel = bt.data as int;
				/*********************如果选中的是密聊频道，那就令密聊的选中状态为true，否则为false***************************/
				if (model.currentOutPutChannel == ChatConst.CHANNEL_PRIVATE)
				{
					signal.playPrivateEffect.dispatch(false);
				}
				//获取当前要输出窗口的聊天记录
				model.historyHolder.switchCurrentChat(model.currentOutPutChannel);
				//切换聊天输入频道
				if (model.currentOutPutChannel != ChatConst.CHANNEL_ALL
					&& model.currentOutPutChannel != ChatConst.CHANNEL_MUTUAL
					&& model.currentOutPutChannel != ChatConst.CHANNEL_HEARSAY)
				{
					model.setInputChannel(model.currentOutPutChannel);
				}
			}
		}

		public override function onRemove():void
		{
			_listenerManager.removeAll();
		}
	}
}
