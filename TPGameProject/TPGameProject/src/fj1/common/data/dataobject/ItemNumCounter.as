package fj1.common.data.dataobject
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	/**
	 * 物品数量统计类，统计背包中物品数量
	 * @author linxun
	 *
	 */
	public class ItemNumCounter extends EventDispatcher
	{
		private var _templateId:int;
		[Bindable]
		public var num:int = 0;

		public function ItemNumCounter(templateId:int)
		{
			super(this);
			_templateId = templateId;
		}

		public function get templateId():int
		{
			return _templateId;
		}
	}
}
