package tempest.ui.layouts
{
	import flash.display.DisplayObjectContainer;
	
	public class PaddingLayout extends Layout
	{
		private var _paddingLeft:Number = 0;
		private var _paddingTop:Number = 0;
		private var _paddingRight:Number = 0;
		private var _paddingBottom:Number = 0;
		
		public function PaddingLayout(target:DisplayObjectContainer=null, isRoot:Boolean=false)
		{
			super(target, isRoot);
		}
		
		/**
		 * 统一设置全部边距 
		 * @param v
		 * 
		 */
		public function set padding(v:Number):void
		{
			this.paddingTop = this.paddingBottom = this.paddingLeft = this.paddingRight = v;
		}
		
		/**
		 * 左边距
		 * @return 
		 * 
		 */
		public function get paddingLeft():Number
		{
			return _paddingLeft;
		}
		
		public function set paddingLeft(v:Number):void
		{
			_paddingLeft = v;
			invalidateLayout();
		}
		
		/**
		 * 上边距
		 * @return 
		 * 
		 */
		public function get paddingTop():Number
		{
			return _paddingTop;
		}
		
		public function set paddingTop(v:Number):void
		{
			_paddingTop = v;
			invalidateLayout();
		}
		
		/**
		 * 右边距
		 * @return 
		 * 
		 */
		public function get paddingRight():Number
		{
			return _paddingRight;
		}
		
		public function set paddingRight(v:Number):void
		{
			_paddingRight = v;
			invalidateLayout();
		}
		
		/**
		 * 下边距
		 * @return 
		 * 
		 */
		public function get paddingBottom():Number
		{
			return _paddingBottom;
		}
		
		public function set paddingBottom(v:Number):void
		{
			_paddingBottom = v;
			invalidateLayout();
		}
	}
}