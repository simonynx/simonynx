package tempest.ui.components.ttree
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;

	import mx.events.PropertyChangeEvent;

	import tempest.common.staticdata.MovieClipResModel;
	import tempest.ui.components.TCheckBox;
	import tempest.ui.components.TExpendableList;
	import tempest.ui.components.TExpendableListItemRender;
	import tempest.ui.components.TListItemRender;
	import tempest.ui.events.CollectionEvent;
	import tempest.ui.events.CollectionEventKind;
	import tempest.ui.events.DataEvent;
	import tempest.ui.events.ListEvent;

	public class TreeExpendRender extends TExpendableListItemRender
	{
		protected var _list:TExpendableList;
		protected var _checkBox:TCheckBox
		public var treeItemRenderFactory:TreeItemRenderFactory;
		private var _treeWidth:Number;

		public function get list():TExpendableList
		{
			return _list;
		}

		public function TreeExpendRender(_proxy:*, data:Object)
		{
			super(_proxy, data);
		}

		override protected function addChildren():void
		{
			super.addChildren();
			_checkBox = new TCheckBox(null, _proxy.mc_checkBox, null, MovieClipResModel.MODEL_FRAME_2);
			_checkBox.addEventListener(Event.CHANGE, onChange);
			this.reInit(_checkBox, _proxy); //重新设置下拉按钮和头部区域背景
		}

		override public function set data(value:Object):void
		{
			var oldNodeData:TreeModel = TreeModel(super.data);
			if (oldNodeData)
			{
				oldNodeData.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onItemPropertyChange);
				oldNodeData.removeEventListener("expend", onExpend);
				oldNodeData.removeEventListener("dispend", onDispend);
			}
			super.data = value;
			var nodeData:TreeModel = data as TreeModel;
			if (nodeData)
				_checkBox.text = nodeData.data as String;
			else
				_checkBox.text = "";
			setExpendsList(nodeData); //设置子项列表
			//监听TreeModel的事件
			nodeData.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onItemPropertyChange); //属性变更
			nodeData.addEventListener("expend", onExpend); //展开	
			nodeData.addEventListener("dispend", onDispend); //收起
		}

		private function onListChange(e:CollectionEvent):void
		{
			switch (e.kind)
			{
				case CollectionEventKind.REMOVE:
//				case CollectionEventKind.ADD:
//				case CollectionEventKind.REFRESH:
//				case CollectionEventKind.RESET:
//				case CollectionEventKind.REPLACE:
					if (_list.selectedIndex != -1)
					{
						if (_list.items.length != 0)
						{
							if (!_list.selectedItem)
							{
								_list.selectedIndex = _list.items.length - 1;
							}
							dispatchEvent(new DataEvent(DataEvent.DATA_SELECT, _list.selectedItem, true));
						}
						else
						{
							dispatchEvent(new Event("SelectNextList", true));
						}
					}
					break;
			}
		}

//		override protected function onHeadClick(event:MouseEvent):void
//		{
//			super.onHeadClick(event);
//			
//		}
		override public function expend():void
		{
			super.expend();
			if (!_checkBox.selected)
			{
//				_checkBox.removeEventListener(Event.CHANGE, onChange);
				_checkBox.selected = true;
				onChange(null);
//				_checkBox.addEventListener(Event.CHANGE, onChange);
				cleanSelect();
			}
		}

		override public function dispend():void
		{
			super.dispend();
			if (_checkBox.selected)
			{
				_checkBox.selected = false;
				onChange(null);
				cleanSelect();
			}
		}

		protected function setExpendsList(nodeData:TreeModel):void
		{
			if (nodeData)
			{
				if (!_list)
				{
					_list = new TExpendableList(null, null, null, treeItemRenderFactory, null, []);
					_list.addEventListener(ListEvent.ITEM_RENDER_CREATE, onItemRenderCreate);
					_list.addEventListener(Event.SELECT, onListSelect);
					this.addToExpandContainer(_list);
				}
				_list.data = nodeData;
				_list.fixedWidth = this.width;
				if (_list.dataProvider)
				{
					_list.dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, onListChange);
				}
				_list.dataProvider = nodeData ? nodeData.childList : null;
				_list.dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, onListChange); //子项列表数据变化
				_list.invalidateNow();
			}
		}

		private function onListSelect(event:Event):void
		{
			if (_list.selectedIndex != -1)
			{
				dispatchEvent(new DataEvent(DataEvent.DATA_SELECT, _list.selectedItem, true));
				//置空其他列表的select状态
				_list.dispatchEvent(new Event("CleanSelect", true));
			}
		}

		public function cleanSelect():void
		{
			if (_list)
			{
				_list.selectedIndex = -1;
			}
		}

		private function onChange(event:Event):void
		{
			dispatchEvent(new Event(Event.SELECT)); //抛出SELECT，让父级列表监听到选中
//			if(_checkBox.selected)
//			{
//			dispatchEvent(new DataEvent(DataEvent.DATA_SELECT, this.data));
			if (_list)
				_list.dispatchEvent(new Event("CleanSelectAll", true));
//			}
		}

		/**
		 * 监听列表项内部的选中事件
		 * @param event
		 *
		 */
		private function onItemRenderCreate(event:ListEvent):void
		{
			var itemRender:TListItemRender = event.data as TListItemRender;
//			itemRender.addEventListener(DataEvent.DATA_SELECT, onListItemSelect);
		}

		private function onExpend(event:Event):void
		{
			this.expend();
		}

		private function onDispend(event:Event):void
		{
			this.dispend();
		}

		/**
		 * TreeModel的data设为null, 并且子级项目长度为0时，删除该项目
		 * @param event
		 *
		 */
		private function onItemPropertyChange(event:PropertyChangeEvent):void
		{
			var treeModel:TreeModel = TreeModel(event.currentTarget);
			if (event.property == "data" && event.newValue == null && (treeModel.childList == null || treeModel.childList.length == 0))
			{
				var nodeData:TreeModel = TreeModel(this.data);
				nodeData.childList.removeItemAt(nodeData.childList.getItemIndex(treeModel));
			}
		}

//		/**
//		 * 列表项中的子列表项被选中
//		 * @param event
//		 *
//		 */
//		private function onListItemSelect(event:DataEvent):void
//		{
//			dispatchEvent(new DataEvent(DataEvent.DATA_SELECT, event.data));
//		}

		public override function invalidateSize(changed:Boolean = false):void
		{
			//不直接修改宽度，防止缩放
			//设置子项列表
			if (_list)
			{
				_list.fixedWidth = _expandContainer.width;
				_list.invalidateNow();
			}
//			_width = Math.max(this.width, _proxy.width);
//			super.invalidateSize();
		}
	}
}
