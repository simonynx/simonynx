package tempest.ui.components.tree2.factories
{
	import mx.core.IFactory;
	
	import tempest.ui.components.tree2.renders.TTree2ItemRender;
	import tempest.ui.core.IProxyFactory;

	public class TTreeItemRenderFactory implements IProxyFactory
	{
		private var _proxy:* = null;
		private var _checkBoxRender:* = null;
		private var _spreadItemRenderClass:Class = null;
		private var _textItemRenderClass:Class = null;
		private var _onListRenderCreate:Function = null;
		private var _initWidth:Number;
		/**
		 *
		 * @param checkBoxRender
		 * @param onListRenderCreate
		 * @param spreadItemRenderClass 可展开节点的渲染类, 默认为TTreeSpreadItemRender，自定义的话必须派生于TTreeSpreadItemRender
		 * @param textItemRenderClass 可展开节点的渲染类, 默认为TTreeTextItemRender，自定义的话必须派生于TTreeTextItemRender
		 *
		 */
		public function TTreeItemRenderFactory(checkBoxRender:*, initWidth:Number, onListRenderCreate:Function = null, spreadItemRenderClass:Class = null, textItemRenderClass:Class = null)
		{
			_checkBoxRender = checkBoxRender;
			_initWidth = initWidth;
			_spreadItemRenderClass = spreadItemRenderClass;
			_textItemRenderClass = textItemRenderClass;
			_onListRenderCreate = onListRenderCreate;
		}

		public function set proxy(value:*):void
		{
			_proxy = value;
		}

		public function newInstance():*
		{
			var render:TTree2ItemRender = new TTree2ItemRender(_proxy, null, _checkBoxRender, _onListRenderCreate, _spreadItemRenderClass, _textItemRenderClass);
			render.width = _initWidth;
			return render;
		}
		
		public function set initWidth(value:Number):void
		{
			_initWidth = value;
		}
	}
}
