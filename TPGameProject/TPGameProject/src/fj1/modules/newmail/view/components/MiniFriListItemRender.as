package fj1.modules.newmail.view.components
{
	import flash.text.TextField;
	import tempest.ui.components.TListItemRender;

	public class MiniFriListItemRender extends TListItemRender
	{
		public var lbl_name:TextField;

		public function MiniFriListItemRender(proxy:* = null, data:Object = null)
		{
			super(proxy, data);
		}

		override protected function addChildren():void
		{
			super.addChildren();
			lbl_name = _proxy.lbl_name;
		}

		override public function set data(value:Object):void
		{
			super.data = value;
			if (value)
			{
				_proxy.lbl_name.text = String(data.name);
			}
		}
	}
}
