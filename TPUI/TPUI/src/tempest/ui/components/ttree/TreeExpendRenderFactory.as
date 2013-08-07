package tempest.ui.components.ttree
{
	import tempest.ui.components.TListItemRender;
	
	public class TreeExpendRenderFactory extends TreeUnExpendRenderFactory
	{
		public var treeItemRenderFactory:TreeItemRenderFactory;
		
		public function TreeExpendRenderFactory(itemProxy:*, itemClass:Class, treeItemRenderFactory:TreeItemRenderFactory)
		{
			super(itemProxy, itemClass);
			this.treeItemRenderFactory = treeItemRenderFactory;
		}
		
		override public function newInstance():*
		{
			var render:TreeExpendRender = new itemRenderClass(itemProxy, null);
			render.treeItemRenderFactory = treeItemRenderFactory;
			return render;
		}
	}
}