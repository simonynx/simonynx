package fj1.modules.friend.view.components.renders
{
	import fj1.common.staticdata.MenuOperationType;
	import fj1.modules.friend.model.vo.FriendInfo;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.natives.NativeSignal;

	import tempest.ui.components.MenuListItemRender;
	import tempest.ui.components.TListItemRender;
	import tempest.ui.components.TWindow;

	public class FriendListItemRender extends BaseSociatyListItemRender
	{
		public var lbl_name:TextField;
		public var lbl_level:TextField;

		public function FriendListItemRender(_proxy:* = null, data:Object = null)
		{
			super(_proxy, data);
			this.useDoubleClick = true;
		}

		override protected function addChildren():void
		{
			super.addChildren();
			lbl_name = _proxy.lbl_name;
			lbl_level = _proxy.lbl_level;
		}

		override public function set data(value:Object):void
		{
			// TODO Auto Generated method stub
			super.data = value;
			if (value)
			{
				var friendInfo:FriendInfo = FriendInfo(value);
				_changeWatcherManger.bindSetter(setOnlineState, friendInfo, "online", false);
				lbl_name.text = String(data.name);
				lbl_level.text = int(data.level).toString();
			}
			else
			{
				lbl_name.text = "";
				lbl_level.text = "";
				_changeWatcherManger.bindSetter(setOnlineState, null, "online", false);
			}
		}

		private function setOnlineState(value:Boolean):void
		{
			//改变颜色
			if (value)
			{
				setTextFormat(lbl_name, BaseSociatyListItemRender.whiteFormat);
				setTextFormat(lbl_level, BaseSociatyListItemRender.whiteFormat);
			}
			else
			{
				setTextFormat(lbl_name, BaseSociatyListItemRender.grayFormat);
				setTextFormat(lbl_level, BaseSociatyListItemRender.grayFormat);
			}
		}
	}
}
