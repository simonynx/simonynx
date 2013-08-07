package tempest.ui.components.tree2
{
	import flash.events.Event;

	import tempest.ui.components.IList;
	import tempest.ui.components.TList;
	import tempest.ui.components.TScrollPanel;
	import tempest.ui.components.tree2.data.TTreeNode;
	import tempest.ui.components.tree2.factories.TTreeItemRenderFactory;
	import tempest.ui.components.tree2.renders.TTree2ItemRender;
	import tempest.ui.components.tree2.renders.TTreeSpreadItemRender;
	import tempest.ui.core.IProxyFactory;
	import tempest.ui.events.CollectionEvent;
	import tempest.ui.events.CollectionEventKind;
	import tempest.ui.events.ListEvent;


	public class TTree2 extends TScrollPanel
	{
		private var _list:TList;
		private var _selectedItem:Object;
		private var _rootNode:TTreeNode;

		public function get selectedItem():Object
		{
			return _selectedItem;
		}

		/**
		 *
		 * @param constraints
		 * @param _proxy
		 * @param renderSkin
		 * @param useScrollBar
		 * @param scrollBarProxy
		 * @param onRenderCreate
		 * @param spreadItemRenderClass 可展开节点的渲染类, 默认为TTreeSpreadItemRender，自定义的话必须派生于TTreeSpreadItemRender
		 * @param textItemRenderClass 可展开节点的渲染类, 默认为TTreeTextItemRender，自定义的话必须派生于TTreeTextItemRender
		 *
		 */
		public function TTree2(constraints:Object = null,
			_proxy:* = null,
			renderSkin:* = null,
			useScrollBar:Boolean = false,
			scrollBarProxy:* = null,
			onRenderCreate:Function = null,
			checkBoxClass:* = null,
			spreadItemRenderClass:Class = null,
			textItemRenderClass:Class = null)
		{
			super(constraints, _proxy, useScrollBar, scrollBarProxy);
			var treeRenderFactory:TTreeItemRenderFactory = new TTreeItemRenderFactory(checkBoxClass, _proxy.width, onRenderCreate, spreadItemRenderClass, textItemRenderClass);
			_list = new AutoSpreadList(null, treeRenderFactory, renderSkin);
			if (onRenderCreate != null)
			{
				_list.addEventListener(ListEvent.ITEM_RENDER_CREATE, onRenderCreate);
			}
			_list.invalidateSelectNow = true;
			this.contentPanel = _list;
			moveScrollBarToTop();
		}

		public function setSelectInternal(value:Object, dispatch:Boolean = true):void
		{
			_selectedItem = value;
			_list.selectedIndex = -1;
			for (var i:int = 0; i < _list.items.length; i++)
			{
				var treeItemRender:TTree2ItemRender = _list.getItemRender(i) as TTree2ItemRender;
				if (treeItemRender)
				{
					var curRender:TTreeSpreadItemRender = treeItemRender.getCurRender() as TTreeSpreadItemRender;
					if (curRender)
					{
						curRender.cleanSelect();
					}
				}
			}
			if (dispatch)
			{
				dispatchEvent(new Event(Event.SELECT));
			}
		}

		public function cleanAllSelect():void
		{
			setSelectInternal(null, false);
		}

//		public function set selectedItem(value:Object):void
//		{
//
//		}

		public function set dataProvider(value:IList):void
		{
			if (_list.dataProvider)
			{
				_list.dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChange);
			}
			_list.dataProvider = value;
			if (_list.dataProvider)
			{
				_list.dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChange);
			}
			cleanAllSelect();
		}

		private function onCollectionChange(event:CollectionEvent):void
		{
			cleanAllSelect();
		}

		public function set rootNode(value:TTreeNode):void
		{
			_rootNode = value;
			if (_rootNode)
			{
				dataProvider = _rootNode.childList;
			}
			else
			{
				dataProvider = null;
			}
		}

		public function get rootNode():TTreeNode
		{
			return _rootNode;
		}

		public function get list():TList
		{
			return _list;
		}
	}
}
