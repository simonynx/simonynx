package tempest.engine.vo.map
{
	import tempest.utils.StringUtil;
	import tempest.engine.tools.SceneUtil;
	import tempest.engine.vo.config.SceneConfig;

	/**
	 * 网格节点
	 * @author wushangkun
	 */
	public class MapTile
	{
		public static const WALK:int = 0; //路点
		public static const MASK:int = 1; //阴影
		public static const BLOCK:int = 2; //障碍
		private var _tile_x:int;
		private var _tile_y:int;
		private var _pixel_x:int;
		private var _pixel_y:int;
		public var isMask:Boolean;
		public var isBlock:Boolean;
		public var isTransport:Boolean;

		public function MapTile(tile_x:int, tile_y:int, flag:int)
		{
			super();
			this.isMask = (flag == MASK);
			this.isBlock = (flag == BLOCK);
			this.tile_y = tile_y;
			this.tile_x = tile_x;
		}

		public function get tile_x():int
		{
			return _tile_x;
		}

		public function set tile_x(value:int):void
		{
			_tile_x = value;
			this._pixel_x = (value + 0.5) * SceneConfig.TILE_WIDTH;
		}

		public function get tile_y():int
		{
			return _tile_y;
		}

		public function set tile_y(value:int):void
		{
			_tile_y = value;
			this._pixel_y = (value + 0.5) * SceneConfig.TILE_HEIGHT;
		}

		public function get pixel_x():int
		{
			return _pixel_x;
		}

		public function set pixel_x(value:int):void
		{
			_pixel_x = value;
			this._tile_x = (value / SceneConfig.TILE_WIDTH) >> 0;
		}

		public function get pixel_y():int
		{
			return _pixel_y;
		}

		public function set pixel_y(value:int):void
		{
			_pixel_y = value;
			this._tile_y = (value / SceneConfig.TILE_HEIGHT) >> 0;
		}

		public function toString():String
		{
			return StringUtil.format("MapTile->tile_x:{0},tile_y:{1},pixel_x:{2},pixel_y:{3},isMask:{4},isBlock:{5},isTransport:{6}", _tile_x, _tile_y, _pixel_x, _pixel_y, isMask, isBlock, isTransport);
		}
	}
}
