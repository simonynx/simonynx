package fj1.common.ui
{
	import fj1.common.GameInstance;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;
	import tempest.common.keyboard.KeyCodes;
	import tempest.ui.TPUGlobals;
	import tempest.ui.components.TWindow;
	import tempest.utils.Geom;

	public class BaseWindow extends TWindow
	{
		public var switchToChatWhenEnter:Boolean = true;
		public static const LEAVE_DISTANCE:int = 3;
		/**
		 * 是否响应ESC键关闭
		 */
		public var escClose:Boolean = true;
		/**
		 *是否转换场景时关闭该窗口
		 */
		public var isChangeSceneClose:Boolean = false;
		/**
		 *是否切换线路时关闭该窗口
		 */
		public var isChangeLineClose:Boolean = true;

		public function BaseWindow(constraints:Object = null, _proxy:* = null, name:String = "")
		{
			super(constraints, _proxy, name);
			this.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		public function set isCacheAsBitmap(value:Boolean):void
		{
			cacheAsBitmap=value;
		}
		
		public function set isUseEffect(value:Boolean):void
		{
			useEffect=value;
		}

		private function onKeyDown(event:KeyboardEvent):void
		{
			if (switchToChatWhenEnter)
			{
				//窗口上点回车时，焦点切换到聊天框
				if (event.keyCode == KeyCodes.ENTER.keyCode && !(event.target is TextField))
				{
					TPUGlobals.stage.focus = TPUGlobals.stage;
				}
			}
		}

		/**
		 *检测窗口与交互距离
		 * @param baseWindow
		 * @param npc
		 *
		 */
		public function checkTalkDistance(position:Point, npcID:int = 0):void
		{
			if (this.isShow && position != null)
			{
				if (GameInstance.mainChar.inDistance(position, LEAVE_DISTANCE))
				{
					this.closeWindow();
				}
			}
			if (npcID != 0)
			{
				if (GameInstance.selectChar && GameInstance.selectChar.id == npcID)
				{
					GameInstance.selectChar = null;
				}
			}
		}
	}
}
