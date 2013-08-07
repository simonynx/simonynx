package tempest.ui.components
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventPhase;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	import tempest.ui.UIStyle;
	import tempest.ui.interfaces.IAutoTopable;

	public class TContainer extends TComponent
	{
		private var _childAutoTopEnabled:Boolean = false;

		public function TContainer(constraints:Object = null, _proxy:* = null)
		{
			super(constraints, _proxy);
		}

		/**
		 * 是否开启子显示对象自动置顶检测
		 * 开启将在每次子显示对象变化（增删或层级变化）时，按照子显示对象的autoTopPriority属性排序子显示对象
		 * @param value
		 *
		 */
		public function set childAutoTopEnabled(value:Boolean):void
		{
			if (_childAutoTopEnabled == value)
			{
				return;
			}
			_childAutoTopEnabled = value;
		}

		override public function addChild(child:DisplayObject):DisplayObject
		{
			var ret:DisplayObject = super.addChild(child);
			if (_childAutoTopEnabled)
			{
				sortChildren();
			}
			return ret;
		}

		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			var ret:DisplayObject = super.addChildAt(child, index);
			if (_childAutoTopEnabled)
			{
				sortChildren();
			}
			return ret;
		}

		override public function setChildIndex(child:DisplayObject, index:int):void
		{
			super.setChildIndex(child, index);
			if (_childAutoTopEnabled)
			{
				sortChildren();
			}
		}

		private function sortChildren():void
		{
			var childArray:Array = [];
			for (var i:int = 0; i < this.numChildren; ++i)
			{
				childArray.push(getChildAt(i));
			}

			spSort2(childArray, cmpHandler, swapHandler);
		}

		private function cmpHandler(objLeft:DisplayObject, objRight:DisplayObject):int
		{
			var iTopableLeft:IAutoTopable = objLeft as IAutoTopable;
			var iTopableRight:IAutoTopable = objRight as IAutoTopable;
			var leftPriority:int = iTopableLeft ? iTopableLeft.autoTopPriority : 0;
			var rightPriority:int = iTopableRight ? iTopableRight.autoTopPriority : 0;
			return leftPriority - rightPriority;
		}

		private function swapHandler(list:Array, indexLeft:int, indexRight:int):void
		{
			var swap:DisplayObject = list[indexLeft];
			list[indexLeft] = list[indexRight];
			list[indexRight] = swap;

			this.setChildIndex(list[indexRight], indexRight);
			this.setChildIndex(list[indexLeft], indexLeft);
		}

		/**
		 * 简单选择法排序 (从大到小)
		 * @param list
		 * @param cmpFunction function(item1, item2, null):int{} 返回1，表示item2 > item1, 返回-1则相反，返回0则item2 == item1
		 * @param swapFunction 用于交换两项
		 *
		 */
		public static function spSort2(list:Array, cmpFunction:Function, swapFunction:Function):void
		{
			var cur:Object;
			var curI:int;
			for (var i:int = 0; i < list.length - 1; i++)
			{
				cur = list[i];
				curI = i;
				for (var j:int = i + 1; j < list.length; j++)
				{
					if (cmpFunction(cur, list[j]) > 0)
					{
						cur = list[j];
						curI = j;
					}
				}
				if (i != curI)
				{
					swapFunction(list, curI, i);
				}
			}
		}
	}
}
