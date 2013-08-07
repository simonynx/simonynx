package tempest.engine.helper
{
	import flash.geom.Point;

	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.engine.SceneCharacter;
	import tempest.engine.TScene;
	import tempest.engine.signals.SceneAction_Walk;
	import tempest.engine.staticdata.Status;
	import tempest.engine.tools.SceneCache;
	import tempest.engine.tools.SceneUtil;
	import tempest.engine.tools.astar.TAstar;
	import tempest.engine.tools.move.PathCutter;
	import tempest.engine.vo.map.MapTile;
	import tempest.engine.vo.move.MoveCallBack;
	import tempest.engine.vo.move.MoveData;

	public class MoveHelper
	{
		private static const log:ILogger = TLog.getLogger(MoveHelper);

		/**
		 * 停止移动
		 * @param char
		 * @param stand
		 */
		public static function stopMove(char:SceneCharacter, stand:Boolean = true):void
		{
			char.walkData.clear();
			if (char.isMainChar)
			{
				char.scene.hideMouseChar();
			}
			if (stand)
			{
				char.playTo(Status.STAND);
			}
		}

		/**
		 * 修正角色移动
		 * @param char
		 */
		public static function reviseMove(char:SceneCharacter):void
		{
			var walkData:MoveData = char.walkData;
			if (char.isMainChar)
			{
				if (char.getStatus() == Status.WALK)
				{
					if (walkData.walk_targetP != null)
					{
						walk(char, walkData.walk_targetP, -1, walkData.walk_standDis, walkData.walk_callBack, false);
					}
					else
					{
						walkData.clear();
					}
				}
			}
			else
			{
				walkData.clear();
			}
		}

		/**
		 * 行走到指定地点
		 * @param walker 移动主角
		 * @param targetTile 目的网格
		 * @param speed 速度
		 * @param standDis 距离阙值
		 */
		public static function walk(char:SceneCharacter, targetTile:Point, speed:Number = -1, standDis:int = 0, callBack:MoveCallBack = null, ignoreSame:Boolean = true):void
		{
			var mapTile:MapTile = char.scene.mapConfig.getMapTile(targetTile.x, targetTile.y);
			//判断目标点是否合法
			if (mapTile == null || mapTile.isBlock)
			{
				if (char.isMainChar)
				{
					char.scene.showMouseChar(targetTile, true);
					char.scene.signal.walk.dispatch(SceneAction_Walk.UNABLE, char, mapTile, null);
				}
				if (!(callBack == null) && !(callBack.onWalkUnable == null))
				{
					callBack.onWalkUnable(char, mapTile);
				}
				return;
			}
			var walkData:MoveData = char.walkData;
			if (ignoreSame && !walkData.isChanged(targetTile, standDis, speed))
			{
				walkData.walk_callBack = callBack;
				log.debug("路径重复，忽略");
				return;
			}
			//清除当前移动数据
			walkData.clear();
			//判断是否在原地
			if ((char.tile_x >> 0) == (targetTile.x >> 0) && (char.tile_y >> 0) == (targetTile.y >> 0))
			{
				if (char.isMainChar)
				{
					char.scene.hideMouseChar();
					char.scene.signal.walk.dispatch(SceneAction_Walk.ARRIVED, char, mapTile, null);
				}
				if (!(callBack == null) && !(callBack.onWalkArrived == null))
				{
					callBack.onWalkArrived(char, mapTile);
				}
				return;
			}
			//判断是否在阙值范围内
			if (standDis != 0)
			{
				if (Point.distance(char.tile, targetTile) <= standDis)
				{
					char.faceToTile(targetTile);
					if (char.isMainChar)
					{
						char.scene.hideMouseChar();
						char.scene.signal.walk.dispatch(SceneAction_Walk.ARRIVED, char, mapTile, null);
					}
					if (!(callBack == null) && !(callBack.onWalkArrived == null))
					{
						callBack.onWalkArrived(char, mapTile);
					}
					return;
				}
			}
			var path:Array = TAstar.find(char.scene.mapConfig.mapModel, char.tile_x, char.tile_y, targetTile.x, targetTile.y);
			if (path == null || path.length < 2) //未能搜索到有效路径
			{
				if (char.isMainChar)
				{
					char.scene.showMouseChar(targetTile, true);
					char.scene.signal.walk.dispatch(SceneAction_Walk.UNABLE, char, mapTile, null);
				}
				if (!(callBack == null) && !(callBack.onWalkUnable == null))
				{
					callBack.onWalkUnable(char, mapTile);
				}
				return;
			}
			var endTile:Point = path[path.length - 1];
			var tempTile:Point;
			if (standDis != 0)
			{
				var lenght:int = path.length
				for (var i:int = 0; i != lenght; i++)
				{
					tempTile = path[i];
					if (Point.distance(endTile, tempTile) <= standDis)
					{
						path = path.slice(0, i + 1);
						break;
					}
				}
			}
			walk0(char, path, targetTile, speed, standDis, callBack);
		}

		/**
		 *
		 * @param walker
		 * @param path
		 * @param targetTile
		 * @param speed
		 * @param standDis
		 */
		public static function walk0(char:SceneCharacter, path:Array, targetTile:Point = null, speed:Number = -1, standDis:int = 0, callBack:MoveCallBack = null, keyMove:Boolean = false):void
		{
			if (path.length < 2) //一段路径至少包含起点和终点
				return;
			var walkData:MoveData = char.walkData;
			walkData.clear(); //清空移动数据
			if (char.isMainChar) //主角发包处理
			{
				if (walkData.walk_pathCutter == null)
				{
					walkData.walk_pathCutter = new PathCutter(char);
				}
				walkData.walk_pathCutter.cutMovePath(path); //路径分段
				walkData.walk_pathCutter.walkNext(-1, -1);
			}
			if (speed >= 0)
			{
				char.walkData.walk_speed = speed;
			}
			var targetP:Point = path[path.length - 1];

			if (targetTile != null)
			{
				walkData.walk_targetP = targetTile;
			}
			else
			{
				walkData.walk_targetP = targetP;
			}
			walkData.walk_standDis = standDis;
			walkData.walk_callBack = callBack;
			var currentP:Point = path.shift();
			//修正坐标  这里有待改善。。。。
			if (Math.abs(char.tile_x - currentP.x) > 1 || Math.abs(char.tile_y - currentP.y) > 1)
			{
				char.tile = currentP;
			}
			else
			{
//				//微调路径
//				var nextP:Point = path[0];
//				var l:TLine = new TLine(SceneUtil.Tile2Pixel(char.tile), SceneUtil.Tile2Pixel(nextP));
//				if (!l.isOnLine(char.pixel))
//				{
////					sc.resetPixel(TMath.getPerpendicularFoot2(l, sc.pixelP));
//					walkData.walk_fixP = TMath.getPerpendicularFoot2(l, char.pixel)
//				}
			}
			walkData.walk_pathArr = path;
			var targetMapTile:MapTile = char.scene.mapConfig.getMapTile(targetP.x, targetP.y);
			//主角发送移动开始事件
			if (char.isMainChar && !keyMove)
			{
				char.scene.showMouseChar(targetP);
				char.scene.signal.walk.dispatch(SceneAction_Walk.READY, char, targetMapTile, path);
			}
			if (!(callBack == null) && !(callBack.onWalkReady == null))
			{
				callBack.onWalkReady(char, targetMapTile, path);
			}
		}

		/**
		 * 行走到指定地点
		 * @param walker 移动主角
		 * @param targetTile 目的网格
		 * @param speed 速度
		 * @param standDis 距离阙值
		 */
		public static function walk1(char:SceneCharacter, vecX:int, vecY:int, speed:Number = -1):void
		{
			var path:Array = getPathByVec(char, char.tile_x, char.tile_y, vecX, vecY);
			var targetTile:Point = path[path.length - 1];
			var walkData:MoveData = char.walkData;
			if (!walkData.isChanged(targetTile, 0, speed))
			{
				walkData.walk_callBack = null;
				return;
			}
			//清除当前移动数据
			walkData.clear();
			//判断是否在原地
			if ((char.tile_x >> 0) == (targetTile.x >> 0) && (char.tile_y >> 0) == (targetTile.y >> 0))
			{
				if (char.isMainChar)
				{
					char.scene.hideMouseChar();
				}
				return;
			}
			if (path.length < 2) //未能搜索到有效路径
			{
				return;
			}
			var endTile:Point = path[path.length - 1];
			var tempTile:Point;
			walk0(char, path, targetTile, speed, 0, null, true);
		}

		private static function getPathByVec(char:SceneCharacter, start_x:int, start_y:int, vecX:int, vecY:int):Array
		{
			var path:Array = [new Point(start_x, start_y)];
			var current_x:int = start_x;
			var current_y:int = start_y;
			current_x += vecX;
			current_y += vecY;
			while (current_x >= 0 && current_y >= 0 && !char.scene.mapConfig.isBlock(current_x, current_y))
			{
				path.push(new Point(current_x, current_y));
				current_x += vecX;
				current_y += vecY;
			}
			return path;
		}

		///////////////////////////////////////////////////////////////
		public static function lineTo(char:SceneCharacter, pixel:Point, speed:Number, callBack:MoveCallBack = null):void
		{
		}
	}
}
