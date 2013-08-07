package tempest.engine.vo.config
{
	import tempest.engine.tools.astar.IMapModel;
	import tempest.engine.vo.map.MapTile;

	public class MapConfig
	{
		public var width:Number = 0; //地图宽度
		public var height:Number = 0; //地图高度
		public var bgMusicPath:String = "";
		public var thumbScale:Number = 1;
		public var tile_rows:int = 0;
		public var tile_cols:int = 0;
		public var isCopyMap:Boolean = false;
		public var useEarth:int = 0; //是否有地效
		public var mapTiles:Object;
		public var mapModel:IMapModel;

		/**
		 * 获取网格
		 * @param x
		 * @param y
		 * @return
		 */
		public function getMapTile(x:int, y:int):MapTile
		{
			return mapTiles[x + "_" + y];
		}

		/**
		 * 是否遮挡
		 * @param x
		 * @param y
		 * @return
		 */
		public function isMask(x:int, y:int):Boolean
		{
			var tile:MapTile = mapTiles[x + "_" + y];
			return (tile == null) ? true : tile.isMask;
		}

		/**
		 * 是否障碍
		 * @param x
		 * @param y
		 * @return
		 */
		public function isBlock(x:int, y:int):Boolean
		{
			var tile:MapTile = mapTiles[x + "_" + y];
			return (tile == null) ? true : tile.isBlock;
		}

		/**
		 * 是否畅通
		 * @param startX 起始位置X
		 * @param startY 起始位置Y
		 * @param targetX 目标位置X
		 * @param targetY 目标位置Y
		 * @return
		 */
		public function canPass(startX:int, startY:int, targetX:int, targetY:int):Boolean
		{
			if (startX == targetX && startY == targetY)
			{
				return true;
			}
			var begin:int = (startY < targetY) ? startY : targetY;
			var end:int = (startY > targetY) ? startY : targetY;
			if (startX == targetX)
			{
				for (var y:int = begin; y <= end; y++)
				{
					if (isBlock(targetX, y))
					{
						return false;
					}
				}
			}
			else
			{
				var k:Number = (targetY - startY) / (targetX - startX);
				var b:Number = (targetX * startY - targetY * targetX) / (targetX - startX);
				begin = (startX < targetX) ? startX : targetX;
				end = (startX > targetX) ? startX : targetX;
				for (var x:int = begin; x <= end; x++)
				{
					if (isBlock(x, k * x + b))
					{
						return false;
					}
				}
			}
			return true;
		}

		/**
		 * 是否传送点
		 * @param x
		 * @param y
		 * @return
		 */
		public function isTransport(x:int, y:int):Boolean
		{
			var tile:MapTile = mapTiles[x + "_" + y];
			return (tile == null) ? false : tile.isTransport;
		}
	}
}
