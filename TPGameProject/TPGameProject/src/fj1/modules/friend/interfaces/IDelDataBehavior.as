package fj1.modules.friend.interfaces
{
	import tempest.ui.collections.TArrayCollection;

	public interface IDelDataBehavior
	{

		/**
		 * 删除数据
		 * @param data 原始数据对象(TArrayCollection)
		 * @param value 要被删除的对象的id
		 *
		 */
		function delData(data:TArrayCollection, value:* = null):void;
	}
}
