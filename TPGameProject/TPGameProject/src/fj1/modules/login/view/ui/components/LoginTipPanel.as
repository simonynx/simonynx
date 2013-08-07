package fj1.modules.login.view.ui.components
{
	import assets.UIRoleLib;

	import tempest.common.rsl.RslManager;

	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	import tempest.common.rsl.TRslManager;
	import tempest.ui.components.TComponent;

	public class LoginTipPanel extends TComponent
	{
		private var _tf:TextField;

		public function LoginTipPanel()
		{
			super({horizontalCenter: 0, verticalCenter: 0}, RslManager.getDefinition(UIRoleLib.ui_login_tip));
		}

		override protected function addChildren():void
		{
			_tf = _proxy.txt_label;
			_tf.multiline = false;
			_tf.selectable = false;
			_tf.autoSize = TextFieldAutoSize.CENTER;
		}

		public function setLabel(value:String, color:uint = 0xFFFFFF):void
		{
			_tf.text = value;
			_tf.textColor = color;
		}
	}
}
