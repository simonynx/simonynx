package tempest.common.handler.vo
{
	
	public class HandlerData
	{
		private var _handler:Function
		private var _parameters:Array
		private var _delay:Number
		private var _doNext:Boolean
		public function HandlerData(handler:Function,params:Array = null,delay:Number = 0,doNext:Boolean = true)
		{
			this._handler = handler;
			this._parameters = params;
			this._delay = delay;
			this._doNext = doNext;
		}
		public function get handler():Function
		{
			return (this._handler);
		}
		public function get parameters():Array
		{
			return (this._parameters);
		}
		public function get delay():Number
		{
			return (this._delay);
		}
		public function get doNext():Boolean
		{
			return (this._doNext);
		}
	}
}