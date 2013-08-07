package tempest.engine.tools
{
	import flash.geom.Point;
	import tempest.engine.vo.config.SceneConfig;
	import tempest.engine.vo.map.MapTile;

	/**
	 * 地图辅助类
	 * @author wushangkun
	 */
	public class SceneUtil
	{
		/**
		 * 格子坐标转像素坐标
		 * @param tile 格子坐标
		 * @return 返回像素坐标
		 */
		public static function Tile2Pixel(tile:Point):Point
		{
			return new Point(((tile.x + 0.5) * SceneConfig.TILE_WIDTH) >> 0, ((tile.y + 0.5) * SceneConfig.TILE_HEIGHT) >> 0);
		}

		/**
		 * 像素坐标转格子坐标
		 * @param pixel 像素坐标
		 * @return 返回格子坐标
		 */
		public static function Pixel2Tile(pixel:Point):Point
		{
			return new Point((pixel.x / SceneConfig.TILE_WIDTH) >> 0, (pixel.y / SceneConfig.TILE_HEIGHT) >> 0);
		}

		/**
		 * 计算8方向
		 * @param current
		 * @param target
		 * @param isBevel 是否斜角
		 * @return
		 */
		public static function getDirection(current:Point, target:Point):int
		{
			var angle:Number = Math.atan2(target.y - current.y, target.x - current.x) * 180 / Math.PI;
			return (Math.round((angle + 90) / 45) + 8) % 8; //角色面向正北为0  角度+90
		}

		///////////////////////////////////////////////////////////////////////

	}
}
