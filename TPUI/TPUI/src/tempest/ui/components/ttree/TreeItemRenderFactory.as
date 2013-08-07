package tempest.ui.components.ttree
{
	import mx.core.IFactory;
	
	
	public class TreeItemRenderFactory implements IFactory
	{
		public var itemFactory:TreeUnExpendRenderFactory;
		public var expendItemFactory:TreeExpendRenderFactory;
		
		public var treeRenderClass:Class = TTreeItemRender;
		
		public function TreeItemRenderFactory(itemProxy:* = null, itemClass:Class = null, expendItemProxy:* = null, expendItemClass:Class = null)
		{
			if(!itemClass)
				itemClass = TreeUnExpendRender;
			itemFactory = new TreeUnExpendRenderFactory(itemProxy, itemClass);
			
			if(!expendItemClass)
				expendItemClass = TreeExpendRender;
			expendItemFactory = new TreeExpendRenderFactory(expendItemProxy, expendItemClass, this);
		}
		
		public function newInstance():*
		{
			return new treeRenderClass(itemFactory, expendItemFactory);
		}
	}
}