package tempest.common.assets.loading
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;

	/**
	 * 重写URLLoader
	 * @author
	 */
	public class TPURLLoader extends URLLoader
	{
		private static const log:ILogger = TLog.getLogger(TPURLLoader);
		private var _complete:Boolean = false;
		public var maxTries:int;
		protected var _numTries:int = 0;
		protected var _request:URLRequest;

		public function TPURLLoader(request:URLRequest = null, maxTries:int = 3)
		{
			_request = request;
			this.maxTries = maxTries;
			this.addEventListener(Event.COMPLETE, onCompleteHandler, false, 0, true);
			this.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false, 100, true);
			this.addEventListener(Event.OPEN, onOpenHandler, false, 0, true);
			this.addEventListener(ProgressEvent.PROGRESS, onProgressHandler, false, 0, true);
			this.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatusHandler, false, 0, true);
			this.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityHandler, false, 0, true);
			super(request);
		}

		public function get complete():Boolean
		{
			return _complete;
		}

		protected function onCompleteHandler(event:Event):void
		{
			_complete = true;
		}

		protected function onSecurityHandler(event:SecurityErrorEvent):void
		{
			log.error("onSecurityHandler url:{0} numTries:{1}", _request.url, _numTries);
		}

		protected function onHttpStatusHandler(event:HTTPStatusEvent):void
		{
			//			trace(event);
		}

		protected function onProgressHandler(event:ProgressEvent):void
		{
			//			trace(event);
		}

		protected function onOpenHandler(event:Event):void
		{
			//			trace(event);
		}

		protected function onErrorHandler(e:IOErrorEvent):void
		{
			_numTries++;
			if (_numTries < maxTries && _request != null)
			{
				e.stopImmediatePropagation();
				reLoad();
			}
			log.error("onErrorHandler url:{0} numTries:{1}", _request.url, _numTries);
		}

		/**
		 * 重新加载
		 */
		protected function reLoad():void
		{
			super.load(_request);
		}

		public override function load(request:URLRequest):void
		{
			_request = request;
			_numTries = 0;
			super.load(request);
		}
	}
}
