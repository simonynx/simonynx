package tempest.ui.components.tree2.renders
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.IFactory;
	
	import tempest.ui.collections.TArrayCollection;
	import tempest.ui.components.IList;
	import tempest.ui.components.TComponent;
	import tempest.ui.components.TList;
	import tempest.ui.components.TTextListItemRender;
	import tempest.ui.components.tree2.AutoSpreadList;
	import tempest.ui.components.tree2.TCheckBox2;
	import tempest.ui.components.tree2.TTree2;
	import tempest.ui.components.tree2.data.TTreeNode;
	import tempest.ui.components.tree2.effect.SpreadEffect;
	import tempest.ui.components.tree2.factories.TTreeItemRenderFactory;
	import tempest.ui.events.CollectionEvent;
	import tempest.ui.events.ListEvent;

	/**
	 * 树形可展开节点Render
	 * 包含一个子集节点列表
	 * @author linxun
	 *
	 */
	public class TTreeSpreadItemRender extends SpreadItemRender
	{
		private var _list:TList;
		private var _ttree:TTree2;
		private var treeItemRenderSkin:*;
		private var _onListRenderCreate:Function;
		private var _doubleClickArea:InteractiveObject; //双击区域
		private var _checkBoxRender:*;
		private var _treeItemRenderFactory:IFactory;

		public function get list():TList
		{
			return _list;
		}

		/**
		 *
		 * @param proxy 用来作为点击展开头部的资源，一般是CheckBox资源
		 * 资源中必须包含“bg”为名称的影片剪辑，用来显示列表效果，否则列表项将没有选中效果
		 * @param data
		 * @param headRender 用来作为点击展开头部的控件类，默认为CheckBox
		 * @param treeItemRenderSkin 用来作为子集列表的列表项资源，可以将TTree2ItemRender的资源传入
		 *
		 */
		public function TTreeSpreadItemRender(proxy:* = null, data:Object = null, checkBoxRender:* = null, treeItemRenderFactory:IFactory = null, treeItemRenderSkin:* = null, onListRenderCreate:Function = null)
		{
			this.treeItemRenderSkin = treeItemRenderSkin;
			_onListRenderCreate = onListRenderCreate;
			_checkBoxRender = checkBoxRender;
			_treeItemRenderFactory = treeItemRenderFactory;
			super(proxy, data, checkBoxRender);

			//初始化双击区域
			initDoubleClickArea(head);
			_spreadEffect.addEventListener("spreadStart", onSpreadStart);
		}

		private function initDoubleClickArea(headProxy:*):void
		{
			_doubleClickArea = headProxy.textField;
			_doubleClickArea.doubleClickEnabled = true;
			_doubleClickArea.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
		}

		private function onDoubleClick(event:MouseEvent):void
		{
			spreadState = !_head.selected;
		}

		private function get ttree():TTree2
		{
			if (!_ttree)
			{
				var parentView:DisplayObject = this.parent;
				while (parentView)
				{
					if (parentView is TTree2)
					{
						_ttree = parentView as TTree2;
						break;
					}
					parentView = parentView.parent;
				}
			}
			return _ttree;
		}

		override protected function onHeadClick(event:MouseEvent):void
		{
			if (!selected)
			{
				if (data is TTreeNode && !(TTreeNode(data).selectEnabled))
				{
					ttree.setSelectInternal(null);
				}
				else
				{
					ttree.setSelectInternal(this.data);
					setSelect();
				}
			}
//			super.onHeadClick(event);
		}

		/**
		 * 清空选中（包括子集列表）
		 *
		 */
		public function cleanSelect():void
		{
			list.selectedIndex = -1;
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
		}
		
		private var _dataProviderAsyn:IList;
		
		private function set dataProvider(value:IList):void
		{
			_dataProviderAsyn = value;
			if(_spreadEffect.state == SpreadEffect.STATE_SPREAD)
			{
				this.dataProviderInternal = _dataProviderAsyn;
			}
		}
		
		private function onSpreadStart(event:Event):void
		{
			this.dataProviderInternal = _dataProviderAsyn;
		}

		private function set dataProviderInternal(value:IList):void
		{
			if(_list.dataProvider == value)
			{
				return;
			}
			if (_list.dataProvider)
			{
				_list.dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChange);
			}
			list.dataProvider = value;
			if (_list.dataProvider)
			{
				_list.dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChange);
			}
			if (ttree)
			{
				ttree.cleanAllSelect();
			}
			//
			_list.invalidateNow();
		}

		private function onCollectionChange(event:CollectionEvent):void
		{
			if (ttree)
			{
				ttree.cleanAllSelect();
			}
		}

		override public function set data(value:Object):void
		{
			super.data = value;

			var treeNode:TTreeNode = value as TTreeNode;
			this.setText(treeNode.text);
			if (!_list)
			{
				_list = new AutoSpreadList(null, _treeItemRenderFactory, treeItemRenderSkin);
				if (_onListRenderCreate != null)
				{
					_list.addEventListener(ListEvent.ITEM_RENDER_CREATE, _onListRenderCreate);
				}
				_list.invalidateSelectNow = true;
				this.setSpreadPanel(_list);
			}
			if (treeNode)
			{
				dataProvider = treeNode.childList;
			}
			else
			{
				dataProvider = null;
			}
			
		}
		
		public override function invalidateSize(changed:Boolean=false):void
		{
			super.invalidateSize(changed);
			var renderFactory:TTreeItemRenderFactory = TTreeItemRenderFactory(_treeItemRenderFactory);
			renderFactory.initWidth = _width;
		}
	}
}
