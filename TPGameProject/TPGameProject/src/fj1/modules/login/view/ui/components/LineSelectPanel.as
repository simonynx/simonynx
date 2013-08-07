package fj1.modules.login.view.ui.components
{
	import assets.UIRoleLib;

	import fj1.common.GameConfig;
	import tempest.common.rsl.RslManager;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import tempest.common.rsl.TRslManager;
	import tempest.ui.components.TButton;
	import tempest.ui.components.TComponent;
	import tempest.ui.components.TList;
	import tempest.ui.components.TListItemRender;
	import tempest.ui.events.ListEvent;

	public class LineSelectPanel extends TComponent
	{
		public var lineList:TList;
		public var btn_selectLine:TButton;
		private var _onSelectLine:ISignal;

		public function LineSelectPanel()
		{
			super({horizontalCenter: 0, verticalCenter: 0}, RslManager.getDefinition(UIRoleLib.ui_server_select));
		}

		override protected function addChildren():void
		{
			lineList = new TList(null, _proxy.mc_severList, null, LineListItem, null, null);
			lineList.addEventListener(ListEvent.ITEM_RENDER_CREATE, onItemRenderCreate);
			btn_selectLine = new TButton(null, _proxy.btn_enter, null, function(e:Event):void
			{
				onSelectLine.dispatch(lineList.selectedItem);
			});
		}

		private function onItemRenderCreate(event:ListEvent):void
		{
			var itemRender:TListItemRender = event.data as TListItemRender;
			itemRender.useDoubleClick = true;
			itemRender.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
		}

		private function onDoubleClick(event:MouseEvent):void
		{
			onSelectLine.dispatch(lineList.selectedItem);
		}

		public function get onSelectLine():ISignal
		{
			return _onSelectLine ||= new Signal();
		}
	}
}
