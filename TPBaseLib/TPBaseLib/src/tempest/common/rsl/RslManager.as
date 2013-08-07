package tempest.common.rsl
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	import br.com.stimuli.loading.loadingtypes.ImageItem;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;

	import flash.events.Event;
	import flash.system.ApplicationDomain;


	public class RslManager
	{
		public static const TYPE_LIB:String = "lib";

		private static var _loader:BulkLoader = new BulkLoader();

		public static function init():void
		{
			BulkLoader.registerNewType("swf", TYPE_LIB, ImageLibItem);
		}

		public static function add(url:*, props:Object = null):LoadingItem
		{
			return _loader.add(url, props);
		}

		public static function getItem(key:String):LoadingItem
		{
			return _loader.get(key);
		}

		public static function getContent(key:String):*
		{
			return _loader.getContent(key);
		}

		public static function start(onComplete:Function, onProgress:Function, onError:Function, withConnections:int = -1):void
		{
			_loader.addEventListener(BulkLoader.ERROR, onError);
			_loader.addEventListener(Event.COMPLETE, function(e:Event):void
			{
				e.currentTarget.removeEventListener(e.type, arguments.callee);
				_loader.removeEventListener(BulkLoader.ERROR, onError);
				_loader.removeEventListener(BulkProgressEvent.PROGRESS, onProgress);
				onComplete(e);
			});
			_loader.addEventListener(BulkProgressEvent.PROGRESS, onProgress);
			_loader.start(withConnections);
		}

//		public static function getDefinitionByName(key:String, className:String):Object
//		{
//			var item:* = _loader.get(key);
//			var imgItem:ImageItem = item as ImageItem;
//			if (!imgItem)
//			{
//				return null;
//			}
//			return imgItem.getDefinitionByName(className);
//		}
//
//		public static function getInstanceByName(key:String, className:String):*
//		{
//			var cls:Class = getDefinitionByName(key, className) as Class;
//			if (!cls)
//			{
//				return null;
//			}
//			return new cls();
//		}

		public static function unload(key:String):void
		{
			_loader.remove(key);
		}

		public static function getDefinition(className:String):Object
		{
			if (!ApplicationDomain.currentDomain.hasDefinition(className))
			{
				throw new Error("getDefinition:定义不存在 className:" + className);
			}
			return ApplicationDomain.currentDomain.getDefinition(className);
		}

		public static function getInstance(className:String):*
		{
			var cls:Class = getDefinition(className) as Class;
			if (!cls)
			{
				return null;
			}
			return new cls();
		}
	}
}
