package fj1.modules.mainUI.view
{
	import fj1.common.res.hint.vo.HintData;
	import fj1.common.staticdata.HintConst;
	import fj1.manager.MessageManager;
	import fj1.modules.mainUI.model.MainUIModel;
	import fj1.modules.mainUI.service.MainUIService;
	import fj1.modules.mainUI.signal.MainUISignal;
	import fj1.modules.mainUI.view.components.MainUI;
	
	import tempest.common.mvc.base.Mediator;

	public class MainUIMediator extends Mediator
	{
		[Inject]
		public var view:MainUI;
		[Inject]
		public var model:MainUIModel;
		[Inject]
		public var signal:MainUISignal;
		[Inject]
		public var service:MainUIService;

		public function MainUIMediator()
		{
			super();
		}

		public override function onRegister():void
		{
			//注册提示显示处理函数
//			MessageManager.registerChatShower(HintConst.HINT_PLACE_BULLETIN, onSysMsgAreaShow);
			MessageManager.registerChatShower(HintConst.HINT_PLACE_SCROLL_HINT, onScrollHintShow);
//			MessageManager.registerChatShower(HintConst.HINT_PLACE_SCROLL_HINT2, onScrollHintShow2);
			MessageManager.registerChatShower(HintConst.HINT_PLACE_SCROLL_HINT3, onScrollHintShow3);
//			MessageManager.registerChatShower(HintConst.HINT_PLACE_CHAT, onChatShow);
//			MessageManager.registerChatShower(HintConst.HINT_PLACE_GUARDWALLOW, showGuardWallow);
//			MessageManager.registerChatShower(HintConst.HINT_PLACE_BOTTOM, onBottomScrollHintShow);
//			MessageManager.registerChatShower(HintConst.HINT_PLACE_BOTTOM2, onBottomScrollTaskHintShow);
//			MessageManager.registerChatShower(HintConst.HINT_SCRPT_TOPCENTER, onScriptScrollHintShow);
		}
		
		private function onScrollHintShow(hintData:HintData):void
		{
			view.centerFlyTextArea.addText(hintData.content);
		}
		
		private function onScrollHintShow3(hintData:HintData):void
		{
			view.centerFlyTextArea3.addText(hintData.content);
		}

		public override function onRemove():void
		{
		}
	}
}
