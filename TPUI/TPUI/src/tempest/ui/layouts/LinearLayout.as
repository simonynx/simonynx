package tempest.ui.layouts
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	
	import tempest.ui.UIConst;
	
	public class LinearLayout extends PaddingLayout
	{
		private var _type:String = UIConst.VERTICAL;
		
		private var _horizontalGap:Number = 0;
		private var _verticalGap:Number = 0;
		
		private var _horizontalAlign:String = "";
		private var _verticalAlign:String = "";
		
		/**
		 * 是否忽略不可视对象
		 */
		public var withoutHided:Boolean = true;
		
		public function LinearLayout(target:DisplayObjectContainer=null, isRoot:Boolean=false)
		{
			super(target, isRoot);
		}
		
		/** @inheritDoc*/
		protected override function layoutChildren(x:Number, y:Number, w:Number, h:Number) : void
		{
			var curY:Number = 0;
			var maxH:Number = 0;
			var prev:DisplayObject;
			for (var i:int = 0;i < targetProxy.numChildren;i++)
			{
				var obj:DisplayObject = targetProxy.getChildAt(i);
				
				if (withoutHided && !obj.visible)
					continue;
				
				if (type == UIConst.HORIZONTAL)
				{
					LayoutUtil.silder(obj,targetProxy,null,verticalAlign);
					if (!prev)
						LayoutUtil.silder(obj,targetProxy,UIConst.LEFT);
					else
						LayoutUtil.horizontal(obj,prev,targetProxy,horizontalGap);
				}
				else if (type == UIConst.VERTICAL)
				{
					LayoutUtil.silder(obj,targetProxy,horizontalAlign);
					if (!prev)
						LayoutUtil.silder(obj,targetProxy,null,UIConst.TOP);
					else
						LayoutUtil.vertical(obj,prev,targetProxy,verticalGap);
					
				}
				else if (type == UIConst.TILE)
				{
					maxH = Math.max(maxH,obj.height);
					if (!prev)
					{
						obj.x = 0;
						obj.y = 0;
					}
					else
					{
						LayoutUtil.horizontal(obj,prev,targetProxy,horizontalGap);
						var rect:Rectangle = obj.getRect(targetProxy);
						if (rect.right > x + w)
						{
							curY += maxH + verticalGap;
							maxH = 0;
							obj.x = 0;
							obj.y = curY;
						}
						else
						{
							obj.x = rect.x;
							obj.y = curY;
						}
					}
				}
				prev = obj;
			}
		}
		
		/**
		 * 横向对齐方式
		 * @return 
		 * 
		 */
		public function get horizontalAlign():String
		{
			return _horizontalAlign;
		}
		
		public function set horizontalAlign(v:String):void
		{
			_horizontalAlign = v;
			invalidateLayout();
		}
		
		/**
		 * 纵向对齐方式
		 * @return 
		 * 
		 */
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}
		
		public function set verticalAlign(v:String):void
		{
			_verticalAlign = v;
			invalidateLayout();
		}
		
		/**
		 * 方向 
		 * @return 
		 * 
		 */
		public function get type():String
		{
			return _type;
		}
		
		public function set type(v:String):void
		{
			_type = v;
			invalidateLayout();
		}
		
		/**
		 * 横向间距 
		 * @return 
		 * 
		 */
		public function get horizontalGap():Number
		{
			return _horizontalGap;
		}
		
		public function set horizontalGap(v:Number):void
		{
			_horizontalGap = v;
			invalidateLayout();
		}
		
		/**
		 * 纵向间距
		 * @return 
		 * 
		 */
		public function get verticalGap():Number
		{
			return _verticalGap;
		}
		
		public function set verticalGap(v:Number):void
		{
			_verticalGap = v;
			invalidateLayout();
		}
	}
}