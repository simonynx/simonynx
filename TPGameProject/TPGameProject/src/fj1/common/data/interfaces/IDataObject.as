package fj1.common.data.interfaces
{
	import tempest.ui.interfaces.IToolTipClient;

	public interface IDataObject
	{
		function get guId():uint;

		/**
		 * 游戏数据对象的唯一类型
		 * @return
		 *
		 */
		function get typeId():uint;
		function get name():String;
		function set name(value:String):void;
		function get templateId():int;

	}
}
