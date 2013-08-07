package fj1.modules.friend.interfaces
{
	import tempest.ui.collections.TArrayCollection;

	public interface IInDataBehavior
	{
		/**
		 * 是否在数据里面
		 * @param data 原始数据对象(TArrayCollection)
		 * @param id 被查询的条件 guid
		 * @return
		 *
		 */
		function isInData(data:TArrayCollection, id:int):*;
	}
}
