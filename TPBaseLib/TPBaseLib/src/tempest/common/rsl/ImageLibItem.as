package tempest.common.rsl
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;

	import flash.display.Loader;
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;

	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;

	public class ImageLibItem extends LoadingItem
	{
		private static const log:ILogger = TLog.getLogger(ImageLibItem);

		private var _urlLoader:URLLoader;
		private var _loader:Loader;
		private var _decode:Function;
		private var _applicationDomain:ApplicationDomain;

		public function ImageLibItem(url:URLRequest, type:String, _uid:String)
		{
			super(url, type, _uid);
			_applicationDomain = ApplicationDomain.currentDomain;
		}

		override public function load():void
		{
			super.load();
			if (_urlLoader == null)
			{
				_urlLoader = new URLLoader();
				_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
				_urlLoader.addEventListener(ProgressEvent.PROGRESS, onProgressHandler, false, 0, true);
				_urlLoader.addEventListener(Event.COMPLETE, completeHandler, false, 0, true);
				_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler, false, 0, true);
				_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false, 100, true);
				_urlLoader.addEventListener(Event.OPEN, onStartedHandler, false, 0, true);
				_urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, super.onHttpStatusHandler, false, 0, true);
			}
			_urlLoader.load(url);
		}

		private function completeHandler(event:Event):void
		{
			var data:ByteArray = event.target.data;
			_clearUrlLoader();
			if (data == null)
			{
				log.error("Urlloader data Error.url:{0}", url.url);
				_dispatchErrorEvent(_createErrorEvent(new Error("data error")));
				return;
			}
			loadBytes(data);
		}

		public function loadBytes(bytes:ByteArray):void
		{
			if (_decode != null)
			{
				bytes = _decode(bytes);
			}
			var lc:LoaderContext = new LoaderContext(false, _applicationDomain, null);
			//AIR特性支持
			if (Capabilities.playerType == "Desktop")
			{
//				//AIR禁止跨域
//				if (_type == TRslType.RES)
//				{
//					lc.applicationDomain = _applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
//				}
				if (lc.hasOwnProperty("allowCodeImport"))
				{
					lc["allowCodeImport"] = true;
				}
				if (lc.hasOwnProperty("allowLoadBytesCodeExecution"))
				{
					lc["allowLoadBytesCodeExecution"] = true;
				}
			}
			if (_loader == null)
			{
				_loader = new Loader();
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler2, false, 0, true);
				_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false, 100, true);
			}
			_loader.loadBytes(bytes, lc);
		}

		private function completeHandler2(event:Event):void
		{
			_content = event.target.content;
			if (!_content)
			{
				log.error("data is empty.url:{0}" + url.url);
				destroy();
				_createErrorEvent(new Error("data is empty"));
			}
			else
			{
				super.onCompleteHandler(event);
//				if (hasEventListener(Event.COMPLETE))
//					dispatchEvent(new Event(Event.COMPLETE));
			}
		}

		private function _clearUrlLoader():void
		{
			if (_urlLoader != null)
			{
				_urlLoader.close();
				_urlLoader.removeEventListener(Event.COMPLETE, completeHandler);
				_urlLoader.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
				_urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
				_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
				_urlLoader = null;
			}
		}

		override public function onErrorHandler(evt:ErrorEvent):void
		{
			super.onErrorHandler(evt);
		}

		override public function onCompleteHandler(evt:Event):void
		{
			super.onCompleteHandler(evt);
		}

		override public function stop():void
		{
			if (_urlLoader)
			{
				_urlLoader.close();
			}
			if (_loader)
			{
				_loader.close();
			}
			super.stop();
		}

		override public function cleanListeners():void
		{
			if (_urlLoader)
			{
				_urlLoader.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
				_urlLoader.removeEventListener(Event.COMPLETE, completeHandler);
				_urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
				_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
				_urlLoader.removeEventListener(Event.OPEN, onStartedHandler);
				_urlLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, super.onHttpStatusHandler);
			}
			if (_loader)
			{
				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler2);
				_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
			}
		}

		override public function isImage():Boolean
		{
			return (type == BulkLoader.TYPE_IMAGE);
		}

		override public function isSWF():Boolean
		{
			return (type == BulkLoader.TYPE_MOVIECLIP);
		}

		override public function isStreamable():Boolean
		{
			return isSWF();
		}

		override public function destroy():void
		{
			stop();
			cleanListeners();
			_content = null;

			_urlLoader = null;

			// this is an player 10 only feature. as such we must check it's existence
			// with the array acessor, or else the compiler will barf on player 9
			if (_loader && _loader.hasOwnProperty("unloadAndStop") && _loader["unloadAndStop"] is Function)
			{
				_loader["unloadAndStop"](true);
			}
			else if (_loader && _loader.hasOwnProperty("unload") && _loader["unload"] is Function)
			{
				// this is an air only feature. as such we must check it's existence
				// with the array acessor, or else the compiler will barf on non air projects
				_loader["unload"]();
			}
			_loader = null;
		}

		public function getDefinition(className:String):Object
		{
			if (!ApplicationDomain.currentDomain.hasDefinition(className))
			{
				throw new Error("getDefinition:定义不存在 className:" + className);
			}
			return ApplicationDomain.currentDomain.getDefinition(className);
		}
	}
}
