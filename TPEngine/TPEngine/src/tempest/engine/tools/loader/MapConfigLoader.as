package tempest.engine.tools.loader
{
	import br.com.stimuli.loading.loadingtypes.XMLItem;

	import flash.events.Event;
	import flash.net.URLRequest;

	import tempest.engine.vo.config.MapConfig;
	import tempest.engine.vo.map.MapModel;
	import tempest.engine.vo.map.MapTile;

	public class MapConfigLoader extends XMLItem
	{
		private var _mapConfig:MapConfig;

		public function MapConfigLoader(url:URLRequest, type:String, uid:String)
		{
			super(url, type, uid);
			this.addEventListener(Event.COMPLETE, onComplete);
		}

		override public function load():void
		{
			super.load();
			loader.addEventListener(Event.COMPLETE, onComplete);
		}

		public function get mapConfig():MapConfig
		{
			return _mapConfig;
		}

		private function onComplete(e:Event):void
		{
			_mapConfig = new MapConfig();
			_mapConfig.width = parseFloat(content.@mapwidth);
			_mapConfig.height = parseFloat(content.@mapheight);
			_mapConfig.bgMusicPath = content.items.background.@path;
			_mapConfig.tile_rows = parseInt(content.floor.@row);
			_mapConfig.tile_cols = parseInt(content.floor.@column);
			_mapConfig.thumbScale = parseFloat(content.@thumbScale);
			_mapConfig.useEarth = parseInt(content.@useEarth);

			var tempArr:Array = content.floor.split(',');
			var terrainArr:Array = new Array(_mapConfig.tile_rows);
			var flag:int;
			var mapTiles:Object = {};
			for (var y:int = 0; y != _mapConfig.tile_rows; y++)
			{
				terrainArr[y] = new Array(_mapConfig.tile_cols);
				for (var x:int = 0; x != _mapConfig.tile_cols; x++)
				{
					flag = tempArr[y * _mapConfig.tile_cols + x];
					terrainArr[y][x] = (flag == 2);
					mapTiles[x + "_" + y] = new MapTile(x, y, flag);
				}
			}

			_mapConfig.mapTiles = mapTiles;
			_mapConfig.mapModel = new MapModel(terrainArr);
		}
	}
}
