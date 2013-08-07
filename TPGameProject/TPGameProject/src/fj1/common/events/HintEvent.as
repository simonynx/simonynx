package fj1.common.events
{
	import fj1.common.res.hint.vo.HintData;

	import flash.events.Event;

	public class HintEvent extends Event
	{
		public var hintData:HintData;
		public var params:Array;
		public var hintType:int;
		public static const HINT_SHOW:String = "hintShow";

		public function HintEvent(type:String, hintType:int, hintData:HintData, params:Array, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			this.hintType = hintType;
			this.hintData = hintData;
			this.params = params;
			super(type, bubbles, cancelable);
		}

		public function get id():int
		{
			return this.hintData.hintConfig.id;
		}

		override public function clone():Event
		{
			return new HintEvent(type, hintType, hintData, params, bubbles, cancelable);
		}
	}
}
