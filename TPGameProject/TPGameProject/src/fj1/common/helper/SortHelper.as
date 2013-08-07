package fj1.common.helper
{
	import tempest.ui.collections.Sort;
	import tempest.ui.collections.SortField;
	import tempest.ui.collections.TArrayCollection;
	import tempest.ui.components.IList;

	/**
	 *排序工具类
	 * @author zhangyong
	 *
	 */
	public class SortHelper
	{
		/**
		 * 简单选择法排序 (从大到小)
		 * @param list
		 * @param cmpFunction function(item1, item2, null):int{} 返回正数，表示item2 > item1, 返回负数则相反，返回0则item2 == item1
		 * 即：返回正数,代表item1在item2之后
		 * 返回负数,代表item1在item2之前
		 *
		 */
		public static function spSort(list:TArrayCollection, cmpFunction:Function):void
		{
			var cur:Object;
			var curI:int;
			for (var i:int = 0; i < list.length - 1; i++)
			{
				cur = list[i];
				curI = i;
				for (var j:int = i + 1; j < list.length; j++)
				{
					if (cmpFunction(cur, list[j], null) > 0)
					{
						cur = list[j];
						curI = j;
					}
				}
				if (i != curI)
				{
					list[curI] = list[i];
					list[i] = cur;
				}
			}
		}

		/**
		 *节点排序
		 * @param treeModel
		 *
		 */
		public static function sortNode(iList:IList, sortString:String, isNum:Object = null):void
		{
			var sort:Sort = new Sort();
			sort.fields = [new SortField(sortString, false, false, isNum)];
			var tarr:TArrayCollection = iList as TArrayCollection;
			if (tarr)
			{
				tarr.sort = sort;
				tarr.refresh();
			}
		}

		/**
		 * 简单选择法排序 (从大到小)
		 * @param list
		 * @param cmpFunction function(item1, item2, null):int{} 返回正数，表示item2 > item1, 返回负数则相反，返回0则item2 == item1
		 * 即：返回正数,代表item1在item2之后
		 * 返回负数,代表item1在item2之前
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
					if (cmpFunction(cur, list[j], null) > 0)
					{
						cur = list[j];
						curI = j;
					}
				}
				if (i != curI)
				{
					if (swapFunction != null)
					{
						swapFunction(i, curI);
					}
					else
					{
						list[curI] = list[i];
						list[i] = cur;
					}
				}
			}
		}
	}
}
