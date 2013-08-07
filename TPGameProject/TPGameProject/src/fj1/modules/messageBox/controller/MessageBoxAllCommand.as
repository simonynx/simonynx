package fj1.modules.messageBox.controller
{
	import fj1.common.GameInstance;
	import fj1.common.ui.BaseWindow;
	import fj1.common.ui.TWindowManager;
	import fj1.manager.FloatIconManager;
	import fj1.modules.messageBox.model.MessageModel;
	import fj1.modules.messageBox.view.components.MessagePanel;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import tempest.common.mvc.base.Command;
	import tempest.ui.collections.TArrayCollection;

	public class MessageBoxAllCommand extends Command
	{
		[Inject]
		public var model:MessageModel;

		override public function getHandle():Function
		{
			return this.messageBoxAll;
		}

		/**
		 *  全部拒绝和全部取消处理
		 * @param messageArr 数据源
		 * @param result 结果 拒绝或取消
		 * @param panelName 消息盒子窗口名字
		 *
		 */
		private function messageBoxAll(messageArr:TArrayCollection, result:int, panelName:String):void
		{
			model.delAll(messageArr, result);
			if (messageArr.length == 0)
			{
				var mc:MovieClip = FloatIconManager.instance.myImgArea.getChildByName(panelName) as MovieClip;
				if (mc)
				{
					FloatIconManager.instance.myImgArea.delArr(mc);
					FloatIconManager.instance.myImgArea.removeChild(mc);
				}
			}
			if (TWindowManager.instance.findPopup(MessagePanel.NAME))
			{
				var obj:* = TWindowManager.instance.findPopup(MessagePanel.NAME)
				obj.closeWindow();
			}
		}
	}
}
