package fj1.modules.login.view.ui.components
{
	import assets.UIRoleLib;

	import tempest.common.rsl.RslManager;
	import fj1.common.staticdata.ServerState;
	import fj1.common.vo.line.LineInfo;

	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.text.TextField;

	import tempest.common.rsl.TRslManager;
	import tempest.ui.components.TListItemRender;
	import tempest.utils.Fun;

	public class LineListItem extends TListItemRender
	{
		private var lbl_serverState:TextField;

		public function LineListItem(proxy:* = null, data:Object = null)
		{
			super(RslManager.getDefinition(UIRoleLib.ServerListItem), data);
			lbl_serverState = _proxy.lbl_serverState;
		}

		public override function set data(value:Object):void
		{
			super.data = value;
			updateLable();
		}

		private function updateLable():void
		{
			lbl_serverState.htmlText = "";
			if (data && data.hasOwnProperty("name") && data.hasOwnProperty("state"))
			{
				lbl_serverState.htmlText = data.name + ServerState.getStateStr(data.state);
				lbl_serverState.textColor = ServerState.getStateColor(data.state);
			}
		}
	}
}
