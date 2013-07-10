package common
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	import br.com.stimuli.loading.loadingtypes.ImageItem;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;

	import flash.events.Event;

	public class RslMananger
	{
		private static var _loader:BulkLoader = new BulkLoader();

		public static function add(url:*, props:Object = null):LoadingItem
		{
			return _loader.add(url, props);
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

		public static function getDefinitionByName(key:String, className:String):Object
		{
			var item:* = _loader.get(key);
			var imgItem:ImageItem = item as ImageItem;
			if (!imgItem)
			{
				return null;
			}
			return imgItem.getDefinitionByName(className);
		}
	}
}
