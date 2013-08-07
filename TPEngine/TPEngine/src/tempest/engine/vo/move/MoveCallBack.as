package tempest.engine.vo.move
{
	
	/**
	 * 移动回调函数
	 * @author wushangkun
	 */
	public class MoveCallBack
	{
		public var onWalkReady:Function;
		public var onWalkThrough:Function;
		public var onWalkArrived:Function;
		public var onWalkUnable:Function;
		public function clone():MoveCallBack
		{
			var moveCallBack:MoveCallBack = new MoveCallBack();
			moveCallBack.onWalkReady = this.onWalkReady;
			moveCallBack.onWalkThrough = this.onWalkThrough;
			moveCallBack.onWalkArrived = this.onWalkArrived;
			moveCallBack.onWalkUnable = this.onWalkUnable;
			return (moveCallBack);
		}
	}
}