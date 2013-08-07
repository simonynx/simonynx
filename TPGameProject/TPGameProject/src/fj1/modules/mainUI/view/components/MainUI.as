package fj1.modules.mainUI.view.components
{
	import flash.text.TextFormat;
	
	import fj1.common.res.layoutDesign.LayoutDesignManager;
	import fj1.common.staticdata.LayoutDesignConst;
	import fj1.common.ui.factories.AutoHideTextFieldFactory;
	import fj1.modules.chat.view.components.MainChatPanel;
	import fj1.modules.mainUI.hintAreas.MainUIFlyTextArea;
	
	import tempest.ui.components.TComponent;
	import tempest.ui.components.TLayoutContainer;

	public class MainUI extends TLayoutContainer
	{
		public var mainContainer:TLayoutContainer = new TLayoutContainer({left: 0, right: 0, top: 0, bottom: 0});
		public var panelContainer:TLayoutContainer=new TLayoutContainer({left: 0, right: 0, top: 0, bottom: 0});
		public var messageContainer:TLayoutContainer = new TLayoutContainer({left: 0, right: 0, top: 0, bottom: 0});
		//面板层
		public var mainChatPanel:MainChatPanel = new MainChatPanel(); //聊天窗口
		//提示
		public var centerFlyTextArea:MainUIFlyTextArea; //中央滚动文字
		public var centerFlyTextArea3:MainUIFlyTextArea; //中央滚动文字3

		public function MainUI()
		{
			super({left: 0, right: 0, top: 0, bottom: 0});
			panelContainer.childAutoTopEnabled=true;
		}

		protected override function addChildren():void
		{
			addChild(mainContainer); //主容器
			addChild(panelContainer); //面板容器
			addChild(messageContainer); //消息容器
			initHintPanels();
			addPanel(mainChatPanel);
		}
		
		public function addUI(ui:*):void
		{
			panelContainer.addChild(ui);
		}
		
		public function removeUI(ui:*):void
		{
			if (ui.parent)
			{
				panelContainer.removeChild(ui);
			}
		}

		/**
		 * 添加面板(底层)
		 * @param panel
		 *
		 */
		public function addPanel(panel:*):void
		{
			mainContainer.addChild(panel);
		}

		/**
		 *移除面板
		 * @param panel
		 *
		 */
		public function removePanel(panel:*):void
		{
			if (panel.parent)
			{
				mainContainer.removeChild(panel);
			}
		}

		/**
		 * 添加面板(顶层)
		 * @param panel
		 *
		 */
		public function addMessagePanel(panel:*):void
		{
			messageContainer.addChild(panel);
		}
		
		/**
		 * 初始化提示窗口
		 *
		 */
		private function initHintPanels():void
		{
			//中央滚动文字
			centerFlyTextArea=new MainUIFlyTextArea(null, LayoutDesignManager.getConstraintsByID(LayoutDesignConst.PANEL_CENTERFLYTEXTAREA), 4, 100, 5, new AutoHideTextFieldFactory(new TextFormat("Microsoft Yahei", 13, 0x00FF00)));
			addUIPierceable(centerFlyTextArea);
			//中央滚动文字3
			centerFlyTextArea3=new MainUIFlyTextArea(null, LayoutDesignManager.getConstraintsByID(LayoutDesignConst.PANEL_CENTERFLYTEXTAREA3), 4, 100, 5, new AutoHideTextFieldFactory(new TextFormat("宋体", 14, 0xFFFF00, true)));
			addUIPierceable(centerFlyTextArea3);
		}
		
		/**
		 * 添加可透过，并置顶的组件到UI层
		 * @param comp
		 *
		 */
		private function addUIPierceable(comp:TComponent):void
		{
			comp.mouseChildren=comp.mouseEnabled=false;
			comp.autoTopPriority=1;
			addUI(comp);
		}
	}
}
