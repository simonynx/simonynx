package tempest.ui.components.tree2.renders
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import tempest.ui.components.TListItemRender;
	import tempest.ui.components.tree2.IIndentSetter;
	import tempest.ui.components.tree2.TCheckBox2;
	import tempest.ui.components.tree2.TTree2;
	import tempest.ui.components.tree2.data.TTreeNode;
	import tempest.ui.components.tree2.factories.TTreeItemRenderFactory;

	/**
	 * 树形Render，当中包含可展开节点Render不可展开节点Render
	 * 资源中需包含可展开节点资源和不可展开节点资源，分别命名为mc_spreadItemRender，mc_textRender
	 * @author linxun
	 *
	 */
	public class TTree2ItemRender extends TListItemRender
	{
		private var _spreadItemRender:TTreeSpreadItemRender;
		private var _textItemRender:TListItemRender;
		private var _curRender:TListItemRender;

		/**
		 *
		 * @param proxy
		 * @param data
		 * @param checkBoxRender
		 *
		 *
		 */
		/**
		 *
		 * @param proxy 资源中需包含可展开节点资源和不可展开节点资源，分别命名为mc_spreadItemRender，mc_textRender
		 * @param data
		 * @param checkBoxRender 可展开节点需要用到的checkBoxRender
		 * @param onListRenderCreate
		 * @param spreadItemRenderClass 可展开节点的渲染类, 默认为TTreeSpreadItemRender，自定义的话必须派生于TTreeSpreadItemRender
		 * @param textItemRenderClass 可展开节点的渲染类, 默认为TTreeTextItemRender，自定义的话必须派生于TTreeTextItemRender
		 *
		 */
		public function TTree2ItemRender(proxy:* = null, data:Object = null, checkBoxRender:* = null, onListRenderCreate:Function = null, spreadItemRenderClass:Class = null, textItemRenderClass:Class = null)
		{
			var bg:Shape = new Shape(); //默认背景
			var proxySprite:* = new proxy(); //列表项资源
			bg.graphics.drawRect(0, 0, proxySprite.width, proxySprite.height);
			super(bg, data);
			autoSwitchBk = false;
			if (checkBoxRender == null)
			{
				checkBoxRender = TCheckBox2;
			}
			if (spreadItemRenderClass == null)
			{
				spreadItemRenderClass = TTreeSpreadItemRender;
			}
			if (textItemRenderClass == null)
			{
				textItemRenderClass = TTreeTextItemRender;
			}
			_spreadItemRender = new TTreeSpreadItemRender(
				proxySprite.mc_spreadItemRender,
				data,
				checkBoxRender,
				new TTreeItemRenderFactory(checkBoxRender, _proxy.width, onListRenderCreate, spreadItemRenderClass, textItemRenderClass),
				proxy,
				onListRenderCreate);
			_textItemRender = new textItemRenderClass(proxySprite.mc_textRender);
		}

		override protected function onClick(event:MouseEvent):void
		{

		}

		private function set curRender(render:TListItemRender):void
		{
			if (_curRender == render)
			{
				return;
			}
			if (_curRender)
			{
				this.removeChild(_curRender);
				_curRender.removeEventListener(Event.RESIZE, onCurRenderResize);
				_curRender.removeEventListener(Event.SELECT, onCurRenderSelect);
			}
			_curRender = render;
			if (_curRender)
			{
				this.addChild(_curRender);
				_curRender.addEventListener(Event.RESIZE, onCurRenderResize);
				_curRender.addEventListener(Event.SELECT, onCurRenderSelect);
			}
			this.measureChildren();
		}

		private function get curRender():TListItemRender
		{
			return _curRender;
		}

		public function getCurRender():TListItemRender
		{
			return _curRender;
		}

		private function onCurRenderResize(event:Event):void
		{
			this.measureChildren();
		}

		private function onCurRenderSelect(event:Event):void
		{
			_selected = (event.currentTarget as TListItemRender).selected;
			dispatchEvent(new Event(Event.SELECT));
		}

		override public function set selected(value:Boolean):void
		{
			super.selected = value;
			if (curRender)
			{
				curRender.removeEventListener(Event.SELECT, onCurRenderSelect);
				curRender.selected = value;
				curRender.addEventListener(Event.SELECT, onCurRenderSelect);
			}
		}

		override public function set data(value:Object):void
		{
			super.data = value;
			if (!data)
			{
				return;
			}
			if (value is TTreeNode)
			{
				var treeNode:TTreeNode = value as TTreeNode;
				if ((treeNode.childList && treeNode.childList.length != 0)
					|| treeNode.spreadableAlways)
				{
					curRender = _spreadItemRender;
				}
				else
				{
					curRender = _textItemRender;
				}
				curRender.data = treeNode;
				var indent:int = (treeNode.level - 1) * treeNode.levelIndent;
				(curRender as IIndentSetter).indentX = indent;
			}
			else
			{
				curRender = _textItemRender;
				curRender.data = value;
			}
		}

		override public function invalidateSize(changed:Boolean = false):void
		{
			_spreadItemRender.width = _width;
			_textItemRender.width = _width;
		}

		override public function set index(value:int):void
		{
			super.index = value;
			_spreadItemRender.index = value;
			_textItemRender.index = value;
		}
	}
}
