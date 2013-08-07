package tempest.ui.layouts
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import tempest.ui.UIConst;
	import tempest.ui.components.TComponent;
	
	public class LayoutUtil
	{
		/**
		 * 对齐
		 * 
		 * @param obj
		 * @param container
		 * @param horizontalAlign
		 * @param verticalAlign
		 * 
		 */
		public static function silder(obj:DisplayObject,container:DisplayObjectContainer,horizontalAlign:String = null,verticalAlign:String = null, xOffset:Number = 0, yOffset:Number = 0):void
		{
			var cRect:Rectangle = container.getRect(container);
			var rect:Rectangle = obj.getRect(container);
			var offest:Point = new Point(obj.x - rect.x,obj.y - rect.y);
			switch (horizontalAlign)
			{
				case UIConst.LEFT:
					obj.x = cRect.x + offest.x + xOffset;
					break;
				case UIConst.CENTER:
					obj.x = cRect.x + (cRect.width - rect.width)/2 + offest.x + xOffset;
					break;
				case UIConst.RIGHT:
					obj.x = cRect.x + (cRect.width - rect.width) + offest.x + xOffset;
					break;
			}
			switch (verticalAlign)
			{
				case UIConst.TOP:
					obj.y = cRect.y + offest.y + yOffset;
					break;
				case UIConst.MIDDLE:
					obj.y = cRect.y + (cRect.height - rect.height)/2 + offest.y + yOffset;
					break;
				case UIConst.BOTTOM:
					obj.y = cRect.y + (cRect.height - rect.height) + offest.y + yOffset;
					break;
			}
		}
		
		/**
		 * 从中部偏移
		 * 
		 * @param obj
		 * @param container
		 * @param horizontalCenter
		 * @param verticalCenter
		 * 
		 */
		public static function center(obj:DisplayObject,container:DisplayObjectContainer,horizontalCenter:Number = NaN,verticalCenter:Number = NaN):void
		{
			var cRect:Rectangle = container.getRect(container);
			var rect:Rectangle = obj.getRect(container);
			var offest:Point = new Point(obj.x - rect.x,obj.y - rect.y);
			
			if (!isNaN(horizontalCenter))
				obj.x = cRect.x + (cRect.width - rect.width)/2 + offest.x + horizontalCenter;
			
			if (!isNaN(verticalCenter))
				obj.y = cRect.y + (cRect.height - rect.height)/2 + offest.y + verticalCenter;
			
		}
		
		/**
		 * 控制外框边距
		 * 
		 * @param obj
		 * @param container
		 * @param left
		 * @param right
		 * @param top
		 * @param bottom
		 * @return 
		 * 
		 */
		public static function metrics(obj:DisplayObject,container:DisplayObjectContainer,left:Number=NaN,top:Number=NaN,right:Number=NaN,bottom:Number=NaN):void
		{
			var cRect:Rectangle = container.getRect(container);
			var rect:Rectangle = obj.getRect(container);
			var offest:Point = new Point(obj.x - rect.x,obj.y - rect.y);
			
			if (!isNaN(left))
				obj.x = cRect.x + left + offest.x;
			
			if (!isNaN(top))
				obj.y = cRect.y + top + offest.y;
			
			if (!isNaN(right))
			{
				if (!isNaN(left))
				{
					if (obj is TComponent)
						(obj as TComponent).setSize(cRect.right - (obj.x - offest.x) - right,obj.height);
					else
						obj.width = cRect.right - (obj.x - offest.x) - right;
					obj.x -= offest.x * (1 - obj.width / rect.width);
				}
				else
					obj.x = cRect.right - rect.width + offest.x - right;
			}
			
			if (!isNaN(bottom))
			{
				if (!isNaN(top))
				{
					if (obj is TComponent)
						(obj as TComponent).setSize(obj.width,cRect.bottom - (obj.y - offest.y) - bottom);
					else
						obj.height = cRect.bottom - (obj.y - offest.y) - bottom;
					obj.y -= offest.y * (1 - obj.height / rect.height);
				}
				else
					obj.y = cRect.bottom - rect.height + offest.y - bottom;
			}
		}
		
		/**
		 * 百分比长宽
		 * 
		 * @param obj
		 * @param container
		 * @param width
		 * @param height
		 * 
		 */
		public static function percent(obj:DisplayObject,container:DisplayObjectContainer,width:Number=NaN,height:Number=NaN):void
		{
			if (!isNaN(width))
				obj.width = container.width * width;
			
			if (!isNaN(height))
				obj.height = container.height * height;
		}
		
		/**
		 * 横向排列
		 * 
		 * @param obj
		 * @param prev	上一个物品
		 * @param gap	间距
		 * 
		 */
		public static function horizontal(obj:DisplayObject,prev:DisplayObject,container:*,gap:int = 0, horizontalAlign:String =UIConst.LEFT):void
		{
//			var pRect:Rectangle = prev.getRect(container);
//			var rect:Rectangle = obj.getRect(container);
//			var offest:Point = new Point(obj.x - rect.x,obj.y - rect.y);
//			
//			if(horizontalAlign == UIConst.LEFT)
//				obj.x = pRect.right + offest.x + gap;
//			else if(horizontalAlign == UIConst.RIGHT)
//				obj.x = pRect.x + offest.x - gap - rect.width;
//			else
//				throw new Error("不支持居中排列");
			
			if(horizontalAlign == UIConst.LEFT)
				obj.x = prev.x + prev.width + gap;
			else if(horizontalAlign == UIConst.RIGHT)
				obj.x = prev.x - gap - obj.width;
			else
				throw new Error("不支持居中排列");
		}
		
		/**
		 * 纵向排列
		 * 
		 * @param obj
		 * @param prev	上一个物品
		 * @param gap	间距
		 * 
		 */
		public static function vertical(obj:DisplayObject,prev:DisplayObject,container:*,gap:int = 0, verticalAlign:String = UIConst.TOP):void
		{
//			var pRect:Rectangle = prev.getRect(container);
//			var rect:Rectangle = obj.getRect(container);
//			var offest:Point = new Point(obj.x - rect.x,obj.y - rect.y);
//			
//			if(verticalAlign == UIConst.TOP)
//				obj.y = pRect.bottom + offest.y + gap;
//			else if(verticalAlign == UIConst.RIGHT)
//				obj.y = pRect.y + offest.y - gap - rect.height;
//			else
//				throw new Error("不支持居中排列");
			
			if(verticalAlign == UIConst.TOP)
				obj.y = prev.y + prev.height + gap;
			else if(verticalAlign == UIConst.BOTTOM)
				obj.y = prev.y - gap - obj.height;
			else
				throw new Error("不支持居中排列");
		}
	}
}