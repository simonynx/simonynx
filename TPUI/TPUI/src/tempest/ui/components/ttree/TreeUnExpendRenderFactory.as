package tempest.ui.components.ttree
{
	import mx.core.IFactory;
	
	public class TreeUnExpendRenderFactory implements IFactory
	{
		public var itemProxy:*;
		public var itemRenderClass:Class;
		
		public function TreeUnExpendRenderFactory(itemProxy:*, itemClass:Class)
		{
			this.itemProxy = itemProxy;
			this.itemRenderClass = itemClass;	
		}
		
		public function newInstance():*
		{
			return new itemRenderClass(itemProxy, null);
		}
	}
}