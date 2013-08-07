package tempest.engine.tools.move
{
	import flash.geom.Point;
	import tempest.TPEngine;
	import tempest.engine.SceneCharacter;
	import tempest.engine.SceneRender;
	import tempest.engine.signals.SceneAction_Walk;
	import tempest.engine.staticdata.Status;
	import tempest.engine.tools.SceneUtil;
	import tempest.engine.vo.config.SceneConfig;
	import tempest.engine.vo.map.MapTile;
	import tempest.engine.vo.move.MoveData;
	import tempest.utils.Geom;
	import tempest.utils.TMath;

	/**
	 * 行走步进
	 * @author wushangkun
	 */
	public class WalkStep
	{
//		public static var realMove:Boolean = true;
		public static function Step(sc:SceneCharacter):void
		{
			var need_f:Number;
			var mapTile:MapTile;
			//如果角色死亡 停止移动
			if (sc.getStatus() == Status.DEAD)
			{
				sc.walkData.clear();
				return;
			}
			var walkData:MoveData = sc.walkData;
			//没有路径点了
			if (walkData.walk_pathArr == null || walkData.walk_pathArr.length == 0)
			{
				if (sc.getStatus() == Status.WALK)
					sc.playTo(Status.STAND);
				return;
			}
			var dis_per_f:Number = walkData.walk_speed / SceneConfig.TILE_WIDTH / TPEngine.fps; //每帧x方向移动距离
			var nowTime:uint = SceneRender.nowTime; //当前时间
			if (walkData.walk_lastTime != nowTime)
			{
				if (walkData.walk_lastTime != 0)
				{
					need_f = (nowTime - walkData.walk_lastTime /*上次移动时间*/) * 0.001 * TPEngine.fps; //计算已经经过了多少帧
					dis_per_f = dis_per_f * need_f;
				}
				walkData.walk_lastTime = nowTime;
			}
			var stepData:Object = stepDistance(sc, dis_per_f);
			var currentTile:Point = stepData.currentTile;
			var throughTileArr:Array = stepData.throughTileArr;
			sc.faceToTile(currentTile);
			sc.playTo(Status.WALK);
			sc.tile = currentTile;
//			sc.pixel = currentPixel;
			var throughTile:Point;
			for each (throughTile in throughTileArr)
			{
				if (sc == sc.scene.mainChar)
				{
					walkData.walk_pathCutter.walkNext(throughTile.x, throughTile.y);
					sc.scene.signal.walk.dispatch(SceneAction_Walk.THROUGH, sc, sc.scene.mapConfig.getMapTile(throughTile.x, throughTile.y), null);
				}
				if (!(walkData.walk_callBack == null) && !(walkData.walk_callBack.onWalkThrough == null))
				{
					walkData.walk_callBack.onWalkThrough(sc, sc.scene.mapConfig.getMapTile(throughTile.x, throughTile.y));
				}
			}
			if (walkData.walk_pathArr == null)
			{
				return;
			}
			if (walkData.walk_pathArr.length == 0)
			{
				sc.playTo(Status.STAND);
				sc.faceToTile(walkData.walk_targetP);
				mapTile = sc.scene.mapConfig.getMapTile(sc.tile_x, sc.tile_y);
				if (sc == sc.scene.mainChar)
				{
					sc.scene.hideMouseChar();
					sc.scene.signal.walk.dispatch(SceneAction_Walk.ARRIVED, sc, mapTile, null);
				}
				if (!(walkData.walk_callBack == null) && !(walkData.walk_callBack.onWalkArrived == null))
				{
					walkData.walk_callBack.onWalkArrived(sc, mapTile);
				}
				walkData.clear();
			}
		}

		/**
		 * 步长计算
		 * @param char
		 * @param _d_per_f
		 * @return
		 */
		private static function stepDistance(sc:SceneCharacter, ssf:Number):Object
		{
			var targetTile:Point;
			var stepData:Object = {currentTile: sc.tile.clone(), throughTileArr: []};
			var currentTile:Point = stepData.currentTile;
			var throughTileArr:Array = stepData.throughTileArr;
			var throughTile:Point;
			var dis:Number;
			var walkData:MoveData = sc.walkData;
			var pathArr:Array = walkData.walk_pathArr;
			while (true)
			{
				targetTile = pathArr[0]; //(walkData.walk_fixP == null) ? SceneUtil.Tile2Pixel(pathArr[0]) : walkData.walk_fixP;
				dis = Point.distance(currentTile, targetTile);
//				if (realMove)
//				{
//					var radian:Number = Math.abs(Math.atan((targetPixel.y - currentPixel.y) / (targetPixel.x - currentPixel.x)));
//					if (radian % Math.PI == 0)
//					{
//						ssf *= Math.cos(SceneUtil.BEVEL_RAD);
//					}
//					else if (radian % (Math.PI * 0.5) == 0)
//					{
//						ssf *= Math.sin(SceneUtil.BEVEL_RAD);
//					}
//				}
				if (dis > ssf) //不足以到达
				{
					currentTile.x += (targetTile.x - currentTile.x) * ssf / dis;
					currentTile.y += (targetTile.y - currentTile.y) * ssf / dis;
					return (stepData);
				}
				if (dis == ssf) //刚好到达目标点
				{
//					if (walkData.walk_fixP == null)
//					{
//						throughTile = pathArr.shift();
//						throughTileArr.push(throughTile);
//					}
//					else
//					{
//						walkData.walk_fixP = null;
//					}
					currentTile.x = targetTile.x;
					currentTile.y = targetTile.y;
					return (stepData);
				}
				if (walkData.walk_fixP == null)
				{
					throughTile = pathArr.shift();
					throughTileArr.push(throughTile);
				}
				else
				{
					walkData.walk_fixP = null;
				}
				currentTile.x = targetTile.x;
				currentTile.y = targetTile.y;
				ssf -= dis;
				if (pathArr.length == 0)
					return (stepData);
			}
			return (stepData);
		}
	}
}
