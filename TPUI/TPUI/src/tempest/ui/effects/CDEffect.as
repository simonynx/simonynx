package tempest.ui.effects
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;

	public class CDEffect extends TimerEffect
	{
		private var freezeCover:Shape;
		private var curEndAngle:Number;
		private static const START_ANGLE:Number = 270;
		private var angleChange:Number;
		private var _type:int;
		private var _ratio:Number;
		private var _rectModel:Boolean;
		public static const FULL_TO_EMPTY:int = 0;
		public static const EMPTY_TO_FULL:int = 1;

		public function CDEffect(target:DisplayObjectContainer, playTime:Number = 0, delay:Number = 100)
		{
			curEndAngle = START_ANGLE;
			angleChange = 360 / (playTime * 1000 / delay);
			freezeCover = new Shape();
			_rectModel = true;
			target.addChild(freezeCover);
			super(delay, target);
		}

		/**
		 * 是否使用方形的CD效果
		 * @param value
		 *
		 */
		public function set rectModel(value:Boolean):void
		{
			_rectModel = value;
		}

		override public function play():void
		{
			freezeCover.visible = true;
			super.play();
		}

		override public function stop():void
		{
			curEndAngle = START_ANGLE;
			freezeCover.graphics.clear();
			freezeCover.visible = false;
			super.stop();
		}

		/**
		 * 设置扇形角度范围
		 * @param value
		 *
		 */
		public function set ratio(value:Number):void
		{
			if (value <= 0 || value >= 1)
			{
				freezeCover.graphics.clear();
				freezeCover.visible = false;
				return;
			}
			freezeCover.visible = true;
			if (_rectModel)
			{
				freezeCover.scrollRect = new Rectangle(0, 0, target.width / target.scaleX, target.height / target.scaleY); //设置scrollRect时考虑目标被的话，加上的scrollRect也会被缩放
			}
			var center:Point = new Point((target.width / target.scaleX) / 2, (target.height / target.scaleY) / 2);
			curEndAngle = (START_ANGLE + value * 360) % 360;
			if (_type == FULL_TO_EMPTY)
			{
				this.drawSector(freezeCover, curEndAngle, center, getR(center), START_ANGLE);
			}
			else if (_type == EMPTY_TO_FULL)
			{
				this.drawSector(freezeCover, START_ANGLE, center, getR(center), curEndAngle);
			}
		}

		public function set type(value:int):void
		{
			var center:Point = new Point(target.width / 2, target.height / 2);
			_type = value;
			if (_type == FULL_TO_EMPTY)
			{
				this.drawSector(freezeCover, curEndAngle, center, getR(center), START_ANGLE);
			}
			else if (_type == EMPTY_TO_FULL)
			{
				this.drawSector(freezeCover, START_ANGLE, center, getR(center), curEndAngle);
			}
		}

		/**
		 * 根据rectModel获取扇形半径
		 * @param center
		 * @return
		 *
		 */
		public function getR(center:Point):Number
		{
			return _rectModel ? Math.sqrt(Math.pow(center.x, 2) + Math.pow(center.y, 2)) : (center.x + center.y) * 0.5;
		}

		/**
		 * 画扇形
		 * @param shape
		 * @param startAngle
		 * @param center
		 * @param r
		 * @param endAngle
		 *
		 */
		private function drawSector(shape:Shape, startAngle:Number, center:Point, r:Number, endAngle:Number):void
		{
			if (startAngle == endAngle)
			{
				return;
			}
			shape.graphics.clear();
			shape.graphics.beginFill(0x0, 0.7);
			shape.graphics.moveTo(center.x, center.y);
			var angle:Number = startAngle;
			if (angle >= endAngle)
				endAngle += 360;
			while (angle < endAngle)
			{
				var sx:Number = Math.floor(r * Math.cos(angle * Math.PI / 180));
				var sy:Number = Math.floor(r * Math.sin(angle * Math.PI / 180));
				shape.graphics.lineTo(sx + center.x, sy + center.y);
				++angle;
			}
			shape.graphics.lineTo(center.x, center.y);
			shape.graphics.endFill();
		}

		public function set direct(value:int):void
		{
		}
	}
}
