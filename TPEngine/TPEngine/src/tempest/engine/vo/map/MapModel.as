package tempest.engine.vo.map
{
	import flash.geom.Point;
	
	import tempest.engine.tools.astar.IMapModel;
	
	public class MapModel implements IMapModel
	{
		public var diagonal:Boolean = true; //是否启用斜向移动
		private var _terrainArr:Array;
		private var _rows:int;
		private var _cols:int;
		public function MapModel(terrainArr:Array)
		{
			this._terrainArr = terrainArr;
			this._rows = terrainArr.length;
			this._cols = terrainArr[0].length;
		}
		/**********************************************寻路**************************************/
		/**
		 * 提供可遍历的节点
		 *
		 * 这里提供的是八方向移动
		 *
		 * @param p	当前节点
		 * @return
		 *
		 */
		public function getArounds(x:int,y:int):Array
		{
			var result:Array = [];
			var _x:int;
			var _y:int;
			var canDiagonal:Boolean;
			//右
			_x = x+1;
			_y = y;
			var canRight:Boolean = !isBlock(_x,_y);
			if(canRight)
				result.push(new Point(_x,_y));
			//下
			_x = x;
			_y = y+1;
			var canDown:Boolean = !isBlock(_x,_y);
			if(canDown)
				result.push(new Point(_x,_y));
			//左
			_x = x-1;
			_y = y;
			var canLeft:Boolean = !isBlock(_x,_y);
			if(canLeft)
				result.push(new Point(_x,_y));
			//上
			_x = x;
			_y = y-1;
			var canUp:Boolean = !isBlock(_x,_y);
			if(canUp)
				result.push(new Point(_x,_y));
			if(diagonal)
			{
				//右下
				_x = x+1;
				_y = y+1;
				canDiagonal = !isBlock(_x,_y);
				if(canDiagonal&&canRight&&canDown)
					result.push(new Point(_x,_y));
				//左下
				_x = x-1;
				_y = y+1;
				canDiagonal = !isBlock(_x,_y);
				if(canDiagonal&&canLeft&&canDown)
					result.push(new Point(_x,_y));
				//左上
				_x = x-1;
				_y = y-1;
				canDiagonal = !isBlock(_x,_y);
				if(canDiagonal&&canLeft&&canUp)
					result.push(new Point(_x,_y));
				//右上
				_x = x+1;
				_y = y-1;
				canDiagonal = !isBlock(_x,_y);
				if(canDiagonal&&canRight&&canUp)
					result.push(new Point(_x,_y));
			}
			return result;
		}
		/**
		 * 是否是墙壁
		 * @param v	目标点
		 * @param cur	当前点
		 * @return
		 *
		 */
		public function isBlock(x:int,y:int):Boolean
		{
			if(x<0||x>=_cols||y<0||y>=_rows)
				return true;
			return _terrainArr[y][x];
		}
	}
}