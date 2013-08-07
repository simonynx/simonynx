package fj1.modules.messageBox.view.components
{
	import fj1.common.GameInstance;
	import fj1.common.res.lan.LanguageManager;
	import fj1.manager.FloatIconManager;
	import fj1.modules.messageBox.model.vo.MessageInfo;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import tempest.ui.collections.TArrayCollection;
	import tempest.ui.components.TButton;
	import tempest.ui.components.TListItemRender;

	public class MessageListItemRander extends TListItemRender
	{
		private var lbl_name:TextField;
		private var lbl_content:TextField;
		public var btn_agree:TButton;
		public var btn_repulse:TButton;
		public var messageInfo:MessageInfo;

		public function MessageListItemRander(proxy:* = null, data:Object = null)
		{
			super(proxy, data);
		}

		override protected function addChildren():void
		{
			lbl_name = _proxy.lbl_name;
			lbl_content = _proxy.lbl_content;
			btn_agree = new TButton(null, _proxy.btn_agree, LanguageManager.translate(33000, "同意"));
			btn_repulse = new TButton(null, _proxy.btn_repulse, LanguageManager.translate(33001, "拒绝"));
		}

		override public function set data(value:Object):void
		{
			super.data = value;
			messageInfo = MessageInfo(value);
			lbl_name.text = messageInfo.name;
			lbl_content.text = messageInfo.messageStr;
		}
	}
}
