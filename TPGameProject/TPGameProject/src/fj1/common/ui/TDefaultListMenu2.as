package fj1.common.ui
{
	import flash.display.DisplayObject;
	
	import tempest.core.IPoolClient;
	import tempest.ui.components.TDefaultListMenu;
	
	public class TDefaultListMenu2 extends TDefaultListMenu implements IPoolClient
	{
		public function TDefaultListMenu2(container:DisplayObject=null, shower:DisplayObject=null, proxy:*=null, itemRenderClass:Class=null, itemRenderSkin:Class=null, nameProperty:String="name")
		{
			super(container, shower, proxy, itemRenderClass, itemRenderSkin, nameProperty);
		}
		
		public function reset(args:Array):void
		{
			this.container = args[0];
			this.shower = args[1];
		}
	}
}