package common.flytext
{
	import flash.display.Sprite;
	import tempest.core.IPoolClient;

	public class BaseFlyText extends Sprite implements IFlyText, IPoolClient
	{
		protected var _direction:int = 1;

		public function BaseFlyText()
		{
		}

		public function get direction():int
		{
			return _direction;
		}

		public function set direction(value:int):void
		{
			_direction = value;
		}

		public function reset(args:Array):void
		{
		}

		public function dispose():void
		{
		}

		public function setText(orien:int, content:String):void
		{
		}
	}
}
