package fj1.common.vo.element
{
	import fj1.common.staticdata.SceneCharacterType;

	import flash.display.DisplayObjectContainer;

	/**
	 * 传送点
	 * @author wushangkun
	 */
	public class Transport extends TDynamicElement
	{
		/**
		 * 地图ID
		 * @default
		 */
		public var mapId:int;
		/**
		 * 目标地图ID
		 * @default
		 */
		public var targetMapId:int;
		/**
		 * 目标地图坐标
		 * @default
		 */
		public var targetCoordX:int;
		/**
		 *
		 * @default
		 */
		public var targetCoordY:int;

		/**
		 *显示ID
		 * @param displayID
		 *
		 */
		public function Transport(displayID:int)
		{
			super(SceneCharacterType.TRANSPORT, displayID);
			this._headFace.y = -80;
			this.priority = 99;
		}

		/**
		 *移除传送门
		 *
		 */
		public override function dispose():void
		{
			super.dispose();
		}

		/**
		 *是否鼠标移动到对象
		 * @return
		 *
		 */
		public override function get isMouseHit():Boolean
		{
			return ani && ani.bodySource && (((ani.bodySource.getPixel32(ani.body.mouseX, ani.body.mouseY) >> 24) & 0xFF) > 0);
		}

		override public function set fullName(value:String):void
		{
			if (_fullName != value)
			{
				_fullName = value;
				this._headFace.setNickName(_fullName, 0xFFFFFF);
				this._headFace.run(0);
				this._headFace.update();
			}
		}
	}
}
