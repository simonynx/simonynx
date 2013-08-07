package tempest.engine.tools.move
{
	import flash.geom.Point;
	import tempest.common.graphics.TLine;
	import tempest.engine.SceneCharacter;
	import tempest.engine.signals.SceneAction_Walk;

	/**
	 * 路径截断
	 * @author wushangkun
	 */
	public class PathCutter
	{
		public var sc:SceneCharacter;
		private var movePaths:Array;
		private var sourcePath:Array;
		private var currentMoveTag:int = 0;

		public function PathCutter(sc:SceneCharacter)
		{
			this.sc = sc;
		}

		public function clear():void
		{
			this.sourcePath = null;
			this.movePaths = null;
			this.currentMoveTag = 0;
		}

		/**
		 * 走到下一点
		 * @param next_x
		 * @param next_y
		 */
		public function walkNext(next_x:int, next_y:int):void
		{
			if (movePaths == null || movePaths.length == 0)
			{
				return;
			}
			var movePath:Array = this.movePaths[currentMoveTag];
			var endTile:Point = movePath[movePath.length - 1];
			if (endTile.x == next_x && endTile.y == next_y) //如果是当前路径的终点
			{
				++this.currentMoveTag;
				movePath = this.movePaths[currentMoveTag];
				if (movePath == null || movePath.length < 2)
				{
					return;
				}
				//发送下一路径
				sc.scene.signal.walk.dispatch(SceneAction_Walk.SENDPATH, sc, null, movePath);
			}
			else
			{
				if (next_x == -1 && next_y == -1)
				{
					//发送路径
					sc.scene.signal.walk.dispatch(SceneAction_Walk.SENDPATH, sc, null, movePath);
				}
			}
		}

		public function cutMovePath(sourcePath:Array):void
		{
			//======================固定点算法==========================
//			if(sourcePath.length<1)
//			{
//				return;
//			}
//			this.movePaths = [];
//			this.currentMoveTag = 0;
//			this.sourcePath = sourcePath;
//			var count:int = this.sourcePath.length;
//			var movePath:Array = [];
//			var tempP:Point;
//			for(var i:int = 0;i!=count;i++)
//			{
//				movePath.push(this.sourcePath[i]);
//				if((i!=0&&i%6==0)||i==count-1)
//				{
//					if(this.movePaths.length!=0)
//					{
//						movePath.splice(0,0,tempP);
//					}
//					tempP = this.sourcePath[i];
//					this.movePaths.push(movePath);
//					movePath = [];
//				}
//			}
			//===================拐点算法===========================
			if (sourcePath.length < 2)
			{
				return;
			}
			this.movePaths = [];
			this.currentMoveTag = 0;
			this.sourcePath = sourcePath;
			var count:int = this.sourcePath.length;
			var line:TLine = new TLine(sourcePath[0], sourcePath[1]);
			for (var i:int = 2; i < count; i++)
			{
				if (!line.isOnLine(sourcePath[i]))
				{
					this.movePaths.push([line.p1, line.p2]);
					line.p1 = line.p2;
				}
				line.p2 = sourcePath[i];
			}
			this.movePaths.push([line.p1, line.p2]);
		}
	}
}
