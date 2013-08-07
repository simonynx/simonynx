package fj1.modules.friend.interfaces
{
	import tempest.ui.collections.TArrayCollection;

	public interface IAddDataBehavior
	{
		/**
		 * 添加数据
		 * @param data 原始数据对象(TArrayCollection)
		 * @param value 要被添加的对象
		 *
		 */
		function addData(data:TArrayCollection, value:* = null):void;
	}
}
