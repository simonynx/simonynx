package fj1.modules.item.events
{
	import tempest.ui.events.DataEvent;
	
	public class PackQueryEvent extends DataEvent
	{
		private var _awardList:Array;
		private var _subtype:int;
		
		public static const PACK_QUERY_RESULT:String = "packQueryResult";
		
		public function PackQueryEvent(type:String, awardList:Array, subtype:int, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_awardList = awardList;
			_subtype = subtype;
			super(type, data, bubbles, cancelable);
		}
		
		public function get awardList():Array
		{
			return _awardList;
		}
		
		public function get subtype():int
		{
			return _subtype;
		}
	}
}