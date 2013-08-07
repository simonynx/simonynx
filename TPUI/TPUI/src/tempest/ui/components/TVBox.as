package tempest.ui.components
{
	import tempest.ui.UIConst;
	import tempest.ui.layouts.LinearLayout;

	/**
	 * 纵向布局控件
	 * 需要在addChildren方法中将proxy中控件add到this上，以 TVBox 作为父级
	 * 否则layout将失效
	 * @author linxun
	 * 
	 */	
	public class TVBox extends TAutoSizeComponent
	{
		public function TVBox(constraints:Object=null, _proxy:*=null, verticalAlign:String = UIConst.TOP)
		{
			super(constraints, _proxy, true);
			
			layout = new LinearLayout();
			LinearLayout(layout).verticalAlign = verticalAlign;
		}
		
		/**
		 * 重载该函数将proxy中控件add到this上，以 TVBox作为父级
		 * 否则layout将失效
		 */		
//		override protected function addChildren():void
//		{
//			super.addChildren();
//		}
	}
}