package tempest.common.assets.loading
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;

	/**
	 *  重写Loader
	 * @author
	 */
	public class TPLoader extends Loader
	{
		private static const log:ILogger = TLog.getLogger(TPLoader);
		private var _complete:Boolean = false;
//		private var _failed:Boolean = false;
		private var _loading:Boolean = false;
		public var maxTries:int;
		protected var _numTries:int = 0;
		protected var _request:URLRequest;
		protected var _context:LoaderContext = null;

		public function TPLoader(maxTries:int = 3)
		{
			this.maxTries = maxTries;
			this.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler, false, 0, true);
			this.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false, 100, true);
			this.contentLoaderInfo.addEventListener(Event.OPEN, onOpenHandler, false, 0, true);
			this.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler, false, 0, true);
			this.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatusHandler, false, 0, true);
			this.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityHandler, false, 0, true);
			super();
		}

		public function get complete():Boolean
		{
			return _complete;
		}

//		public function get failed():Boolean
//		{
//			return _failed;
//		}
		public function get loading():Boolean
		{
			return _loading;
		}

		protected function onCompleteHandler(event:Event):void
		{
			_loading = false;
			_complete = true;
		}

		protected function onSecurityHandler(event:SecurityErrorEvent):void
		{
			_loading = false;
//			_failed = true;
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
			else
			{
				_loading = false;
//				_failed = true;
				onFailedHandler();
			}
			log.error("onErrorHandler url:{0} numTries:{1}", _request.url, _numTries);
		}

		/**
		 * 加载尝试失败
		 * @param e
		 *
		 */
		protected function onFailedHandler():void
		{
		}

		/**
		 * 重新加载
		 */
		protected function reLoad():void
		{
			super.load(_request, _context);
		}

		public override function load(request:URLRequest, context:LoaderContext = null):void
		{
			_request = request;
			_context = context;
			_numTries = 0;
			_loading = true;
			super.load(request, context);
		}
	}
}
