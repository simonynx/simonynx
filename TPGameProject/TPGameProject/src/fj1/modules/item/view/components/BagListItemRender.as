package fj1.modules.item.view.components
{
	import fj1.common.GameInstance;
	import fj1.common.data.dataobject.items.ItemData;
	import fj1.common.res.guide.vo.GuideConfig;
//	import fj1.common.staticdata.GuideConst;
	import fj1.common.ui.boxes.BaseDataBox;
	import fj1.common.ui.boxes.BaseDataListItemRender;
//	import fj1.modules.guide.helper.GuideHelper;
//	import fj1.modules.guide.view.GuideView;
//	import fj1.modules.guide.view.GuideViewManager;
	import fj1.modules.item.view.components.BagDataBox;
	import fj1.modules.item.view.components.HeroBagPanel;
//	import fj1.modules.task.view.components.TaskNpcChatPanel;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	import tempest.ui.components.TListItemRender;

	public class BagListItemRender extends BaseDataListItemRender
	{
		private var _bagView:HeroBagPanel;
		private var _guideConfig:GuideConfig;

//		public var guideView:GuideView;

		public function BagListItemRender(_proxy:* = null, data:Object = null)
		{
			super(_proxy, data);
		}

		override protected function createBox():void
		{
			_dataBox = new BagDataBox(_proxy);
		}

		private function get bagView():HeroBagPanel
		{
			if (!_bagView)
			{
				var par:DisplayObject = this.parent;
				while (par)
				{
					if (par is HeroBagPanel)
					{
						break;
					}
					par = par.parent;
				}
				_bagView = par as HeroBagPanel;
			}
			return _bagView;
		}

		override public function set data(value:Object):void
		{
			super.data = value;
			var itemData:ItemData = ItemData(value);
			_changeWatcherManger.bindSetter(setGuide, itemData, "guideConfig");
		}

		private function setGuide(value:GuideConfig):void
		{
			if (_guideConfig == value)
			{
				return;
			}
			var oldValue:GuideConfig = _guideConfig;
			_guideConfig = value;
//			GameInstance.signal.item.itemDataGuideChanged.dispatch(oldValue, value, this);
		}
	}
}
