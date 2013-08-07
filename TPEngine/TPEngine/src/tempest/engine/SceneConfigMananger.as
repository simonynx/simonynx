package tempest.engine
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;

	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import tempest.engine.staticdata.BulkLoaderType;
	import tempest.engine.tools.loader.MapConfigLoader;
	import tempest.engine.vo.config.MapConfig;
	import tempest.engine.vo.map.MapModel;
	import tempest.engine.vo.map.MapTile;

	import tpe.manager.FilePathManager;

	public class SceneConfigMananger
	{
		private static var _loader:BulkLoader = new BulkLoader();

		public static function init():void
		{
//			_loader.registerNewType();
		}

		public static function getMapConfigLoader(resId:int):MapConfigLoader
		{
			var path:String = FilePathManager.getPath("scene/" + resId + "/map.xml");
			var loadingItem:LoadingItem = _loader.get(resId);
			if (!loadingItem)
			{
				loadingItem = _loader.add(path, {key: resId, type: BulkLoaderType.MAP_CONFIG_LOADER});
				_loader.start();
			}
			return loadingItem as MapConfigLoader;
		}
	}
}
