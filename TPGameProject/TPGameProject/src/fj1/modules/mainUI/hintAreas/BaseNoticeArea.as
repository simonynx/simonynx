package fj1.modules.mainUI.hintAreas
{
	import assets.UISkinLib;

	import fj1.common.ui.boxes.BaseDataListItemRender;

	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;

	import tempest.common.rsl.TRslManager;
	import tempest.ui.UIConst;
	import tempest.ui.collections.TArrayCollection;
	import tempest.ui.components.TComponent;
	import tempest.ui.components.TList;
	import tempest.ui.components.TListItemRender;
	import tempest.ui.events.CollectionEvent;
	import tempest.ui.events.ListEvent;

	/**
	 * 提示区域 和
	 * @author linxun
	 *
	 */
	public class BaseNoticeArea extends TComponent
	{
		private var _noteList:TList;
		private var _noticeDataList:TArrayCollection;
		private var _listType:String
		private var _parent:DisplayObjectContainer;

		public function BaseNoticeArea(parent:DisplayObjectContainer, constraints:Object, noticeType:int, listType:String)
		{
			_parent = parent;
			_noticeDataList = NoticeManager.getNoticeList(noticeType);
			_noticeDataList.addEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChange);
			_listType = listType;
			super(constraints, null);

			onCollectionChange(null);
		}

		private function onCollectionChange(event:CollectionEvent):void
		{
			if (_noticeDataList.length != 0 && !this.parent)
			{
				if (_parent)
				{
					_parent.addChild(this);
				}
			}
			else if (_noticeDataList.length == 0 && this.parent)
			{
				if (_parent)
				{
					_parent.removeChild(this);
				}
			}
		}

		override protected function addChildren():void
		{
			super.addChildren();
			_noteList = new TList(null, null, null, BaseDataListItemRender, TRslManager.getDefinition(UISkinLib.itemBoxSkin), [], false);
			_noteList.dataProvider = _noticeDataList;
			_noteList.addEventListener(ListEvent.ITEM_RENDER_CREATE, onItemRenderCreate);
			_noteList.type = _listType;
			if (_noteList.type == UIConst.VERTICAL)
			{
				_noteList.fixedHeight = -1;
			}
			else if (_noteList.type == UIConst.HORIZONTAL)
			{
				_noteList.fixedWidth = -1;
			}

			_noteList.invalidateNow();
			this.addChild(_noteList);
		}

		private function onItemRenderCreate(event:ListEvent):void
		{
			event.itemRender.addEventListener(MouseEvent.CLICK, onItemClick);
			var render:BaseDataListItemRender = BaseDataListItemRender(event.itemRender);
			render.dataBox.dragImage.pickUpEnable = false;
			render.selectable = false;
		}

		/**
		 * 点击列表项
		 * @param e
		 *
		 */
		private function onItemClick(e:MouseEvent):void
		{
			var itemRender:TListItemRender = TListItemRender(e.currentTarget);
			var noticeData:NoticeData = itemRender.data as NoticeData;
			noticeData.doClick();
		}
	}
}
