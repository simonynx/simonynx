package fj1.modules.chat.view
{
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.GTweener;
	import fj1.common.staticdata.ChatConst;
	import fj1.modules.chat.model.ChatModel;
	import fj1.modules.chat.model.vo.ChatData;
	import fj1.modules.chat.singles.ChatSignal;
	import fj1.modules.chat.view.components.HornPanel;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TextEvent;
	import tempest.common.mvc.base.Mediator;
	import tempest.utils.ListenerManager;

	public class HornPanelMediator extends Mediator
	{
		[Inject]
		public var signal:ChatSignal;
		[Inject]
		public var model:ChatModel;
		[Inject]
		public var view:HornPanel;
		private var _listenerManager:ListenerManager;

		public function HornPanelMediator()
		{
			super();
			_listenerManager = new ListenerManager();
		}

		public override function onRegister():void
		{
			_listenerManager.addEventListener(model.hornHistoryHolder, Event.CHANGE, onHistoryChange);
			_listenerManager.addEventListener(view.rtf_chat_content.textfield, TextEvent.LINK, onTextLink);
			_listenerManager.addSignal(signal.playNormalEffect, playNormalEffect);
		}

		/**
		 * 文本链接
		 * @param event
		 *
		 */
		private function onTextLink(event:TextEvent):void
		{
			model.onTextLink(event, view);
		}

		private function onHistoryChange(event:Event):void
		{
			view.rtf_chat_content.clear();
			removeHornEffect();
			for each (var chatData:ChatData in model.hornHistoryHolder.chatHistoryList)
			{
				view.rtf_chat_content.append(chatData.contentBuilded, chatData.simleys, true);
			}
		}

		/**
		 *播放號角光效
		 * @param id
		 *
		 */
		private function playNormalEffect(id:int):void
		{
			removeHornEffect();
			view.addChild(view.mc_word_effect);
			var $id:int = id;
			var callBack:Function = function(type:int):void
			{
				view.mc_word_effect.mc_effect.gotoAndPlay(1);
				view.mc_word_effect.addEventListener(Event.ENTER_FRAME, function onFrame(event:Event):void
				{
					var mc:MovieClip = event.target as MovieClip;
					if (view.mc_word_effect.mc_effect.currentFrame == view.mc_word_effect.mc_effect.totalFrames)
					{
						view.mc_word_effect.mc_effect.stop();
						if (view.mc_word_effect.parent)
						{
							view.mc_word_effect.parent.removeChild(view.mc_word_effect);
						}
						if (type == ChatConst.CHANNEL_SUPERHORN)
						{
							view.bg.visible = true;
							view.bg.gotoAndPlay(1);
							GTweener.to(view.bg, ChatConst.HORN_EFECT_TIME, null, {onComplete: function(gt:GTween):void
							{
								view.bg.stop();
								view.bg.visible = false;
							}});
						}
						view.mc_word_effect.removeEventListener(Event.ENTER_FRAME, onFrame);
					}
				});
			}
			callBack($id);
		}

		private function removeHornEffect():void
		{
			if (view.mc_word_effect.parent)
			{
				view.mc_word_effect.mc_effect.stop();
				view.removeChild(view.mc_word_effect);
			}
			view.bg.stop();
			view.bg.visible = false;
		}

		public override function onRemove():void
		{
			_listenerManager.removeAll();
		}
	}
}
